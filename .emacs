;;; Japanese settings
(set-language-environment "Japanese")
(prefer-coding-system 'utf-8)
;(set-face-attribute 'default nil :family "Motoya LMaru" :height 135)
;(set-face-attribute 'default nil :family "Ricty Diminished" :height 135)
(set-face-attribute 'default nil :family "Ricty Diminished" :height 130)
;(set-face-attribute 'default nil :family "Ricty Diminished" :height 120)

;;; MELPA
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)
;(package-initialize)

;;; font-lock
(global-font-lock-mode 1)

;;; text-mode
(defun remove-electric-indent-mode ()
  (electric-indent-local-mode -1))
(add-hook 'text-mode-hook 'flyspell-mode)
(add-hook 'text-mode-hook 'remove-electric-indent-mode)
(setq-default indent-tabs-mode nil)

;;; c-mode settings
(add-hook 'c-mode-common-hook
          (function
           (lambda()
             (setq truncate-lines t)
             (setq tab-width 4)
             )))
(defun my-c-mode-hook ()
  (c-set-style "cc-mode")
  (setq c-doc-comment-style 'javadoc)
  (c-set-offset 'innamespace 0)
  (c-set-offset 'inline-open 0)
  (c-set-offset 'inextern-lang 0)
  (c-set-offset 'topmost-intro-cont 0))
(add-hook 'c-mode-hook 'my-c-mode-hook)
(add-hook 'c++-mode-hook 'my-c-mode-hook)

;;; Python3
(add-to-list 'interpreter-mode-alist '("python3" . python-mode))

;;; tiny customizations
(setq query-replace-highlight t)
(setq default-fill-column 74)
(setenv "LC_TIME" "C") ; for dired
(auto-compression-mode 1)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(setq backup-inhibited t)
(setq next-line-add-newlines nil)
(setq kill-whole-line t)
(setq mouse-yank-at-point t)
(setq require-final-newline t)
(put 'erase-buffer 'disabled nil)
(column-number-mode 1)
(show-paren-mode 1)
(transient-mark-mode 1)
(display-time)
(setq inhibit-startup-screen t)

;;; dns-mode
(add-hook 'dns-mode-hook
          (lambda ()
            (setq tab-width 8)
            (setq indent-tabs-mode t)))

;;; go-mode
(setq gofmt-command (concat (file-name-as-directory (getenv "HOME"))
                            "go/bin/goimports"))
(add-hook 'go-mode-hook
          (lambda ()
            (setq truncate-lines t)
            (setq tab-width 4)))
(add-hook 'before-save-hook 'gofmt-before-save)

;;; SQL mode
(setq sql-product 'mysql)

;;; sh mode
(setq-default sh-shell 'sh)
(add-hook 'after-save-hook 'executable-make-buffer-file-executable-if-script-p)

;;; JSON
(setq auto-mode-alist (nconc '(("\\.json\\'" . js-mode)) auto-mode-alist))

;;; github favored markdown (in emacs-goodies-el package)
(setq markdown-follow-wiki-link-on-enter nil)
(setq auto-mode-alist (nconc '(("\\.md\\'" . markdown-mode)) auto-mode-alist))

;;; YAML
(add-hook 'yaml-mode-hook 'remove-electric-indent-mode)

;;; white space highliting (in emacs-goodies-el)
(require 'show-wspace)
(add-hook 'font-lock-mode-hook 'show-ws-highlight-trailing-whitespace)
(add-hook 'font-lock-mode-hook 'show-ws-highlight-tabs)

;;; uniquify - name buffers in different way
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)

;;; Makefile mode
(setq makefile-electric-keys t)

;;; SKK
(load-library "skk-setup")
(setq skk-backup-jisyo nil)
(setq skk-cdb-large-jisyo "/usr/share/skk/SKK-JISYO.L.cdb")

;;; key bindings
(global-set-key "\C-m" 'newline-and-indent)
(global-set-key "\C-cf" 'fill-paragraph)
(global-set-key "\C-cr" 'fill-region)
(global-set-key "\M-g" 'goto-line)
(global-set-key "\C-h" 'delete-backward-char)

;;; frames
(when window-system (set-frame-size (selected-frame) 100 52))
(add-to-list 'default-frame-alist '(height . 52))
(add-to-list 'default-frame-alist '(width . 100))
(global-set-key "\C-cl"
                (lambda ()
                  (interactive)
                  (set-frame-size (selected-frame) 100 52)))

;;; custom
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages (quote (yaml-mode toml-mode systemd markdown-mode))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(fixed-pitch ((t nil))))
