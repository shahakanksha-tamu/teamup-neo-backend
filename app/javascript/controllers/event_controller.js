import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="event"
export default class extends Controller {
  static values = { eventId: String }
  static targets = ["card"]

  connect() {
    const eventKey = `event_${this.eventIdValue}`; // Unique key for each event
    // Check if the event is in sessionStorage
    if (!sessionStorage.getItem(eventKey)) {
      // Event not in sessionStorage, store it and show the card
      this.showCard();
    } else {
      // Event is in sessionStorage, hide the card
      this.hideCard();
    }
  }

  showCard() {
    // this.cardTarget.classList.remove("event-notification-card-hidden"); // Show the card
    this.cardTarget.style.display = "block"; // Ensure the card is displayed
  }
  closeCard(event) {
    const eventKey = `event_${this.eventIdValue}`; // Unique key for each event

    console.log("closeCard");
    sessionStorage.setItem(eventKey, "true");
    this.hideCard()
  }
  hideCard() {
    this.cardTarget.style.display = "none"; // Hide the card
    // this.cardTarget.classList.add("event-notification-card-hidden"); // Hide the card
  }
}
