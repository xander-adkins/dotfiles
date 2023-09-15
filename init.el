;;; init.el --- MINIMA's configuration entry point.
;;
;; Author: Alexander Adkins <alexander.adkins@icloud.com>
;; URL: https://github.com/xander-adkins/minima


;;; Commentary:
;; My Emacs configuration file.  Nothing too fancy, but an attempt to
;; simplify life, and provide better evil customisation than the
;; heavy hitters Doom and Spacemacs


;;; Code:

;; ---------------
;; SYSTEM SETTINGS

;; Use utf-8 everywhere
(prefer-coding-system 'utf-8)
(setq-default buffer-file-coding-system 'utf-8)
(setq-default default-file-name-coding-system 'utf-8)
(setq-default default-keyboard-coding-system 'utf-8)
(setq-default default-process-coding-system '(utf-8 . utf-8))
(setq-default default-sendmail-coding-system 'utf-8)
(setq-default default-terminal-coding-system 'utf-8)

;; Increase undo limit to 64MB
(setq undo-limit (* 64 1024 1024))

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





;; -------
;; VISUALS

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

;; Default to full screen on startup
(when (not (eq (frame-parameter nil 'fullscreen) 'fullboth))
  (toggle-frame-fullscreen))

;; Auto-Complete paired delimeters
(electric-pair-mode 1)

;; Include buffer name & modified status in window title
(setq-default frame-title-format "%b %& emacs")

;; Enable visual-line-mode for Org mode
(add-hook 'org-mode-hook 'visual-line-mode)

;; Enable visual-line-mode for Markdown mode
(add-hook 'markdown-mode-hook 'visual-line-mode)

;; Enable visual-line-mode for text mode
(add-hook 'text-mode-hook 'visual-line-mode)



;; ------------------
;; PACKAGE MANAGEMENT

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

;; Diminished Modes
(use-package diminish
  :ensure t)




;; ---------
;; EVIL MODE

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
  :diminish evil-collection-unimpaired-mode
  :config
  (evil-collection-init))

;; Package for sensible redo support
(use-package undo-fu)

;; Evil Surround
(use-package evil-surround
  :ensure t
  :config
  (global-evil-surround-mode 1))

;; Key chord
(use-package key-chord
  :ensure t
  :config
  (key-chord-mode 1))

  (key-chord-define evil-insert-state-map  "jk" 'evil-normal-state)



;; -----------------
;; WINDOW MANAGEMENT

(define-key evil-normal-state-map (kbd "SPC l l") 'load-layout)


;; Undo and Redo window state changes
(winner-mode 1)

;; Winner undo state change
(evil-global-set-key 'normal (kbd "C-[") 'winner-undo)

;; Winner redo state change
(evil-global-set-key 'normal (kbd "C-]") 'winner-redo)

;; Delete all other open windows
(evil-global-set-key 'normal (kbd "C-`") 'delete-other-windows)

;; Split window vertically and move cursor right
(define-key evil-normal-state-map (kbd "C-w v") 'minima/split-window-right-and-move-cursor)

;; Split window horizontally and move cursor down
(define-key evil-normal-state-map (kbd "C-w s") 'minima/split-window-below-and-move-cursor)

;; Move to right window
(evil-global-set-key 'motion "C-l" 'evil-window-right)

;; Move to left window
(evil-global-set-key 'motion "C-h" 'evil-window-left)

;; Enlarge window horizontally
(define-key evil-normal-state-map (kbd "S-<left>") 'enlarge-window-horizontally)

;; Shrink window horizontally
(define-key evil-normal-state-map (kbd "S-<right>") 'shrink-window-horizontally)

;; Enlarge window horizontally
(define-key evil-normal-state-map (kbd "S-<left>") 'enlarge-window-horizontally)

;; Shrink window horizontally
(define-key evil-normal-state-map (kbd "S-<right>") 'shrink-window-horizontally)

;; Toggle between fullscreen and maximized frame
(defun toggle-fullscreen-maximized-frame ()
  (interactive)
  (if (frame-parameter nil 'fullscreen)
      (toggle-frame-fullscreen)
    (toggle-frame-maximized)))

;; Define a keybinding for the function
(define-key evil-normal-state-map (kbd "F") 'toggle-fullscreen-maximized-frame)

;; Load pre-configured layout with Desktop-read
(defun load-layout ()
  (interactive)
  (desktop-clear)
  (desktop-read "~/.emacs.d/layouts/"))

;; Jump to new window on horizontal split
(defun minima/split-window-below-and-move-cursor ()
  "Split the window horizontally and jump to the newly created window below."
  (interactive)
  (split-window-below)
  (other-window 1))

;; Jump to new window on vertical split
(defun minima/split-window-right-and-move-cursor ()
  "Split the window vertically and jump to the newly created window on the right."
  (interactive)
  (split-window-right)
  (other-window 1))

;; Increase, Decrease, and Reset font sizing
(define-key evil-normal-state-map (kbd "C-+") 'text-scale-increase)
(define-key evil-normal-state-map (kbd "C--") 'text-scale-decrease)
(define-key evil-normal-state-map (kbd "C-0") 'text-scale-adjust)


;; Temporarily make one buffer fullscreen with revert capability
(defun toggle-maximize-buffer () "Maximize buffer"
  (interactive)
  (if (= 1 (length (window-list)))
      (jump-to-register '_)
    (progn
      (window-configuration-to-register '_)
      (delete-other-windows))))
(define-key evil-normal-state-map (kbd "C-w w") 'toggle-maximize-buffer)


;; ----------
;; NAVIGATION

;; Avy - Jump to things
(use-package avy
  :config
  (global-set-key (kbd "C-;") 'avy-goto-char-2))

;; Smooth scrolling
(use-package smooth-scrolling
  :config (smooth-scrolling-mode t))

;; Since =Cmd+,= and =Cmd+.= move you back in forward in the current
;; buffer, the same keys with =Shift= move you back and forward
;; between open buffers.
(global-set-key (kbd "C-<") 'previous-buffer)
(global-set-key (kbd "C->") 'next-buffer)

;; Next line includes wrapped lines
(evil-global-set-key 'motion "j" 'evil-next-visual-line)

;; Previous line includes wrapped lines
(evil-global-set-key 'motion "k" 'evil-previous-visual-line)

;; Jump to previous section
(define-key evil-normal-state-map (kbd "J") 'evil-forward-section-end)

;; Jump to next section
(define-key evil-normal-state-map (kbd "K") 'evil-backward-section-begin)

;; Jump to end of line
(define-key evil-normal-state-map (kbd "L") 'evil-end-of-line)

;; Jump to beginning of line
(define-key evil-normal-state-map (kbd "H") 'evil-beginning-of-line)

;; ESC as universal gonna-ghost from here command
(define-key key-translation-map (kbd "ESC") (kbd "C-g"))

;; Enter Dired
(define-key evil-normal-state-map (kbd "SPC d") 'dired)

;; Remap 'w' to 'W' because I type this incorrectly so frequently
(evil-ex-define-cmd "W" 'evil-write)




;; -----------------------------
;; SYNTAX HIGHLIGHTING & LINTING

;; Tree Sitter
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

;; Typescript
(use-package typescript-mode
  :ensure t
  :after tree-sitter
  :config
  ;; Use typescriptreact-mode instead of tsx-mode so that eglot can automatically detect the language for the server.
  ;; See https://github.com/joaotavora/eglot/issues/624 and https://github.com/joaotavora/eglot#handling-quirky-servers
  (define-derived-mode typescriptreact-mode typescript-mode
    "TypeScript TSX")

  ;; Set our derived mode for .tsx files.
  (add-to-list 'auto-mode-alist '("\\.tsx?\\'" . typescriptreact-mode))

  ;; By default, typescript-mode is mapped to the treesitter typescript parser.
  ;; Use typescriptreact-mode to map both .tsx and .ts files to treesitter tsx.
  (add-to-list 'tree-sitter-major-mode-language-alist '(typescriptreact-mode . tsx)))

;; GLSL Syntax Highlighting
(use-package glsl-mode
  :ensure t)

;; Flycheck
(use-package flycheck
  :ensure t
  :diminish flycheck-mode
  ;; enable flycheck in all buffers by default
  :init (global-flycheck-mode)
  ;; set up flycheck for typescript mode
  :hook (typescript-mode . typescript-mode-setup))

(defun typescript-mode-setup ()
  "Custom setup for Typescript mode"
  ;; use the javascript-eslint checker for Typescript
  (setq flycheck-checker 'javascript-eslint))

;; Rust
(use-package rust-mode
  :ensure t)


;; ---------------
;; AUTO-FORMATTING

;; auto-format different source code files extremely intelligently
;; https://github.com/radian-software/apheleia
(use-package apheleia
  :ensure t
  :diminish apheleia-mode
  :config
  (apheleia-global-mode +1))

;; String Inflection
;; underscore -> UPCASE -> CamelCase conversion of names
(use-package string-inflection
  :ensure t
  :bind (("C-q" . nil)
         ("C-q C-u" . string-inflection-all-cycle)))

;; Commenting Code
;; Single Line
(define-key evil-normal-state-map (kbd "C-;") 'comment-line)
;; Region
(define-key evil-visual-state-map (kbd "C-;") 'comment-or-uncomment-region)



;; ------------------
;; PROJECT MANAGEMENT

(require 'project)


;; ----------------------
;; COMPLETION & REFERENCE

;; Eglot for code intelligence
(use-package eglot
  :ensure t
  :hook (rust-mode . eglot-ensure))

;; Company
(use-package company
  :ensure t
  :diminish company-mode
  :hook (after-init . global-company-mode)
  :init
  (setq tab-always-indent 'complete)
  (setq company-minimum-prefix-length 2)
  (setq company-idle-delay 0)
  (setq tab-always-indent 'complete)
  :bind (:map company-active-map
	 ("<tab>" . company-complete-selection)))

;; Which-key Package
(use-package which-key
  :defer 0
  :diminish which-key-mode
  :config
  (which-key-mode)
  (setq which-key-idle-delay 0.3))






;; ------
;; SEARCH

;; Quick access to init.el
(defun init ()
  "Edit the `user-init-file', in another window."
  (interactive)
  (find-file user-init-file))





;; ---
;; GIT

;; Magit text based GIT interface
(use-package magit
  :ensure t
  :commands magit-status)





;; ---------------
;; RSS FEED READER

;; An Emacs web feeds client
(use-package elfeed
  :ensure t
  :config

  ;; Reset entry-swith with custom show-entry
  (setq elfeed-show-entry-switch #'elfeed-show-entry)

  ;; Reset entry-delete with custom kill-buffer
  (setq elfeed-show-entry-delete #'elfeed-kill-buffer)

;; Hook custom font to show-mode
(setq elfeed-show-mode-hook
      (lambda ()
	(set-face-attribute 'variable-pitch (selected-frame) :font (font-spec :family "Iosevka Term" :size 18))
	(setq fill-column 120)
	(setq elfeed-show-entry-switch #'show-elfeed-custom-font)))

;; Custom Font definition
(defun show-elfeed-custom-font (buffer)
  (with-current-buffer buffer
    (setq buffer-read-only nil)
    (goto-char (point-min))
    (re-search-forward "\n\n")
    (fill-individual-paragraphs (point) (point-max))
    (setq buffer-read-only t))
  (switch-to-buffer buffer)))

;; Lazy single button navigation
(defun elfeed-scroll-up-command (&optional arg)
  "Scroll up or go to next feed item in Elfeed"
  (interactive "^P")
  (let ((scroll-error-top-bottom nil))
    (condition-case-unless-debug nil
        (scroll-up-command arg)
      (error (elfeed-show-next)))))

(defun elfeed-scroll-down-command (&optional arg)
  "Scroll down or go to previous feed item in Elfeed"
  (interactive "^P")
  (let ((scroll-error-top-bottom nil))
    (condition-case-unless-debug nil
        (scroll-down-command arg)
      (error (elfeed-show-prev)))))

;; Lazy tagging
(defun elfeed-tag-selection-as (lazy-tag)
    "Returns a function that tags an elfeed entry or selection as
LAZYTAG"
    (lambda ()
      "Toggle a tag on an Elfeed search selection"
      (interactive)
      (elfeed-search-toggle-all lazy-tag)))

;; Lazy hotkeys
(evil-define-key 'normal elfeed-show-mode-map (kbd "SPC") 'elfeed-scroll-up-command)
(evil-define-key 'normal elfeed-show-mode-map (kbd "S-SPC") 'elfeed-scroll-down-command)
(evil-define-key 'normal elfeed-search-mode-map (kbd "C-l") '(elfeed-tag-selection-as readlater))
(evil-define-key 'normal elfeed-search-mode-map (kbd "C-d") '(elfeed-tag-selection-as junk))




;; -----
;; TODOS

;; 1. Fuzzy Search
;; 2. Fuzzy Command Completion
;; 3. Snipets
;; 4. More ergonomic comments
;; 5. Lock windows in place





(provide 'init)
;;; init.el ends here
