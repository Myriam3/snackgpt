import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "step",
    "stepLabel",
    "stepTitle",
    "stepDot",
    "progressBar",
    "progressFill",
    "cookingDeviceError",
    "customAllergyInput",
    "customAllergyList",
    "customCookingDeviceInput",
    "customCookingDeviceList"
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

  addAllergy() {
    this.addCustomOption(
      this.customAllergyInputTarget,
      this.customAllergyListTarget,
      "profile[custom_allergies][]"
    )
  }

  addCookingDevice() {
    this.addCustomOption(
      this.customCookingDeviceInputTarget,
      this.customCookingDeviceListTarget,
      "profile[custom_cooking_devices][]"
    )
  }

  addCustomOption(input, list, fieldName) {
    const name = input.value.trim()

    if (name === "") {
      return
    }

    const item = document.createElement("span")
    item.className = "profile-custom-option__item"
    item.textContent = name

    const removeButton = document.createElement("button")
    removeButton.type = "button"
    removeButton.className = "profile-custom-option__remove"
    removeButton.textContent = "Remove"

    const hiddenInput = document.createElement("input")
    hiddenInput.type = "hidden"
    hiddenInput.name = fieldName
    hiddenInput.value = name

    removeButton.addEventListener("click", () => {
      item.remove()
    })

    item.appendChild(removeButton)
    item.appendChild(hiddenInput)
    list.appendChild(item)

    input.value = ""
    input.focus()
  }

  validateCurrentStep(step) {
    const allergyInputs = step.querySelectorAll(
      'input[name="profile[allergy_ids][]"]'
    )

    const customAllergies = step.querySelectorAll(
      'input[name="profile[custom_allergies][]"]'
    )

    const hasAllergy =
      [...allergyInputs].some((input) => input.checked) ||
      customAllergies.length > 0

    if (allergyInputs.length > 0 && !hasAllergy) {
      const confirmed = window.confirm(
        "Are you sure you don't have allergies?"
      )

      if (!confirmed) {
        return false
      }
    }

    const cookingDevices = step.querySelectorAll(
      'input[name="profile[cooking_device_ids][]"]'
    )

    const customCookingDevices = step.querySelectorAll(
      'input[name="profile[custom_cooking_devices][]"]'
    )

    const hasCookingDevice =
      [...cookingDevices].some((input) => input.checked) ||
      customCookingDevices.length > 0

    if (cookingDevices.length > 0 && !hasCookingDevice) {
      this.cookingDeviceErrorTarget.classList.remove("d-none")
      return false
    }

    this.cookingDeviceErrorTarget.classList.add("d-none")
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
