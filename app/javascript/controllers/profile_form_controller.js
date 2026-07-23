import { Controller } from "@hotwired/stimulus"
export default class extends Controller {
  static targets = ["step"]

  connect() {
    this.currentStep = 0
    this.showCurrentStep()
  }

  next() {
    if (this.currentStep < this.stepTargets.length - 1) {
      this.currentStep++
      this.showCurrentStep()
    }
  }

  back() {
    if (this.currentStep > 0) {
      this.currentStep--
      this.showCurrentStep()
    }
  }

  showCurrentStep() {
    this.stepTargets.forEach(step, index) => {
      step.classList.toggle("d-none", index !== this.currentStep)
    }
  }
}
