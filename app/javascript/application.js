// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"

// app/javascript/application.js
import { togglePasswordVisibility, validatePasswordMatch } from "./utils/form_helpers";

window.togglePasswordVisibility = togglePasswordVisibility;
window.validatePasswordMatch = validatePasswordMatch;

import { Application } from "@hotwired/stimulus"
import ToggleController from "./controllers/toggle_controller"

const application = Application.start()
application.register("toggle", ToggleController)


// prismjsの記述---
import 'prismjs';
import 'prismjs/components/prism-ruby';
import 'prismjs/components/prism-javascript';
import 'prismjs/components/prism-typescript';
import 'prismjs/components/prism-json';
import 'prismjs/components/prism-markup'; // HTML
import 'prismjs/components/prism-css';
import 'prismjs/components/prism-scss';
import 'prismjs/components/prism-markdown';
import 'prismjs/components/prism-yaml';
import 'prismjs/components/prism-bash';
import 'prismjs/components/prism-python';

// 他の言語も必要ならここに追加

// 行番号
import 'prismjs/plugins/line-numbers/prism-line-numbers.js';
import 'prismjs/plugins/line-numbers/prism-line-numbers.css';

// 好きなテーマを読み込む（今回は dark）
import 'prismjs/themes/prism-tomorrow.css';

document.addEventListener('DOMContentLoaded', () => {
  Prism.highlightAll();
});

document.addEventListener('turbo:load', () => {
  Prism.highlightAll();
});
// ---