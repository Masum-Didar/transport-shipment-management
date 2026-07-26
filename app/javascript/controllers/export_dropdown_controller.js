import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.element.querySelectorAll("a").forEach(link => {
      link.addEventListener("click", () => this.close())
    })
  }

  close() {
    this.element.removeAttribute("open")
  }
}
