;; ----------------------------------------------------------
;; Emacs Configuration File
;; A minimalist setup with essential packages and Evil mode.
;; ----------------------------------------------------------

;; ===========================
;; General Settings
;; ===========================

;; Quick access to init.el
(defun init ()
  "Edit the `user-init-file' in another window."
  (interactive)
  (find-file user-init-file))

;; Disable unnecessary UI elements for a cleaner interface
(menu-bar-mode -1)                ; Disable the menu bar
(tool-bar-mode -1)                ; Disable the tool bar
(scroll-bar-mode -1)              ; Disable the scroll bar
(setq inhibit-startup-message t)  ; Disable Emacs welcome screen
(setq ring-bell-function 'ignore) ; Turn off all alarms

;; Set fringe background to match buffer background
(custom-set-faces
 '(fringe ((t (:background nil))))) 

;; Add padding around the window border
(set-fringe-mode 10)

;; Set typeface and size
(set-face-attribute 'default nil :font "Iosevka Term" :height 180)

;; Start Emacs in full-screen mode
(add-hook 'window-setup-hook 'toggle-frame-fullscreen)

;; Remove title bar icon and file name
(setq ns-use-proxy-icon nil)
(setq frame-title-format nil)

;; Answer 'y' or 'n' for prompts instead of 'yes' or 'no'
(defalias 'yes-or-no-p 'y-or-n-p)

;; Don't ask for confirmation when opening symlinked files
(setq vc-follow-symlinks t)


;; ===========================
;; Custom Functions
;; ===========================

;; Navigate up a directory or open dired
(defun my/navigate-up-directory ()
  "In `dired-mode`, navigate up a directory. Otherwise, open `dired` in the current directory."
  (interactive)
  (if (derived-mode-p 'dired-mode)
      (dired-up-directory)
    (dired default-directory)))

;; Open current file's directory in Finder (macOS)
(defun my/osx-open-in-finder ()
  "Open current file's directory in Finder."
  (interactive)
  (shell-command "open ."))

;; Open Dired in the current buffer's directory without prompting
(defun my/open-dired-current-directory ()
  "Open Dired in the current buffer's directory without prompting."
  (interactive)
  (dired default-directory))

;; Toggle fullscreen window
(defun my/toggle-window-fullscreen ()
  "Toggle the selected frame between fullscreen and windowed mode."
  (interactive)
  (if (frame-parameter nil 'fullscreen)
      (toggle-frame-fullscreen)
    (toggle-frame-maximized)))

;; Toggle buffer fullscreen with revert capability
(defun my/toggle-buffer-fullscreen ()
  "Toggle the selected buffer between fullscreen and windowed mode."
  (interactive)
  (if (= 1 (length (window-list)))
      (jump-to-register '_)
    (progn
      (window-configuration-to-register '_)
      (delete-other-windows))))

;; Disable evil-escape in Magit buffers
(defun my/disable-evil-escape-in-magit ()
  "Disable evil-escape in all Magit buffers."
  (when (derived-mode-p 'magit-mode)
    (evil-escape-mode -1)))


;; ===========================
;; Package Management
;; ===========================

(require 'package)

;; Add MELPA and GNU package archives
(setq package-archives
      '(("melpa" . "https://melpa.org/packages/")
        ("gnu"   . "https://elpa.gnu.org/packages/")))

;; Initialize the package system
(package-initialize)

;; Refresh package contents if necessary
(unless package-archive-contents
  (package-refresh-contents))

;; Install use-package if not already installed
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

;; Require use-package for managing packages
(require 'use-package)

;; Always ensure packages are installed
(setq use-package-always-ensure t)


;; ===========================
;; Core Packages
;; ===========================

;; Sync shell & Emacs paths 
(use-package exec-path-from-shell
  :init
  (exec-path-from-shell-initialize))

;; Undo-Fu Support
(use-package undo-fu
  :init
  ;; No additional configuration needed
  )


;; ===========================
;; Theming
;; ===========================

;; Install and load Doom themes
;; https://github.com/doomemacs/themes
(use-package doom-themes
  :config
  ;; Challenger Deep
  (load-theme 'doom-challenger-deep t)
  (setq doom-theme 'doom-challenger-deep))
;; Iosvkem
;; (load-theme 'doom-Iosvkem t)
;; (setq doom-theme 'doom-Iosvkem))
;; Laserwave
;; (load-theme 'doom-laserwave t)
;; (setq doom-theme 'doom-laserwave))
;; Outrun Electric
;; (load-theme 'doom-outrun-electric t)
;; (setq doom-theme 'doom-outrun-electric))
;; Vibrant
;; (load-theme 'doom-vibrant t)
;; (setq doom-theme 'doom-vibrant))


;; ===========================
;; Evil Mode Setup
;; ===========================

(use-package evil
  :init
  (setq evil-want-keybinding nil)          ; Disable default keybindings for better integration
  (setq evil-undo-system 'undo-fu)         ; Set undo-fu as the undo system for Evil
  :config
  (evil-mode 1))                            ; Enable Evil mode globally

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))                   ; Initialize Evil Collection for enhanced package integrations

(use-package evil-escape
  :after evil
  :custom
  (evil-escape-key-sequence "jk")          ; Define "jk" as the escape sequence
  (evil-escape-delay 0.2)                   ; Set the maximum time between key presses
  :config
  (add-hook 'magit-mode-hook #'my/disable-evil-escape-in-magit)
  (evil-escape-mode 1))                     ; Enable Evil Escape globally

(use-package evil-surround
  :config
  (global-evil-surround-mode 1))            ; Enable global Evil Surround mode

(use-package evil-org
  :after org
  :hook (org-mode . evil-org-mode)
  :config
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))


;; ---------------------------
;; Keybindings
;; ---------------------------

(with-eval-after-load 'evil
  ;; Define keybindings for Normal State
  (evil-define-key 'normal 'global
    ;; Toggle window fullscreen 
    (kbd "F") 'my/toggle-window-fullscreen

    ;; Toggle buffer fullscreen 
    (kbd "C-w w") 'my/toggle-buffer-fullscreen

    ;; Open utilities
    (kbd "SPC d") 'my/open-dired-current-directory
    (kbd "SPC m") 'magit
    (kbd "SPC b") 'bookmark-bmenu-list

    ;; Custom navigation and OS integration
    (kbd "C-u") 'my/navigate-up-directory
    (kbd "C-<return>") 'my/osx-open-in-finder

    ;; Comment/uncomment lines
    (kbd "C-;") 'comment-line)

  ;; Define keybindings for Visual State
  (evil-define-key 'visual 'global
    ;; Comment/uncomment region
    (kbd "C-;") 'comment-or-uncomment-region)

  ;; Define keybindings for Motion State
  (evil-define-key 'motion 'global
    ;; Jump to end and beginning of line
    "L" 'evil-end-of-line
    "H" 'evil-beginning-of-line

    ;; Navigate between buffers
    (kbd "C-h") 'previous-buffer
    (kbd "C-l") 'next-buffer

    ;; Navigate wrapped lines
    "j" 'evil-next-visual-line
    "k" 'evil-previous-visual-line))


;; ===========================
;; Language Server Protocol (LSP) & Autocompletion
;; ===========================

;; Eglot for LSP support
(use-package eglot
  :hook ((typescript-mode . eglot-ensure)
         (typescript-tsx-mode . eglot-ensure))
  :custom
  (eglot-extend-to-xref t)
  :config
  ;; Specify the TypeScript language server for TypeScript and TSX modes
  (add-to-list 'eglot-server-programs
               '((typescript-mode typescript-tsx-mode)
                 . ("typescript-language-server" "--stdio"))))

;; Enhanced Completion with IDO and Company
(use-package ido
  :init
  (ido-mode t)
  (ido-everywhere t)
  :custom
  (ido-enable-flex-matching t)
  (ido-use-faces nil))                          ; Disable ido faces to integrate with theme

(use-package company
  :diminish company-mode
  :hook (after-init . global-company-mode)
  :custom
  (tab-always-indent 'complete)
  (company-minimum-prefix-length 2)
  (company-idle-delay 0)
  :bind (:map company-active-map
              ("<tab>" . company-complete-selection)))


;; ===========================
;; Syntax Highlighting
;; ===========================

(use-package tree-sitter
  :ensure nil                                      ; Built-in in Emacs 29 and above
  :hook (tree-sitter-after-on . tree-sitter-hl-mode))

(use-package tree-sitter-langs
  :after tree-sitter
  :config
  (tree-sitter-require 'typescript)
  (tree-sitter-require 'tsx))

(use-package typescript-mode
  :after tree-sitter
  :mode ("\\.ts\\'" . typescript-mode)
  :mode ("\\.tsx\\'" . typescript-tsx-mode)
  :config
  ;; Derive typescript-tsx-mode from typescript-mode
  (define-derived-mode typescript-tsx-mode typescript-mode
    "TypeScript TSX"
    "A TypeScript mode for TSX files.")

  ;; Associate .ts and .tsx files with appropriate modes
  (add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-mode))
  (add-to-list 'auto-mode-alist '("\\.tsx\\'" . typescript-tsx-mode))

  ;; Map typescript-tsx-mode to the Tree-sitter TSX parser
  (add-to-list 'tree-sitter-major-mode-language-alist '(typescript-tsx-mode . tsx)))

;; Enable Tree-sitter globally
(global-tree-sitter-mode)


;; ===========================
;; Code Formatting
;; ===========================

;; Apheleia for code formatting
(use-package apheleia
  :diminish apheleia-mode
  :config
  (setq apheleia-debug t)                             ; Enable debugging for Apheleia
  (setq apheleia-formatters-respect-indent-level nil) ; Do not pass Emacs indent settings to formatters
  (apheleia-global-mode +1))                          ; Enable Apheleia globally


;; ===========================
;; Version Control
;; ===========================

;; Magit: A text-based GIT interface
(use-package magit
  :commands magit-status)                        ; Load magit when `magit-status` is called

(use-package blamer
  :defer 20
  :custom-face
  (blamer-face ((t :height 140
                   :italic t
                   :foreground "#334466")))
  :config
  (global-blamer-mode 1)
  :bind ("C-c b" . global-blamer-mode))


;; ===========================
;; Markdown Mode
;; ===========================

(use-package markdown-mode
  :mode (("\\.markdown\\'" . markdown-mode)
         ("\\.md\\'" . markdown-mode))
  :config
  (add-hook 'markdown-mode-hook #'visual-line-mode) ; Enable visual line wrapping
  (add-hook 'markdown-mode-hook #'flyspell-mode))  ; Enable spell checking

;; Simple distraction free markdown mode
(use-package darkroom
  :hook (markdown-mode . darkroom-mode))


;; ===========================
;; Delimiter Pairing
;; ===========================

;; Enable automatic delimiter pairing
(electric-pair-mode 1)


;; ===========================
;; Backup and Autosave
;; ===========================

;; Configure Backup Files
(setq backup-directory-alist `(("." . "~/.emacs.d/backups"))
      backup-by-copying t          ; Copy files instead of renaming
      delete-old-versions t        ; Delete excess backup versions silently
      kept-new-versions 6          ; Keep 6 newest versions
      kept-old-versions 2          ; Keep 2 oldest versions
      version-control t)           ; Use version numbers for backups

;; Configure Autosave Files
(setq auto-save-file-name-transforms
      `((".*" "~/.emacs.d/autosaves/" t))
      auto-save-interval 200        ; Autosave every 200 keystrokes
      auto-save-timeout 20)         ; Autosave after 20 seconds of idle time

;; Ensure backup and autosave directories exist
(make-directory "~/.emacs.d/backups/" t)
(make-directory "~/.emacs.d/autosaves/" t)


;; ===========================
;; Custom File Setup
;; ===========================

;; Specify the custom file to separate Emacs' custom-set variables and faces
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))

;; Load the custom file if it exists, without errors
(when (file-exists-p custom-file)
  (load custom-file 'noerror 'nomessage))


;; ---------------------------
;; End of Configuration
;; ---------------------------
