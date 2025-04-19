// app/javascript/utils/form_helpers.js

export function togglePasswordVisibility(fieldId, button) {
  const input = document.getElementById(fieldId);
  const [eyeOpen, eyeClosed] = button.querySelectorAll(".eye");

  const isHidden = input.type === "password";
  input.type = isHidden ? "text" : "password";

  eyeOpen.classList.toggle("hidden", !isHidden);
  eyeClosed.classList.toggle("hidden", isHidden);
}

export function validatePasswordMatch(options = {}) {
  const {
    passwordFieldId = "password_field",
    confirmationFieldId = "password_confirmation_field",
    errorMessageId = "password-error-message",
    ruleMessageId = "password-rule-message",
    submitButtonId = "submit-button",
  } = options;

  const password = document.getElementById(passwordFieldId)?.value || "";
  const confirmation = document.getElementById(confirmationFieldId)?.value || "";
  const message = document.getElementById(errorMessageId);
  const ruleMessage = document.getElementById(ruleMessageId);
  const submitBtn = document.getElementById(submitButtonId);

  const isMismatch = confirmation && password !== confirmation;
  const isValidLength = password.length >= 6;
  const hasLowercase = /[a-z]/.test(password);
  const hasUppercase = /[A-Z]/.test(password);
  const hasSymbol = /[^A-Za-z0-9]/.test(password);
  const isStrongEnough = isValidLength && hasLowercase && hasUppercase && hasSymbol;
  const isInvalid = isMismatch || !isStrongEnough;

  if (message) message.classList.toggle("invisible", !isMismatch);
  if (ruleMessage) ruleMessage.classList.toggle("invisible", isStrongEnough);

  if (submitBtn) {
    submitBtn.disabled = isInvalid;
    submitBtn.classList.toggle("opacity-50", isInvalid);
    submitBtn.classList.toggle("cursor-not-allowed", isInvalid);
  }
}
