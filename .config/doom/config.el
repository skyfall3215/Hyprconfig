;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-
(setq doom-font (font-spec :family "Ubuntu Mono Nerd Font" :size 25))

(setq catppuccin-flavor 'mocha)

(load-theme 'catppuccin t)
(setq display-line-numbers-type 'relative)

(setq org-directory "~/org/")

(setq select-enable-primary nil)
(setq select-enable-clipboard nil)
(setq x-select-enable-primary nil)
(setq x-select-enable-clipboard nil)
(setq interprogram-cut-function nil)
(setq interprogram-paste-function nil)


(setq evil-want-clipboard nil)


(defun copy-region-to-clipboard (start end)
  "Seçili bölgeyi wl-copy ile sistem clipboard'a gönder."
  (interactive "r")
  (shell-command-on-region start end "wl-copy"))


(defun paste-from-clipboard ()
  "wl-paste ile sistem clipboard'dan içeriği al ve ekle."
  (interactive)
  (let ((text (shell-command-to-string "wl-paste -n")))
    (insert text)))


(map! :leader
      :desc "Copy region to system clipboard"
      "c" #'copy-region-to-clipboard
      :desc "Paste from system clipboard"
      "v" #'paste-from-clipboard)

(defun evil-yank-to-clipboard ()
  "Seçili bölgeyi wl-copy ile sistem clipboard'a gönderir."
  (interactive)
  (when (use-region-p)
    (let ((text (buffer-substring-no-properties (region-beginning) (region-end))))
      (call-process-region (region-beginning) (region-end) "wl-copy")
      ;; Ayrıca kill-ring'e eklemek istersen:
      (kill-new text))))


(defun evil-paste-from-clipboard ()
  "wl-paste çıktısını imlecin olduğu yere yapıştırır."
  (interactive)
  (let ((text (string-trim (shell-command-to-string "wl-paste -n"))))
    (insert text)))



(map! :n "y" #'evil-yank-to-clipboard)
(map! :n "p" #'evil-paste-from-clipboard)
(map! :v "y" #'evil-yank-to-clipboard)
