import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  complete() {
    console.log(this);
    console.log("this.element =", this.element)
    console.log("action =", this.element.action)
    console.log("event.target =", event.target)
    this.element.requestSubmit();
  }
}
