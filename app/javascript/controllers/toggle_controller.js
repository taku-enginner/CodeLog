import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content"]

  toggle() {
    console.log("toggle fired") // ← テスト用
    this.contentTarget.classList.toggle("hidden")
  }
}
