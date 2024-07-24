import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
  }

  download(ev) {
    ev.preventDefault();
    if (this.downloading) {
      return;
    }
    this.downloading = true;
    ev.target.classList.add('download-in-progress');
    const url = ev.target.dataset.downloadPath;
    ev.target.removeAttribute('href');
    ev.target.innerHTML = '<div class="spinner-border spinner-border-sm float-right"></div> Preparing download...';

    fetch(url)
      .then((response) => {
        if (!response.ok) {
          return response.json().then((errorData) => {
            const exception = new Error("Network response was not ok");
            exception.data = errorData; // Attach the parsed JSON data to the error object
            throw exception;
          });
        }
        return response.json();
      })
      .then((data) => this.complete(data, ev.target))
      .catch((error) => this.error(error, ev.target));
  }

  complete(data, target) {
    this.downloading = false;
    target.classList.remove('download-in-progress');
    target.classList.add('download-complete');
    target.innerHTML = `Download ready (${target.dataset.downloadType})`;
    target.href = data[1];
    this.renderMessage(data[0]);
    target.click();
  }

  error(exception, target) {
    this.downloading = false;
    target.classList.remove('download-in-progress');
    target.classList.add('download-complete');
    target.innerHTML = `Download failed (${target.dataset.downloadType})`;
    this.renderMessage(exception.data[0]);
  }

  renderMessage(message) {
    Object.entries(message).forEach(([idx, msg]) => {
      const flash = document.createElement("div");
      flash.className = `alert alert-${msg[0]}`;
      flash.innerHTML = `<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>${msg[1]}`;
      document.querySelector("div.flash_messages").appendChild(flash);
    });
  }
}
