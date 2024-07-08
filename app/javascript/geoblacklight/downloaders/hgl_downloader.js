import GeoBlacklightDownloader from './downloader.js'

export default class GeoBlacklightHglDownloader extends GeoBlacklightDownloader {
  constructor(el, options) {
    super(el, options);
    this.configureHandler();
  }

  configureHandler() {
    this.el.addEventListener('submit', (ev) => this.download(ev));
  }

  download(ev) {
    ev.preventDefault();
    const modal = this.options.modal; // Assuming this is a DOM element or selector
    if (typeof modal === 'string') {
      document.querySelector(modal).style.display = 'none'; // Example way to hide modal, adjust as necessary
    } else if (modal instanceof HTMLElement) {
      modal.style.display = 'none'; // Directly hide if modal is a DOM element
    }

    const email = this.el.querySelector('#requestEmail').value;
    const url = this.el.querySelector('#requestUrl').value;

    fetch(url, {
      method: 'GET', // GET is default, but explicitly stated here for clarity
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({ email: email })
    })
    .then(response => {
      if (!response.ok) {
        throw new Error('Network response was not ok');
      }
      return response.json();
    })
    .then(data => this.complete(data))
    .catch(error => this.error(error));
  }
}
