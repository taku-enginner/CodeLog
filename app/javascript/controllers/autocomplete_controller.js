// app/javascript/controllers/autocomplete_controller.js
import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static values = { url: String };

  connect() {
    this.results = document.getElementById('autocomplete-results');
  }

  async search(event) {
    const query = event.target.value.trim();
    if (query.length === 0) {
      this.results.classList.add('hidden');
      return;
    }

    const res = await fetch(`${this.urlValue}?q=${encodeURIComponent(query)}`);
    const data = await res.json();

    this.results.innerHTML = data
      .map(
        (path) => `
      <li class="px-2 py-1 hover:bg-gray-100 cursor-pointer" data-path="${path}">
        ${path}
      </li>
    `
      )
      .join('');

    this.results.classList.remove('hidden');

    this.results.querySelectorAll('li').forEach((li) => {
      li.addEventListener('click', () => {
        const selected = li.dataset.path;
        const form = this.element.closest('form');
        const input = this.element;
        input.value = selected;
        form.submit();
      });
    });
  }
}
