;; ----------------------------------------------------------
;; Emacs Configuration File
;; A minimalist setup with essential packages and Evil mode.
;; ----------------------------------------------------------

;; ---------------------------
;; General Settings 
;; ---------------------------

;; Disable unnecessary UI elements for a cleaner interface
(menu-bar-mode -1)                ; Disable the menu bar
(tool-bar-mode -1)                ; Disable the tool bar
(scroll-bar-mode -1)              ; Disable the scroll bar
(setq inhibit-startup-message t)  ; Disable Emacs welcome screen
(setq ring-bell-function 'ignore) ; Turn off all alarms

;; Set fringe background to match buffer background
(custom-set-faces
 '(fringe ((t (:background "nil")))))

;; Add padding around the window border
(set-fringe-mode 10)

;; Set typeface and size
(set-face-attribute 'default nil :font "Iosevka Term" :height 180)

;; Start Emacs in full-screen mode
(add-hook 'window-setup-hook 'toggle-frame-fullscreen)

;; Answer 'y' or 'n' for prompts instead of 'yes' or 'no'
(defalias 'yes-or-no-p 'y-or-n-p)

;; ---------------------------
;; Backup and Autosave
;; ---------------------------

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

;; ---------------------------
;; Package Management Setup
;; ---------------------------

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

;; ---------------------------
;; Sync shell & emacs paths 
;; ---------------------------

(use-package exec-path-from-shell
  :ensure t
  :init
  (exec-path-from-shell-initialize))

;; ---------------------------
;; Appearance Configuration
;; ---------------------------

;; Install and load modus-vivendi theme
(use-package modus-themes
  :init
  (load-theme 'modus-vivendi t))

;; ---------------------------
;; Evil Mode Setup
;; ---------------------------

(use-package evil
  :init
  (setq evil-want-keybinding nil)  ; Disable default keybindings for better integration
  :config
  (evil-mode 1))                   ; Enable Evil mode globally

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))          ; Initialize Evil Collection for enhanced package integrations

(use-package evil-escape
  :after evil
  :custom
  (evil-escape-key-sequence "jk")  ; Define "jk" as the escape sequence
  (evil-escape-delay 0.2)          ; Set the maximum time between key presses
  :config
  (evil-escape-mode 1))            ; Enable Evil Escape globally

;; ---------------------------
;; Keybindings
;; ---------------------------

;; Jump to end of line
(define-key evil-normal-state-map (kbd "L") 'evil-end-of-line)

;; Jump to beginning of line
(define-key evil-normal-state-map (kbd "H") 'evil-beginning-of-line)

;; Move back and forward between open buffers
(define-key evil-normal-state-map (kbd "C-h") 'previous-buffer)
(define-key evil-normal-state-map (kbd "C-l") 'next-buffer)

;; Enter Dired (Directory Editor)
(define-key evil-normal-state-map (kbd "SPC d") 'dired)

;; Ensure Evil is loaded before setting keybindings
(with-eval-after-load 'evil
  ;; Define C-u in Dired's Normal state to navigate up a directory
  (evil-define-key 'normal dired-mode-map (kbd "C-u") 'dired-up-directory))

;; Enter Magit (Git interface)
(define-key evil-normal-state-map (kbd "SPC m") 'magit)

;; ---------------------------
;; Auto-completions
;; ---------------------------

;; Enable Ido mode for enhanced completion
(use-package ido
  :init
  (ido-mode t)
  (ido-everywhere t)
  :config
  (setq ido-enable-flex-matching t
        ido-use-faces nil))

;; Enable Auto-Pairing of Delimiters
(electric-pair-mode 1)

;; ---------------------------
;; Tree-sitter Setup
;; ---------------------------

(use-package tree-sitter
  :hook
  (after-init . global-tree-sitter-mode)
  :config
  ;; Enable Tree-sitter-based syntax highlighting
  (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode))

(use-package tree-sitter-langs
  :after tree-sitter)

;; ---------------------------
;; TypeScript/TSX Setup
;; ---------------------------

;; Use `typescript-mode` for `.ts` and `web-mode` for `.tsx`
(use-package typescript-mode
  :mode "\\.ts\\'"
  :hook ((typescript-mode . tree-sitter-mode)
         (typescript-mode . eglot-ensure))
  :config
  ;; Optional: Set indentation level
  (setq typescript-indent-level 2))

(use-package web-mode
  :mode "\\.tsx\\'"
  :hook ((web-mode . tree-sitter-mode)
         (web-mode . eglot-ensure))
  :config
  ;; Adjust web-mode settings for TSX
  (setq web-mode-enable-auto-quoting nil)  ;; Disable automatic quotes
  (setq web-mode-code-indent-offset 2)     ;; Set indentation level
  (setq web-mode-markup-indent-offset 2))

;; ---------------------------
;; Language Server Protocol (eglot)
;; ---------------------------

;; Use-package configuration for Eglot
(use-package eglot
  :ensure t
  :config
  ;; Add TypeScript LSP for typescript-mode
  (add-to-list 'eglot-server-programs
               '(typescript-mode . ("typescript-language-server" "--stdio")))

  ;; Add TypeScript LSP for web-mode (for TSX files)
  (add-to-list 'eglot-server-programs
               '(web-mode . ("typescript-language-server" "--stdio")))

  ;; Automatically shutdown eglot when closing the last buffer
  (setq eglot-autoshutdown t))

;; Ensure eglot-ensure is hooked to typescript and web-mode
(add-hook 'typescript-mode-hook 'eglot-ensure)
(add-hook 'web-mode-hook 'eglot-ensure)

;; ---------------------------
;; Version Control (Magit)
;; ---------------------------

;; Magit: A text-based GIT interface
(use-package magit
  :commands magit-status)

;; ---------------------------
;; Custom File Setup
;; ---------------------------

;; Specify the custom file to separate Emacs' custom-set variables and faces
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))

;; Load the custom file if it exists, without errors
(when (file-exists-p custom-file)
  (load custom-file 'noerror 'nomessage))

;; ---------------------------
;; End of Configuration
;; ---------------------------
