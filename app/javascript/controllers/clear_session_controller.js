import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="clear-session"
export default class extends Controller {
  connect() {
    sessionStorage.removeItem("profileStep")
  }
}
