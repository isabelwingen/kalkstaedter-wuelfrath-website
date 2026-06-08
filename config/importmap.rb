# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"

# Tiptap Rich Text Editor (esm.sh CDN, ?bundle = self-contained, no extra deps needed)
pin "@tiptap/core", to: "https://esm.sh/@tiptap/core@2?bundle"
pin "@tiptap/starter-kit", to: "https://esm.sh/@tiptap/starter-kit@2?bundle"
pin "@tiptap/extension-link", to: "https://esm.sh/@tiptap/extension-link@2?bundle"
pin "@tiptap/extension-table", to: "https://esm.sh/@tiptap/extension-table@2?bundle"
pin "@tiptap/extension-table-row", to: "https://esm.sh/@tiptap/extension-table-row@2?bundle"
pin "@tiptap/extension-table-header", to: "https://esm.sh/@tiptap/extension-table-header@2?bundle"
pin "@tiptap/extension-table-cell", to: "https://esm.sh/@tiptap/extension-table-cell@2?bundle"
