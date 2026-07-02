import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container"]
  static values = { stagger: { type: Number, default: 0 } }

  connect() {
    if (this.staggerValue > 0 && this.hasContainerTarget) {
      const children = this.containerTarget.children
      Array.from(children).forEach((child, i) => {
        child.classList.add("animate-slide-up")
        child.style.animationDelay = `${(i + 1) * this.staggerValue}ms`
      })
    }
  }
}
