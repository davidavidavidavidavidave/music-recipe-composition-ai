import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="textmove"
export default class extends Controller {
  connect() {
    this.animate();
  }

  animate() {
    this.element.classList.add("move-left-to-right");
  }
}
