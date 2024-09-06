// Truncate and expand/collapse abstracts (descriptions) on show page

// Class that handles adding a button to expand/collapse a description
// Uses bootstrap's built-in collapse functionality; CSS is used to do the truncation
class Truncator {
  constructor(element, { lines, id }) {
    // if the element is already small enough, don't truncate it
    const minHeight = lines * parseFloat(window.getComputedStyle(element).fontSize);
    if (element.getBoundingClientRect().height < minHeight) return;

    // set a unique ID for the element if it doesn't have one
    this.element = element;
    this.element.id ||= id;

    // add the button
    this.button = document.createElement("button");
    this.button.classList.add("btn", "btn-link", "p-0", "border-0");
    this.button.dataset.bsToggle = "collapse";
    this.button.dataset.bsTarget = `#${this.element.id}`;
    this.button.setAttribute("aria-expanded", "false");
    this.button.setAttribute("aria-controls", this.element.id);
    this.button.textContent = "Read more";
    this.button.addEventListener("click", this.toggle.bind(this));
    element.parentNode.insertBefore(this.button, element.nextSibling);

    // start collapsed
    this.element.classList.add("collapse");
  }

  toggle() {
    if (this.button.textContent == "Read more") this.button.textContent = "Close";
    else this.button.textContent = "Read more";
  }
}

// Initialize truncation for all elements with class "truncate-abstract"
// Ensure they have unique IDs because bootstrap requires this
export default function initializeTruncation() {
  document.querySelectorAll(".truncate-abstract").forEach((element, i) => {
    new Truncator(element, {
      lines: 12,
      id: `truncate-${i}`,
    });
  });
}
