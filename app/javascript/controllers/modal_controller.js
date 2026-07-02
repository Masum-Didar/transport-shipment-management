import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dialog"]

  connect() {
    document.body.classList.add("overflow-hidden")
    this.element.classList.add("animate-fade-in")
    if (this.hasDialogTarget) {
      this.dialogTarget.classList.add("animate-scale-in")
    }
    document.addEventListener("keydown", this._handleEscape)
  }

  disconnect() {
    document.body.classList.remove("overflow-hidden")
    document.removeEventListener("keydown", this._handleEscape)
  }

  close() {
    this.element.remove()
  }

  backdropClose(event) {
    if (event.target === event.currentTarget) {
      this.close()
    }
  }

  _handleEscape = (event) => {
    if (event.key === "Escape") this.close()
  }
}
