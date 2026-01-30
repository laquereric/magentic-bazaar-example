import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "dropzone", "placeholder", "preview", "fileList"]

  dragover(event) {
    event.preventDefault()
    this.dropzoneTarget.classList.add("border-indigo-400", "bg-indigo-50")
  }

  dragleave(event) {
    event.preventDefault()
    this.dropzoneTarget.classList.remove("border-indigo-400", "bg-indigo-50")
  }

  drop(event) {
    event.preventDefault()
    this.dropzoneTarget.classList.remove("border-indigo-400", "bg-indigo-50")
    this.inputTarget.files = event.dataTransfer.files
    this.showPreview(event.dataTransfer.files)
  }

  select() {
    this.showPreview(this.inputTarget.files)
  }

  showPreview(files) {
    if (files.length === 0) return

    this.placeholderTarget.classList.add("hidden")
    this.previewTarget.classList.remove("hidden")
    this.fileListTarget.innerHTML = ""

    Array.from(files).forEach(file => {
      const item = document.createElement("div")
      item.className = "flex items-center justify-between p-3 bg-gray-50 rounded-md"
      item.innerHTML = `
        <div class="flex items-center gap-3">
          <svg class="h-5 w-5 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
          </svg>
          <span class="text-sm text-gray-700">${file.name}</span>
        </div>
        <span class="text-xs text-gray-500">${this.formatSize(file.size)}</span>
      `
      this.fileListTarget.appendChild(item)
    })
  }

  formatSize(bytes) {
    if (bytes === 0) return "0 B"
    const units = ["B", "KB", "MB", "GB"]
    const i = Math.floor(Math.log(bytes) / Math.log(1024))
    return (bytes / Math.pow(1024, i)).toFixed(1) + " " + units[i]
  }
}
