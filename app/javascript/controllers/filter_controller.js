import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form", "clearable"]

  submit() {
    this.formTarget.requestSubmit()
  }

  clear() {
    this.clearableTargets.forEach(el => {
      if (el.tagName === "SELECT") el.selectedIndex = 0
      if (el.tagName === "INPUT") el.value = ""
    })
    this.formTarget.requestSubmit()
  }

  hasActiveFilters() {
    return this.clearableTargets.some(el => {
      if (el.tagName === "SELECT") return el.selectedIndex > 0
      if (el.tagName === "INPUT") return el.value.length > 0
      return false
    })
  }
}
