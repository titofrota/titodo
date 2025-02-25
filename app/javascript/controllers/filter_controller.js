import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["button"];

  connect() {
    this.updateActiveButton();
  }

  update(event) {
    event.preventDefault();

    const url = event.currentTarget.getAttribute("href");
    this.loadTurboFrame(url);

    this.setActiveButton(event.currentTarget);
  }

  loadTurboFrame(url) {
    fetch(url, { headers: { "Turbo-Frame": "todo_items" } })
      .then(response => response.text())
      .then(html => {
        document.getElementById("todo_items").innerHTML = html;
      });
  }

  updateActiveButton() {
    // Verifica se algum botão já está ativo (para quando for navegado via Turbo)
    const activeButton = this.buttonTargets.find(btn =>
      btn.classList.contains("bg-gray-300", "font-semibold")
    );

    if (!activeButton) {
      // Se nenhum estiver ativo, seleciona "All" por padrão
      const defaultButton = this.buttonTargets.find(btn =>
        btn.getAttribute("href").split("filter=")[1] === undefined
      );
      if (defaultButton) {
        this.setActiveButton(defaultButton);
      }
    }
  }

  setActiveButton(button) {
    this.buttonTargets.forEach(btn => btn.classList.remove("bg-gray-300", "font-semibold"));
    button.classList.add("bg-gray-300", "font-semibold");
  }
}
