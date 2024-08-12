export default class GeoBlackLightDownloader {
    constructor(el, options) {
        this.el = document.querySelector(el);
        this.options = options;
        this.spinner = document.createElement('i');
        this.spinner.className = 'fa fa-spinner fa-spin fa-2x fa-align-center';
        this.spinner.style.display = 'none'; // Initially hidden
        document.body.appendChild(this.spinner); // Append spinner to body

        this.configureHandler();
    }

    configureHandler() {
        this.el.addEventListener('click', (ev) => this.download(ev));
    }

    download(ev) {
        ev.preventDefault();
        const url = this.el.getAttribute('data-download-path');
        this.showSpinner();

        fetch(url)
            .then(response => {
                if (!response.ok) {
                    throw new Error('Network response was not ok');
                }
                return response.json();
            })
            .then(data => this.complete(data))
            .catch(error => this.error(error));
    }

    showSpinner() {
        this.spinner.style.display = ''; // Show spinner
        this.el.disabled = true; // Disable button during download
    }

    hideSpinner() {
        this.spinner.style.display = 'none'; // Hide spinner
        this.el.disabled = false; // Re-enable button
    }

    complete(data) {
        this.renderMessage(data);
        this.hideSpinner();
    }

    error(error) {
        console.error("Download error:", error);
        this.hideSpinner();
        this.renderMessage({ type: 'danger', text: 'Download failed' });
    }

    renderMessage(message) {
        const flash = document.createElement('div');
        flash.className = `alert alert-${message.type}`;
        flash.innerHTML = `<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>${message.text}`;
        document.querySelector('div.flash_messages').appendChild(flash);
    }
}
