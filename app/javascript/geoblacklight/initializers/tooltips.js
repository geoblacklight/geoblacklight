import * as bootstrap from "bootstrap";

export default function initializeTooltips() {
  document.body.addEventListener(
    "mouseenter",
    (event) => {
      if (event.target.closest(".blacklight-icons.svg_tooltip svg")) {
        const svgElement = event.target.closest(
          ".blacklight-icons.svg_tooltip svg"
        );
        const svgTitleElement = svgElement.querySelector("title");
        const titleText = svgTitleElement ? svgTitleElement.textContent : "";

        if (titleText !== undefined && titleText !== "") {
          // Initialize Bootstrap tooltip with native JavaScript
          const tooltip = new bootstrap.Tooltip(svgElement, {
            placement: "bottom",
            title: titleText,
          });
          tooltip.show();

          // Store the original title in the data-original-title attribute
          // and remove the title element to prevent it from interfering with Bootstrap's tooltip.
          svgElement.setAttribute("data-original-title", titleText);
          svgTitleElement.remove();
        }
      }
    },
    true
  ); // Use capture to ensure the event is caught as it bubbles up

  document.body.addEventListener(
    "mouseleave",
    (event) => {
      if (event.target.closest(".blacklight-icons.svg_tooltip svg")) {
        const svgElement = event.target.closest(
          ".blacklight-icons.svg_tooltip svg"
        );
        const originalTitle = svgElement.getAttribute("data-original-title");

        if (originalTitle !== undefined && originalTitle !== "") {
          // Restore the SVG title element from data-original-title
          const newTitleElement = document.createElement("title");
          newTitleElement.textContent = originalTitle;
          svgElement.prepend(newTitleElement);
          svgElement.setAttribute("data-original-title", "");
        }
      }

      // Remove tooltips
      document.querySelectorAll(".tooltip").forEach((elem) => elem.remove());
    },
    true
  ); // Use capture to ensure the event is caught as it bubbles up
}
