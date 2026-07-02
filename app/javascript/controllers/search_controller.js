import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "form"]
  static values = { delay: { type: Number, default: 300 } }

  connect() {
    this.timeout = null
  }

  search() {
    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => {
      this.formTarget.requestSubmit()
    }, this.delayValue)
  }

  clear() {
    this.inputTarget.value = ""
    this.formTarget.requestSubmit()
  }
}
