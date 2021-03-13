;; init-python.el --- Initialize python configurations.	-*- lexical-binding: t -*-

;; Copyright (C) 2010-2020 Vincent Zhang

;; Author: Vincent Zhang <seagle0128@gmail.com>
;; URL: https://github.com/seagle0128/.emacs.d

;; This file is not part of GNU Emacs.
;;
;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 2, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth
;; Floor, Boston, MA 02110-1301, USA.
;;

;;; Commentary:
;;
;; Python configurations.
;;

;;; Code:

(eval-when-compile
  (require 'init-const)
  (require 'init-custom))

;; Python Mode
;; Install: pip install pyflakes autopep8
(use-package python
  :ensure nil
  :hook (inferior-python-mode . (lambda ()
                                  (process-query-on-exit-flag
                                   (get-process "Python"))))
  :init
  ;; Disable readline based native completion
  (setq python-shell-completion-native-enable nil)
  :config
  ;; Default to Python 3. Prefer the versioned Python binaries since some
  ;; systems stupidly make the unversioned one point at Python 2.
  (when (and (executable-find "python3")
             (string= python-shell-interpreter "python"))
    (setq python-shell-interpreter "python3"))
  ;; Env vars
  (with-eval-after-load 'exec-path-from-shell
    (exec-path-from-shell-copy-env "PYTHONPATH"))
  ;; Live Coding in Python

  (use-package live-py-mode)

  ;; Format using YAPF
  ;; Install: pip install yapf
  (use-package yapfify
    :diminish yapf-mode
    :hook (python-mode . yapf-mode)))

  ;; (unless centaur-lsp
  ;;   ;; Anaconda mode
  ;;   (use-package anaconda-mode
  ;;     :defines anaconda-mode-localhost-address
  ;;     :diminish anaconda-mode
  ;;     :hook ((python-mode . anaconda-mode)
  ;;            (python-mode . anaconda-eldoc-mode))
  ;;     :config
  ;;     ;; WORKAROUND: https://github.com/proofit404/anaconda-mode#faq
  ;;     (when sys/macp
  ;;       (setq anaconda-mode-localhost-address "localhost"))
  ;;     (use-package company-anaconda
  ;;       :after company
  ;;       :defines company-backends

  ;;       :init (cl-pushnew 'company-anaconda company-backends)))))


  ;; Add conda environment
  (use-package pyvenv
    :init
    (setenv "WORKON_HOME" "~/anaconda3/envs")
    (pyvenv-mode 1))

    ;; (require 'conda)
    ;; ;; if you want interactive shell support, include:
    ;; (conda-env-initialize-interactive-shells)
    ;; ;; if you want eshell support, include:
    ;; (conda-env-initialize-eshell)
    ;; ;; if you want auto-activation (see below for details), include:
    ;; (conda-env-autoactivate-mode t)

    ;; (custom-set-variables
    ;;  '(conda-anaconda-home "~/anaconda3"))


    (provide 'init-python)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; init-python.el ends here
