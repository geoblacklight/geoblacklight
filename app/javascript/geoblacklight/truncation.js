// Truncate and expand/collapse abstracts (descriptions) on show page
export default function initializeTruncation() {
  document.querySelectorAll(".truncate-abstract").forEach((element, i) => {
    let lines = 12 * parseFloat(window.getComputedStyle(element).fontSize);
    if (element.getBoundingClientRect().height < lines) return;
    let id = element.id || "truncate-" + i;

    element.id = id;
    element.classList.add("collapse");

    let control = document.createElement("button");
    control.className = "btn btn-link p-0 border-0";
    control.setAttribute("data-toggle", "collapse");
    control.setAttribute("aria-expanded", "false");
    control.setAttribute("data-target", `#${id}`);
    control.setAttribute("aria-controls", id);
    control.textContent = "Read more";

    control.addEventListener("click", function () {
      let isExpanded = control.getAttribute("aria-expanded") === "true";
      control.textContent = isExpanded ? "Read more" : "Close";
      control.setAttribute("aria-expanded", !isExpanded);
    });

    element.parentNode.insertBefore(control, element.nextSibling);
  });
}
