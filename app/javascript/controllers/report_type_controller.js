import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form"]

  connect() {
    this.toggleFilters()
  }

  toggleFilters() {
    const type = this.element.querySelector("[name='report_type']").value
    this.element.querySelectorAll("[data-filter-group]").forEach(el => {
      el.classList.toggle("hidden", el.dataset.filterGroup !== type)
    })
  }

  change() {
    this.toggleFilters()
    this.formTarget.requestSubmit()
  }
}
