import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["alert"];

    async copyToClipboard(event) {  
        let text = event.params.value;
        await navigator.clipboard.writeText(text)
        this.alertTarget.classList.remove('d-none');
    }
}
