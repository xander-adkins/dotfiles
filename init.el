;;; init.el --- MINIMA's configuration entry point.
;;
;; Copyright (c) 2022 Alexander Adkins
;;
;; Author: Alexander Adkins <alexander.adkins@icloud.com>
;; URL: https://github.com/xander-adkins/minima





;; Use utf-8 everywhere
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)

;; Increase undo limit to 64MB
(setq undo-limit 6710886400)

;; Disable Emacs welcome screen
(setq inhibit-startup-message t)

;; Turn off all alarms (audio/visual bells)
(setq ring-bell-function 'ignore)

;; Answer 'y' or 'n' for text-mode prompts
(defalias 'yes-or-no-p 'y-or-n-p)

;; Write auto-saves and backups to separate directory
(make-directory "~/.tmp/emacs/auto-save/" t)
(setq auto-save-file-name-transforms '((".*" "~/.tmp/emacs/auto-save/" t)))
(setq backup-directory-alist '(("." . "~/.tmp/emacs/backup/")))

;; Do not move the current file while creating backup.
(setq backup-by-copying t)

;; Write customizations to a separate file instead of this file.
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file t)





;; Disable Default Emacs UI Elements
(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(menu-bar-mode -1)

;; Add padding around the window border
(set-fringe-mode 10)

;; Show column number in footer
(column-number-mode t)

;; Set typeface and height
(set-face-attribute 'default nil :font "Iosevka Term" :height 180)

;; Load custom theme
(load-theme 'modus-vivendi)

;; Show stray whitespace.
(setq-default show-trailing-whitespace t)






;; Bootstrap Straight.el
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
	(url-retrieve-synchronously
	 "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
	 'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; Install use-package
(straight-use-package 'use-package)

;; Configure use-package to use straight.el by default
(use-package straight
	 :custom (straight-use-package-by-default t))





;; Evil VIM key bindings
(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-undo-system 'undo-fu)
  :config
  (evil-mode 1))

;; A set of keybindings for evil-mode
(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

;; Package for sensible redo support
(use-package undo-fu)

;; Next line includes wrapped lines
(evil-global-set-key 'motion "j" 'evil-next-visual-line)
;; Previous line includes wrapped lines
(evil-global-set-key 'motion "k" 'evil-previous-visual-line)
;; Move to right window
(evil-global-set-key 'motion "C-l" 'evil-window-right)
;; Move to left window
(evil-global-set-key 'motion "C-h" 'evil-window-left)
;; Jump to end of line
(define-key evil-normal-state-map (kbd "L") 'evil-end-of-line)
;; Jump to beginning of line
(define-key evil-normal-state-map (kbd "H") 'evil-beginning-of-line)







;; Syntax Highlighting with Tree Sitter
(use-package tree-sitter
  :ensure t
  :config
  ;; activate tree-sitter on any buffer containing code for which it has a parser available
  (global-tree-sitter-mode)
  ;; you can easily see the difference tree-sitter-hl-mode makes for python, ts or tsx
  ;; by switching on and off
  (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode))

(use-package tree-sitter-langs
  :ensure t
  :after tree-sitter)

(use-package typescript-mode
  :after tree-sitter
  :config
  ;; we choose this instead of tsx-mode so that eglot can automatically figure out language for server
  ;; see https://github.com/joaotavora/eglot/issues/624 and https://github.com/joaotavora/eglot#handling-quirky-servers
  (define-derived-mode typescriptreact-mode typescript-mode
    "TypeScript TSX")

  ;; use our derived mode for tsx files
  (add-to-list 'auto-mode-alist '("\\.tsx?\\'" . typescriptreact-mode))
  ;; by default, typescript-mode is mapped to the treesitter typescript parser
  ;; use our derived mode to map both .tsx AND .ts -> typescriptreact-mode -> treesitter tsx
  (add-to-list 'tree-sitter-major-mode-language-alist '(typescriptreact-mode . tsx)))

;; auto-format different source code files extremely intelligently
;; https://github.com/radian-software/apheleia
(use-package apheleia
  :config
  (apheleia-global-mode +1))


;; Eglot for code intelligence
(use-package eglot)



;; Which-key Package
(straight-use-package 'which-key)
(which-key-mode)
(setq which-key-idle-delay 0.3)

;; Magit text based GIT interface
(use-package magit)






;; Quick access to init.el
(defun init-file ()
  "Edit the `user-init-file', in another window."
  (interactive)
  (find-file-other-window user-init-file))
