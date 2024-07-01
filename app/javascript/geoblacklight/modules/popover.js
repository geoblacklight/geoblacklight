document.addEventListener("DOMContentLoaded", () => {
  const popoverElements = document.querySelectorAll('[data-toggle="popover"]'); // Bootstrap 5 uses 'data-bs-toggle'
  popoverElements.forEach((element) => {
    const popover = new bootstrap.Popover(element, {
      trigger: "hover",
    });
  });
});
