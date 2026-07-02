import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { delay: { type: Number, default: 4000 } }

  connect() {
    this.element.classList.add("animate-slide-in-right")
    setTimeout(() => {
      this.element.style.transition = "opacity 0.3s ease, transform 0.3s ease"
      this.element.style.opacity = "0"
      this.element.style.transform = "translateX(100%)"
      setTimeout(() => this.element.remove(), 300)
    }, this.delayValue)
  }
}
