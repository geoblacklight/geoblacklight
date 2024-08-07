import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["alert"];

    async copyToClipboard(event) {  
        let text = event.target.dataset.clipboardValue;
        await navigator.clipboard.writeText(text)
        this.alertTarget.classList.remove('d-none');
    }
}
