import { Controller } from "@hotwired/stimulus"
export default class extends Controller {
  static targets = ["step", "cookingDeviceError"]

  connect() {
    this.currentStep = Number(sessionStorage.getItem("profileStep")) || 0
    this.showCurrentStep()
  }

  next() {
    const currentStep = this.stepTargets[this.currentStep]
    const inputs = currentStep.querySelectorAll("input, select, textarea")
    for (const input of inputs) {
      if (!input.reportValidity()) {
        return
      }
    }
    if (!this.validateCurrentStep(currentStep)) {
      return
    }
    if (this.currentStep < this.stepTargets.length - 1) {
      this.currentStep++
      this.showCurrentStep()
    }
    sessionStorage.setItem("profileStep", this.currentStep)
  }

  validateCurrentStep(step) {
    const cookingDevices = step.querySelectorAll('input[name="profile[cooking_device_ids][]"]')
    if (cookingDevices.length > 0) {
      const checked = [...cookingDevices].some(input => input.checked)
      if (!checked) {
        this.cookingDeviceErrorTarget.classList.remove("d-none")
        return false
      }
      this.cookingDeviceErrorTarget.classList.add("d-none")
    }
    return true
  }

  previous() {
    if (this.currentStep > 0) {
      this.currentStep--
      this.showCurrentStep()
    }
  }

  showCurrentStep() {
    this.stepTargets.forEach((step, index) => {
      step.classList.toggle("d-none", index !== this.currentStep)
    })
  }
}
