;; init.el -- Emacs Configuration File

;; System Settings
(prefer-coding-system 'utf-8)                                               ; Use utf-8 everywhere
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)

(setq inhibit-startup-message t)                                            ; Disable Emacs welcome screen
(setq ring-bell-function 'ignore)                                           ; Turn off all alarms (audio/visual bells) 
(setq undo-limit 6710886400)                                                ; Increase undo limit to 64MB
(defalias 'yes-or-no-p 'y-or-n-p)                                           ; Answer 'y' or 'n' for text-mode prompts

(setq backup-directory-alist                                                ; Place all backups and autosaves in a single directory
      `(("." . ,(expand-file-name "tmp/backups/" user-emacs-directory))))

;; UI Settings
(scroll-bar-mode -1)                                                        ; Disable visible scrollbar
(tool-bar-mode -1)                                                          ; Disable the toolbar
(tooltip-mode -1)                                                           ; Disable tooltips
(set-fringe-mode 10)                                                        ; Add a little space around the border 
(menu-bar-mode -1)                                                          ; Disable the menu bar
(column-number-mode t)                                                      ; Show column number in footer
(global-display-line-numbers-mode t)                                        ; Turn on line numbers globally
(dolist (mode '(org-mode-hook                                               ; Disable line numbers for some modes
		term-mode-hook
		shell-mode-hook
		eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))


(set-face-attribute 'default nil :font "Iosevka Term" :height 180)          ; Set typeface and height
(load-theme 'modus-vivendi)                                                 ; Load custom theme


;; Set up Straight.el as emacs package manager
(defvar bootstrap-version)                                                  ; Codeblock to bootstrap Straight.el
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


;; Evil Package
(straight-use-package 'evil)                                                ; Extensible VI layer for Emacs 
(evil-mode 1)                                                               ; Initialise evil-mode
(straight-use-package 'undo-fu)                                             ; Simple, linear undo with redo for Emacs
(setq evil-undo-system 'undo-fu)                                            ; Set evil undo to undo-fu package

(define-key evil-insert-state-map (kbd "jk") 'evil-normal-state)            ; Exit evil-insert-mode with 'jk' key press
(define-key evil-normal-state-map (kbd "<left>") 'evil-prev-buffer)         ; Navigate to last buffer on arrow-left key press 
(define-key evil-normal-state-map (kbd "<right>") 'evil-next-buffer)        ; Navigate to next buffer on arrow-right key press 
(evil-global-set-key 'motion "j" 'evil-next-visual-line)                    ; Next line includes wrapped lines
(evil-global-set-key 'motion "k" 'evil-previous-visual-line)                ; Previous line includes wrapped lines
(evil-global-set-key 'normal (kbd "C-l") 'evil-window-right)                ; Move to right window
(evil-global-set-key 'normal (kbd "C-h") 'evil-window-left)                 ; Move to right window
(define-key evil-normal-state-map (kbd "L") 'evil-end-of-line)              ; Navigate to last buffer on arrow-left key press 
(define-key evil-normal-state-map (kbd "H") 'evil-beginning-of-line)        ; Navigate to next buffer on arrow-right key press 


;; Which-key Package
(straight-use-package 'which-key)                                           ; Displays available keybindings in popup
(which-key-mode)                                                            ; Initialise which-key-mode
(setq which-key-idle-delay 0.3)                                             ; Delay which-key popup

;; Magit Package
(straight-use-package 'magit)                                               ; Text-based user interface to Git
