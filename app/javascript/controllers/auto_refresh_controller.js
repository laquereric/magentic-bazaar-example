import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    url: String,
    interval: { type: Number, default: 5000 },
    active: { type: Boolean, default: true }
  }

  connect() {
    if (this.activeValue) {
      this.startPolling()
    }
  }

  disconnect() {
    this.stopPolling()
  }

  startPolling() {
    this.timer = setInterval(() => {
      fetch(this.urlValue, {
        headers: {
          "Accept": "text/vnd.turbo-stream.html",
          "X-Requested-With": "XMLHttpRequest"
        }
      }).then(response => {
        if (response.ok) {
          return response.text()
        }
      }).then(html => {
        if (html) {
          Turbo.visit(this.urlValue, { action: "replace" })
        }
      })
    }, this.intervalValue)
  }

  stopPolling() {
    if (this.timer) {
      clearInterval(this.timer)
    }
  }
}
