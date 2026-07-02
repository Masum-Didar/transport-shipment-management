import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["desktopSidebar", "mobileSidebar", "overlay", "content"]
  static values = { collapsed: { type: Boolean, default: false } }

  toggleMobile() {
    this.mobileSidebarTarget.classList.toggle("hidden")
    this.overlayTarget.classList.toggle("hidden")
    document.body.classList.toggle("overflow-hidden")
  }

  closeMobile() {
    this.mobileSidebarTarget.classList.add("hidden")
    this.overlayTarget.classList.add("hidden")
    document.body.classList.remove("overflow-hidden")
  }

  toggleDesktop() {
    this.collapsedValue = !this.collapsedValue
    this.desktopSidebarTarget.classList.toggle("w-64")
    this.desktopSidebarTarget.classList.toggle("w-16")
    this.contentTarget.classList.toggle("lg:ml-64")
    this.contentTarget.classList.toggle("lg:ml-16")
    document.body.classList.toggle("sidebar-collapsed")
  }
}
