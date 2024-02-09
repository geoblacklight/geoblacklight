document.addEventListener('DOMContentLoaded', () => {
  document.querySelectorAll('[data-relations="true"]').forEach((element) => {
    const attributes = element.dataset;
    const relationUrl = `${attributes.url}/relations`;

    fetch(relationUrl, { headers: { 'X-Requested-With': 'XMLHttpRequest' }})
      .then(response => {
        if (!response.ok) {
          throw new Error('Network response was not ok');
        }
        return response.text();
      })
      .then(data => {
        const div = document.createElement('div');
        div.innerHTML = data;
        element.appendChild(div);
        div.style.display = 'none';
        fadeIn(div, 200);
      })
      .catch(error => console.error('Error:', error));
  });
});

function fadeIn(element, duration) {
  element.style.opacity = 0;
  element.style.display = 'block';

  let start = null;
  function step(timestamp) {
    if (!start) start = timestamp;
    const progress = timestamp - start;
    element.style.opacity = Math.min(progress / duration, 1);
    if (progress < duration) {
      window.requestAnimationFrame(step);
    }
  }

  window.requestAnimationFrame(step);
}
