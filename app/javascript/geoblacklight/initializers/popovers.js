// Initialize popovers
export default function initializePopovers() {
  const popoverElements = document.querySelectorAll('[data-bs-toggle="popover"]'); // Bootstrap 5 uses 'data-bs-toggle'
  popoverElements.forEach((element) => {
    const popover = new bootstrap.Popover(element, {
      trigger: "hover",
    });
  });
}
