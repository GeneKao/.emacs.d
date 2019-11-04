;;; custom-example.el --- user customization file    -*- no-byte-compile: t -*-
;;; Commentary:
;;;       Copy custom-example.el to custom.el and change the configurations,
;;;       then restart Emacs.
;;; Code:

;; (setq centaur-logo nil)                        ; Logo file or nil (official logo)
(setq centaur-full-name "Gene Kao")               ; User full name
(setq centaur-mail-address "kao.gene@gmail.com")  ; Email address
;; (setq centaur-proxy "127.0.0.1:1080")          ; Network proxy
(setq centaur-package-archives 'emacs-china)      ; Package repo: melpa, emacs-china or tuna
(setq centaur-theme 'dark)                         ; Color theme: default, doom, classic, dark, light or daylight
(setq centaur-lsp 'eglot)                         ; Set LSP client: lsp-mode, eglot or nil
(setq centaur-emoji-enabled t)                 ; Enable/disable emoji: t or nil
;; (setq centaur-benchmark-enabled t)             ; Enable/disable initialization benchmark: t or nil


;; For Emacs devel
;; e.g. 24.5, 25.3 or 26.1 are releses, while 26.0.90 is a devel release.
;; (when (= emacs-minor-version 0)
;;   (setq package-user-dir (locate-user-emacs-file "elpa-devel"))
;;   (setq desktop-base-file-name ".emacs-devel.desktop")
;;   (setq desktop-base-lock-name ".emacs-devel.desktop.lock"))

;; You may add addtional configurations here
;; (custom-set-variables )

;;; custom-example.el ends here
;; (custom-set-variables
;;  ;; custom-set-variables was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  '(centuar-company-enable-yas t t)
;;  '(diff-hl-draw-borders nil)
;;  '(fringe-mode (quote (4 . 8)) nil (fringe))
;;  '(fringes-outside-margins t t)
;;  '(send-mail-function (quote mailclient-send-it)))
;; (custom-set-faces
;;  ;; custom-set-faces was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  '(aw-leading-char-face ((t (:inherit (quote font-lock-keyword-face) :height 2.0))))
;;  '(aw-mode-line-face ((t (:inherit (quote mode-line-emphasis) :bold t))))
;;  '(diff-hl-change ((t (:background "DeepSkyBlue"))))
;;  '(diff-hl-delete ((t (:background "OrangeRed"))))
;;  '(diff-hl-insert ((t (:background "YellowGreen"))))
;;  '(hl-todo ((t (:box t :bold t)))))




;; Fonts
(when (display-graphic-p)
  ;; Set default fonts
  (cond
   ((member "Source Code Pro" (font-family-list))
    (set-face-attribute 'default nil :font "Source Code Pro"))
   ((member "Menlo" (font-family-list))
    (set-face-attribute 'default nil :font "Menlo"))
   ((member "Monaco" (font-family-list))
    (set-face-attribute 'default nil :font "Monaco"))
   ((member "DejaVu Sans Mono" (font-family-list))
    (set-face-attribute 'default nil :font "DejaVu Sans Mono"))
   ((member "Consolas" (font-family-list))
    (set-face-attribute 'default nil :font "Consolas")))

  (cond
   (sys/mac-x-p
    (set-face-attribute 'default nil :height 130))
   (sys/win32p
    (set-face-attribute 'default nil :height 110)))

  ;; Specify fonts for all unicode characters
  (cond
   ((member "Apple Color Emoji" (font-family-list))
    (set-fontset-font t 'unicode "Apple Color Emoji" nil 'prepend))
   ((member "Symbola" (font-family-list))
    (set-fontset-font t 'unicode "Symbola" nil 'prepend)))

  ;; Specify fonts for Chinese characters
  (cond
   ((member "WenQuanYi Micro Hei" (font-family-list))
    (set-fontset-font t '(#x4e00 . #x9fff) "WenQuanYi Micro Hei"))
   ((member "Microsoft Yahei" (font-family-list))
    (set-fontset-font t '(#x4e00 . #x9fff) "Microsoft Yahei")))
  )

;; Misc.
;; (setq confirm-kill-emacs 'y-or-n-p)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
