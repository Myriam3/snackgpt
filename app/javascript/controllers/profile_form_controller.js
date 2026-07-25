import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "step",
    "stepLabel",
    "stepTitle",
    "stepDot",
    "progressBar",
    "progressFill",
    "cookingDeviceError"
  ]

  connect() {
    const savedStep = Number(sessionStorage.getItem("profileStep"))

    this.currentStep =
      Number.isInteger(savedStep) &&
      savedStep >= 0 &&
      savedStep < this.stepTargets.length
        ? savedStep
        : 0

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
      this.currentStep += 1
      sessionStorage.setItem("profileStep", this.currentStep)
      this.showCurrentStep()
    }
  }

  validateCurrentStep(step) {
    const allergyInputs = step.querySelectorAll(
      'input[name="profile[allergy_ids][]"]'
    )

    if (allergyInputs.length > 0) {
      const hasAllergy = [...allergyInputs].some((input) => input.checked)

      if (!hasAllergy) {
        const confirmed = window.confirm(
          "Are you sure you don't have allergies?"
        )

        if (!confirmed) {
          return false
        }
      }
    }

    const cookingDevices = step.querySelectorAll(
      'input[name="profile[cooking_device_ids][]"]'
    )

    if (cookingDevices.length > 0) {
      const hasCookingDevice = [...cookingDevices].some(
        (input) => input.checked
      )

      if (!hasCookingDevice) {
        this.cookingDeviceErrorTarget.classList.remove("d-none")
        return false
      }

      this.cookingDeviceErrorTarget.classList.add("d-none")
    }

    return true
  }

  previous() {
    if (this.currentStep > 0) {
      this.currentStep -= 1
      sessionStorage.setItem("profileStep", this.currentStep)
      this.showCurrentStep()
    }
  }

  showCurrentStep() {
    const totalSteps = this.stepTargets.length
    const stepNumber = this.currentStep + 1
    const currentStep = this.stepTargets[this.currentStep]

    this.stepTargets.forEach((step, index) => {
      step.classList.toggle("d-none", index !== this.currentStep)
    })

    if (this.hasStepLabelTarget) {
      this.stepLabelTarget.textContent = `Step ${stepNumber} of ${totalSteps}`
    }

    if (this.hasStepTitleTarget) {
      this.stepTitleTarget.textContent =
        currentStep.dataset.stepTitle || ""
    }

    if (this.hasProgressBarTarget) {
      this.progressBarTarget.setAttribute("aria-valuenow", stepNumber)
    }

    if (this.hasProgressFillTarget) {
      const progress = (stepNumber / totalSteps) * 100
      this.progressFillTarget.style.width = `${progress}%`
    }

    this.stepDotTargets.forEach((dot, index) => {
      dot.classList.toggle("is-active", index === this.currentStep)
      dot.classList.toggle("is-complete", index < this.currentStep)
    })
  }
}
