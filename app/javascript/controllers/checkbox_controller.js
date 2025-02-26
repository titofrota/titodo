import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    url: String,  // The URL of the item to be updated
  }

  async toggle(e) {
    let checkbox = e.target
    let checked = checkbox.checked

    // Logs the checkbox state
    console.log("Checkbox state:", checked)

    // Sends the PATCH request to update the 'completed' status of the todo_item
    try {
      const response = await fetch(this.urlValue, {
        method: "PATCH",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content,
        },
        body: JSON.stringify({ todo_item: { completed: checked } })
      });

      if (response.ok) {
        // Handle Turbo Stream response
        const text = await response.text();
        // The response is expected to contain Turbo Stream HTML
        document.body.insertAdjacentHTML('beforeend', text);
      } else {
        console.error("Error updating the item");
      }
    } catch (error) {
      console.error("Error sending the request:", error);
    }
  }
}
