import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tab", "panel"]
  static classes = ["active"]

  connect() {
    this.activeClass = this.hasActiveClass ? this.activeClass : "text-blue-600 border-b-2 border-blue-600 bg-blue-50/30"
  }

  switch(event) {
    const tab = event.currentTarget
    const tabId = tab.dataset.tabId

    this.tabTargets.forEach(t => {
      t.classList.remove(...this.activeClass.split(" "))
      t.classList.add("text-gray-600", "hover:text-gray-800", "hover:bg-gray-50")
    })
    tab.classList.add(...this.activeClass.split(" "))
    tab.classList.remove("text-gray-600", "hover:text-gray-800", "hover:bg-gray-50")

    this.panelTargets.forEach(p => {
      p.classList.toggle("hidden", p.dataset.panelId !== tabId)
    })
  }
}
