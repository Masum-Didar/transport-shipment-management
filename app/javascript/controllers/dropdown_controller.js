import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]

  connect() {
    this.open = false
  }

  toggle(event) {
    event.stopPropagation()
    this.open = !this.open
    this.menuTarget.classList.toggle("hidden", !this.open)
  }

  hide(event) {
    if (this.open && !this.element.contains(event.target)) {
      this.open = false
      this.menuTarget.classList.add("hidden")
    }
  }
}
