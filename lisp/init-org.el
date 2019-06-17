;; init-org.el --- Initialize org configurations.	-*- lexical-binding: t -*-

;; Copyright (C) 2019 Vincent Zhang

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
;; Org configurations.
;;

;;; Code:

(eval-when-compile
  (require 'init-const))

(use-package org
  :ensure nil
  :commands org-try-structure-completion
  :functions hydra-org-template/body
  :custom-face
  (org-ellipsis ((t (:foreground nil))))
  :bind (("C-c a" . org-agenda)
         ("C-c b" . org-switchb))
  :hook (org-indent-mode . (lambda() (diminish 'org-indent-mode)))
  :config
  (setq org-agenda-files '("~/org")
        org-todo-keywords '((sequence "TODO(t)" "DOING(i)" "HANGUP(h)" "|" "DONE(d)" "CANCEL(c)")
                            (sequence "⚑(T)" "🏴(I)" "❓(H)" "|" "✔(D)" "✘(C)"))
        org-todo-keyword-faces '(("HANGUP" . warning)
                                 ("❓" . warning))
        org-log-done 'time
        org-catch-invisible-edits 'smart
        org-startup-indented t
        org-ellipsis (if (char-displayable-p ?) "  " nil)
        org-pretty-entities t
        org-hide-emphasis-markers t)

  (add-to-list 'org-export-backends 'md)

  ;; Override `org-switch-to-buffer-other-window' for compatibility with `shackle'
  (with-eval-after-load 'shackle
    (advice-add #'org-switch-to-buffer-other-window :override #'switch-to-buffer-other-window))

  ;; Prettify UI
  (add-hook 'org-mode-hook
            (lambda ()
              "Beautify Org Checkbox Symbol"
              (push '("[ ]" . "☐") prettify-symbols-alist)
              (push '("[X]" . "☑") prettify-symbols-alist)
              (push '("[-]" . "❍") prettify-symbols-alist)
              (push '("#+BEGIN_SRC" . "λ") prettify-symbols-alist)
              (push '("#+END_SRC" . "λ") prettify-symbols-alist)
              (prettify-symbols-mode)))

  (use-package org-bullets
    :if (char-displayable-p ?◉)
    :hook (org-mode . org-bullets-mode))

  (use-package org-fancy-priorities
    :diminish
    :defines org-fancy-priorities-list
    :hook (org-mode . org-fancy-priorities-mode)
    :config
    (unless (char-displayable-p ?❗)
      (setq org-fancy-priorities-list '("HIGH" "MID" "LOW" "OPTIONAL"))))

  ;; Babel
  (setq org-confirm-babel-evaluate nil
        org-src-fontify-natively t
        org-src-tab-acts-natively t)

  (defvar load-language-list '((emacs-lisp . t)
                               (perl . t)
                               (python . t)
                               (ruby . t)
                               (js . t)
                               (css . t)
                               (sass . t)
                               (C . t)
                               (java . t)
                               (plantuml . t)))

  ;; ob-sh renamed to ob-shell since 26.1.
  (if emacs/>=26p
      (cl-pushnew '(shell . t) load-language-list)
    (cl-pushnew '(sh . t) load-language-list))

  (use-package ob-go
    :init (cl-pushnew '(go . t) load-language-list))

  (use-package ob-rust
    :init (cl-pushnew '(rust . t) load-language-list))

  (use-package ob-ipython
    :if (executable-find "jupyter")     ; DO NOT remove
    :init (cl-pushnew '(ipython . t) load-language-list))

  (org-babel-do-load-languages 'org-babel-load-languages
                               load-language-list)

  ;; Rich text clipboard
  (use-package org-rich-yank
    :bind (:map org-mode-map
                ("C-M-y" . org-rich-yank)))

  ;; Table of contents
  (use-package toc-org
    :hook (org-mode . toc-org-mode))

  ;; Preview
  (use-package org-preview-html
    :diminish org-preview-html-mode)

  ;; Presentation
  (use-package org-tree-slide
    :diminish
    :functions (org-display-inline-images
                org-remove-inline-images)
    :bind (:map org-mode-map
                ("C-<f7>" . org-tree-slide-mode)
                :map org-tree-slide-mode-map
                ("<left>" . org-tree-slide-move-previous-tree)
                ("<right>" . org-tree-slide-move-next-tree)
                ("S-SPC" . org-tree-slide-move-previous-tree)
                ("SPC" . org-tree-slide-move-next-tree))
    :hook ((org-tree-slide-play . (lambda ()
                                    (text-scale-increase 4)
                                    (org-display-inline-images)
                                    (read-only-mode 1)))
           (org-tree-slide-stop . (lambda ()
                                    (text-scale-increase 0)
                                    (org-remove-inline-images)
                                    (read-only-mode -1))))
    :config
    (org-tree-slide-simple-profile)
    (setq org-tree-slide-skip-outline-level 2))

  ;; Pomodoro
  (use-package org-pomodoro
    :after org-agenda
    :bind (:map org-agenda-mode-map
                ("P" . org-pomodoro)))

  ;; Visually summarize progress
  (use-package org-dashboard)

  (eval-and-compile
    (defun hot-expand (str &optional mod)
      "Expand org template."
      (let (text)
        (when (region-active-p)
          (setq text (buffer-substring (region-beginning) (region-end)))
          (delete-region (region-beginning) (region-end)))
        (insert str)
        (org-try-structure-completion)
        (when mod (insert mod) (forward-line))
        (when text (insert text)))))

  (defhydra hydra-org-template (:color blue :hint nil)
    "
_c_enter  qu_o_te     _e_macs-lisp    _L_aTeX:
_l_atex   _E_xample   p_y_thon        _i_ndex:
_a_scii   _v_erse     ip_Y_thon       _I_NCLUDE:
_s_rc     _g_o        _r_uby          _H_TML:
_h_tml    _S_HELL     _p_erl          _A_SCII:
^ ^       ^ ^         _P_erl tangled  plant_u_ml
"
    ("s" (hot-expand "<s"))
    ("E" (hot-expand "<e"))
    ("o" (hot-expand "<q"))
    ("v" (hot-expand "<v"))
    ("c" (hot-expand "<c"))
    ("l" (hot-expand "<l"))
    ("h" (hot-expand "<h"))
    ("a" (hot-expand "<a"))
    ("L" (hot-expand "<L"))
    ("i" (hot-expand "<i"))
    ("e" (hot-expand "<s" "emacs-lisp"))
    ("y" (hot-expand "<s" "python :results output"))
    ("Y" (hot-expand "<s" "ipython :session :exports both :results raw drawer\n$0"))
    ("g" (hot-expand "<s" "go :imports '\(\"fmt\"\)"))
    ("p" (hot-expand "<s" "perl"))
    ("r" (hot-expand "<s" "ruby"))
    ("S" (hot-expand "<s" "sh"))
    ("u" (hot-expand "<s" "plantuml :file CHANGE.png"))
    ("P" (progn
           (insert "#+HEADERS: :results output :exports both :shebang \"#!/usr/bin/env perl\"\n")
           (hot-expand "<s" "perl")))
    ("I" (hot-expand "<I"))
    ("H" (hot-expand "<H"))
    ("A" (hot-expand "<A"))
    ("<" self-insert-command "ins")
    ("q" nil "quit"))

  (bind-key "<"
            (lambda () (interactive)
              (if (or (region-active-p) (looking-back "^\s*" 1))
                  (hydra-org-template/body)
                (self-insert-command 1)))
            org-mode-map))

(setq org-latex-pdf-process
      '("latexmk -pdflatex='pdflatex -interaction nonstopmode' -pdf -bibtex -f %f"))



;; (unless (boundp 'org-latex-classes)
;;   (setq org-latex-classes nil))

;; (add-to-list 'org-latex-classes
;;              '("assignment"
;;                "\\documentclass[11pt,a4paper]{article}
;; \\usepackage[utf8]{inputenc}
;; \\usepackage[T1]{fontenc}
;; \\usepackage{fixltx2e}
;; \\usepackage{graphicx}
;; \\usepackage{longtable}
;; \\usepackage{float}
;; \\usepackage{wrapfig}
;; \\usepackage{rotating}
;; \\usepackage[normalem]{ulem}
;; \\usepackage{amsmath}
;; \\usepackage{textcomp}
;; \\usepackage{marvosym}
;; \\usepackage{wasysym}
;; \\usepackage{amssymb}
;; \\usepackage{hyperref}
;; \\usepackage{mathpazo}
;; \\usepackage{color}
;; \\usepackage{enumerate}
;; \\definecolor{bg}{rgb}{0.95,0.95,0.95}
;; \\tolerance=1000
;;       [NO-DEFAULT-PACKAGES]
;;       [PACKAGES]
;;       [EXTRA]
;; \\linespread{1.1}
;; \\hypersetup{pdfborder=0 0 0}"
;;                ("\\section{%s}" . "\\section*{%s}")
;;                ("\\subsection{%s}" . "\\subsection*{%s}")
;;                ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
;;                ("\\paragraph{%s}" . "\\paragraph*{%s}")))


;; (add-to-list 'org-latex-classes '("ebook"
;;                                   "\\documentclass[11pt, oneside]{memoir}
;; \\setstocksize{9in}{6in}
;; \\settrimmedsize{\\stockheight}{\\stockwidth}{*}
;; \\setlrmarginsandblock{2cm}{2cm}{*} % Left and right margin
;; \\setulmarginsandblock{2cm}{2cm}{*} % Upper and lower margin
;; \\checkandfixthelayout
;; % Much more laTeX code omitted
;; "
;;                                   ("\\chapter{%s}" . "\\chapter*{%s}")
;;                                   ("\\section{%s}" . "\\section*{%s}")
;;                                   ("\\subsection{%s}" . "\\subsection*{%s}")
;;                                   ))



(provide 'init-org)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; init-org.el ends here
