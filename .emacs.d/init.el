(require 'package)

(setq package-archives
      '(("melpa" . "https://melpa.org/packages/")
        ("gnu"   . "https://elpa.gnu.org/packages/")))

(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(use-package catppuccin-theme
  :config
  (setq catppuccin-flavor 'mocha)
  (load-theme 'catppuccin t))

;; Menü çubuğu, araç çubuğu, kaydırma çubuğu ve tooltip kapatma
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(tooltip-mode -1)

;; Otomatik parantez kapatma
(electric-pair-mode 1)

;; Satır gösterme
(column-number-mode 1)
(size-indication-mode 1)

;; Tab bar aktif et
(tab-bar-mode 0)
(setq tab-bar-new-tab-choice nil) ;; Yeni tab açılırken açılacak buffer

;; Tab isimlerini okunabilir yap
(setq tab-bar-tab-name-format-function
      (lambda (tab i) (format " %s " (alist-get 'name tab))))

;; Tab bar görünümü güzelleştir
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(tab-bar-tab ((t (:inherit tab-bar :background "#44475a" :foreground "#f8f8f2" :weight bold))))
 '(tab-bar-tab-inactive ((t (:inherit tab-bar :background "#282a36" :foreground "#6272a4")))))

;; Yeni tab aç ve hemen dosya açma diyalogunu başlatan fonksiyon
(defun my/tab-new-and-find-file ()
  "Yeni tab açar ve hemen dosya açma penceresi açar."
  (interactive)
  (tab-bar-new-tab)
  (call-interactively #'find-file))

;; evil-mode kurulumu ve aktif etme
(use-package evil
  :init
  (setq evil-want-keybinding nil)
  :config
  (evil-mode 1))

;; which-key kurulumu ve aktif etme
(use-package which-key
  :config
  (which-key-mode))

;; general.el ile SPC tuşu için keybinding tanımlama
(use-package general
  :after evil
  :config
  (general-create-definer my/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")

  (my/leader-keys
   "."  '(find-file :which-key "find file")
   "f"  '(:ignore t :which-key "files")
   "sb" '(switch-to-buffer :which-key "switch buffer")

   "p"  '(:ignore t :which-key "projects")
   "pp" '(projectile-switch-project :which-key "switch project")

   "b"  '(:ignore t :which-key "bookmarks")
   "bs" '(bookmark-set :which-key "set bookmark")
   "bj" '(bookmark-jump :which-key "jump to bookmark")
   "bl" '(bookmark-bmenu-list :which-key "list bookmarks")

   "t"  '(:ignore t :which-key "tabs")
   ;; Burada yeni tab açarken dosya sorma fonksiyonu
   "tn" '(my/tab-new-and-find-file :which-key "new tab and find file")
   "to" '(tab-close-other :which-key "close other tabs")
   "tc" '(tab-close :which-key "close tab")
   "tm" '(tab-move :which-key "move tab")
   "tb" '(tab-bar-mode :which-key "enable/disable tab bar") 
   "1"  (lambda () (interactive) (tab-bar-select-tab 1))
   "2"  (lambda () (interactive) (tab-bar-select-tab 2))
   "3"  (lambda () (interactive) (tab-bar-select-tab 3))))

;; Asenkron native compile hatalarını sessize al
(setq native-comp-async-report-warnings-errors 'silent)

;; Vertico, Consult, Marginalia kurulumu
(use-package vertico
  :init
  (vertico-mode))

(use-package consult)

(use-package marginalia
  :init
  (marginalia-mode))

;; Orderless ile tamamlama stili ayarı
(use-package orderless
  :init
  (setq completion-styles '(orderless)))

;; Doom modeline kurulumu ve ayarları
(use-package doom-modeline
  :ensure t
  :init
  (doom-modeline-mode 1)
  :custom
  (doom-modeline-icon t) ; İkonları açar
  (doom-modeline-buffer-file-name-style 'relative-from-project)
  (doom-modeline-major-mode-icon t)
  (doom-modeline-minor-modes nil) ; küçük modları gizle
  (doom-modeline-enable-word-count t))

;; Flycheck
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

;; Popper (popup yönetimi)
(use-package popper
  :init
  (popper-mode +1)
  (popper-echo-mode +1))

;; Eyebrowse (workspace management)
(use-package eyebrowse
  :init
  (eyebrowse-mode t))

;; All the icons
(unless (package-installed-p 'all-the-icons)
  (package-install 'all-the-icons))

;; Font ayarı
(set-face-attribute 'default nil :family "Ubuntu Mono Nerd Font" :height 200)

;; Satır numaralarını relative yap
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode 1)

;; Org dosya dizini
(setq org-directory "~/org/")

(setq hscroll-margin 2
      hscroll-step 1
      scroll-conservatively 10
      scroll-margin 0
      scroll-preserve-screen-position t
      auto-window-vscroll nil
      mouse-wheel-scroll-amount '(2 ((shift) . hscroll))
      mouse-wheel-scroll-amount-horizontal 2)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(all-the-icons catppuccin-theme consult doom-modeline evil eyebrowse
		   flycheck general good-scroll marginalia orderless
		   popper scrollkeeper smooth-scroll sublimity vertico)))
