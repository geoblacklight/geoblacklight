// Limit how many values a metadata field shows on the show page

// Class that hides a field's values past its limit and adds a button to reveal them.
// The hidden values are only hidden visually, so assistive technology is given the whole
// list up front. That leaves the button useful to sighted users alone, so it is marked
// aria-disabled and its label says why.
class FieldTruncator {
  constructor(element) {
    this.slot = element.querySelector(":scope > dd.read-more-slot")
    if (!this.slot) return

    // this field was already truncated on an earlier turbo:load/turbo:frame-load
    if (this.slot.firstElementChild) return

    // if the field is already short enough, don't truncate it
    const values = element.querySelectorAll(":scope > dd:not(.read-more-slot)")
    const limit = parseInt(element.dataset.limit, 10) || 5
    if (values.length <= limit) return

    // the value at the limit is left in place but clipped, so that the list visibly runs
    // on past the values it is showing; everything after it is hidden outright
    this.preview = values[limit]
    this.hidden = Array.from(values).slice(limit + 1)
    this.readMoreText = element.dataset.readMoreText
    this.closeText = element.dataset.closeText

    // add the button
    this.button = document.createElement("button")
    this.button.classList.add("btn", "btn-link", "p-0", "border-0", "read-more")
    this.button.setAttribute("aria-disabled", "true")
    this.button.setAttribute("aria-label", element.dataset.buttonLabel)
    this.button.addEventListener("click", this.toggle.bind(this))

    // start collapsed
    this.collapse()
    this.slot.append(this.button)
  }

  toggle() {
    if (this.expanded) this.collapse()
    else this.expand()
  }

  collapse() {
    this.preview.classList.add("truncate-preview")
    this.hidden.forEach((value) => value.classList.add("visually-hidden"))
    this.button.textContent = this.readMoreText
    this.expanded = false
  }

  expand() {
    this.preview.classList.remove("truncate-preview")
    this.hidden.forEach((value) => value.classList.remove("visually-hidden"))
    this.button.textContent = this.closeText
    this.expanded = true
  }
}

// Initialize truncation for every metadata field that limits its values
export default function initializeFieldTruncation() {
  document.querySelectorAll(".truncate-field").forEach((element) => new FieldTruncator(element))
}
