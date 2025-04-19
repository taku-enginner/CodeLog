// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"

// app/javascript/application.js
import { togglePasswordVisibility, validatePasswordMatch } from "./utils/form_helpers";

window.togglePasswordVisibility = togglePasswordVisibility;
window.validatePasswordMatch = validatePasswordMatch;
