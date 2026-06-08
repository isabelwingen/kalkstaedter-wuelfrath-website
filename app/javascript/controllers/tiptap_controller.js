import { Controller } from "@hotwired/stimulus"
import { Editor } from "@tiptap/core"
import StarterKit from "@tiptap/starter-kit"
import Link from "@tiptap/extension-link"
import Table from "@tiptap/extension-table"
import TableRow from "@tiptap/extension-table-row"
import TableHeader from "@tiptap/extension-table-header"
import TableCell from "@tiptap/extension-table-cell"

export default class extends Controller {
  static targets = ["editor", "input"]

  connect() {
    const content = this.inputTarget.value || ""

    this.editor = new Editor({
      element: this.editorTarget,
      extensions: [
        StarterKit,
        Link.configure({ openOnClick: false, autolink: false }),
        Table.configure({ resizable: false }),
        TableRow,
        TableHeader,
        TableCell,
      ],
      content,
      onUpdate: ({ editor }) => {
        this.inputTarget.value = editor.getHTML()
      },
      onTransaction: () => {
        this.syncToolbar()
      },
    })
  }

  disconnect() {
    this.editor?.destroy()
  }

  // ── Formatierung ─────────────────────────────────────────────

  toggleBold() { this.editor.chain().focus().toggleBold().run() }
  toggleItalic() { this.editor.chain().focus().toggleItalic().run() }

  setH1() { this.editor.chain().focus().toggleHeading({ level: 1 }).run() }
  setH2() { this.editor.chain().focus().toggleHeading({ level: 2 }).run() }
  setH3() { this.editor.chain().focus().toggleHeading({ level: 3 }).run() }

  toggleBulletList() { this.editor.chain().focus().toggleBulletList().run() }
  toggleOrderedList() { this.editor.chain().focus().toggleOrderedList().run() }

  // ── Links ─────────────────────────────────────────────────────

  setLink() {
    const previous = this.editor.getAttributes("link").href || ""
    // eslint-disable-next-line no-alert
    const url = window.prompt("URL eingeben:", previous)
    if (url === null) return
    if (url.trim() === "") {
      this.editor.chain().focus().unsetLink().run()
    } else {
      this.editor.chain().focus().setLink({ href: url.trim() }).run()
    }
  }

  unsetLink() { this.editor.chain().focus().unsetLink().run() }

  // ── Tabellen ─────────────────────────────────────────────────

  insertTable() {
    this.editor.chain().focus().insertTable({ rows: 3, cols: 2, withHeaderRow: true }).run()
  }

  addRowAfter() { this.editor.chain().focus().addRowAfter().run() }
  addColumnAfter() { this.editor.chain().focus().addColumnAfter().run() }
  deleteRow() { this.editor.chain().focus().deleteRow().run() }
  deleteColumn() { this.editor.chain().focus().deleteColumn().run() }

  deleteTable() {
    // eslint-disable-next-line no-alert
    if (window.confirm("Tabelle wirklich löschen?")) {
      this.editor.chain().focus().deleteTable().run()
    }
  }

  // ── Toolbar-Zustand ───────────────────────────────────────────

  syncToolbar() {
    const e = this.editor
    const checks = [
      ["tiptap#toggleBold",        e.isActive("bold")],
      ["tiptap#toggleItalic",      e.isActive("italic")],
      ["tiptap#setH1",             e.isActive("heading", { level: 1 })],
      ["tiptap#setH2",             e.isActive("heading", { level: 2 })],
      ["tiptap#setH3",             e.isActive("heading", { level: 3 })],
      ["tiptap#toggleBulletList",  e.isActive("bulletList")],
      ["tiptap#toggleOrderedList", e.isActive("orderedList")],
      ["tiptap#setLink",           e.isActive("link")],
    ]
    checks.forEach(([action, active]) => {
      const btn = this.element.querySelector(`[data-action*="${action}"]`)
      if (btn) btn.classList.toggle("is-active", active)
    })
  }
}
