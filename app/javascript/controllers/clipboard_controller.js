import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["citation", "alert"];

    async copyToClipboard() {
        let text = this.citationTarget.textContent.trim();
        await navigator.clipboard.writeText(text)
        this.alertTarget.classList.remove('d-none');
    }
}
