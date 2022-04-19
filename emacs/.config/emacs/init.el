;; -*- coding: utf-8; mode: emacs-lisp; -*-

;;; PACKAGE MAGAGEMENT:
(require 'package)

;; debugging:
;;(debug-on-entry 'package-initialize)
;;(setq debug-on-error t)

;; disable initial initialization:
(setq package-enable-at-startup nil)

;; attempt to verify signatures; possible values:
;; - allow-unsigned: signed will be checked, unsigned can still be installed
;; - t: at least one signature must be valid
;; - all: all signatures must be valid
;; - nil: don't check?
(setq package-check-signature 'allow-unsigned)

;; add different repositories:
(add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/") t)
(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/") t)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)

;; set repository priority:
(setq package-archive-priorities
      '(("gnu" . 15)
        ("org" . 10)
        ("melpa-stable" . 5)
        ("melpa" . 0)))

;; list the packages you want:
(setq package-list
    '(
        ;;citeproc
        ;;dash
        ;;dired-x
        emacsql
        emacsql-sqlite
        emacsql-sqlite3
        f
        git-commit
        htmlize
        magit
        magit-section
        ;;oc-csl
        openwith
        org
        org-drill
        ;;org-protocol
        org-roam
        ;;org-roam-protocol
        ;;ox-extra
        persist
        s
        string-inflection
        transient
        with-editor
        ))

;; activate all the packages;
(package-initialize)

;; refresh the packages descriptions:
(unless package-archive-contents (package-refresh-contents))

;; list of packages to load:
(setq package-load-list '(all))

;; install any missing packages:
(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))

;; add all descendant directories of a directory to your load-path
;; https://www.emacswiki.org/emacs/LoadPath
(let ((default-directory  "~/.config/emacs/lisp/"))
  (normal-top-level-add-subdirs-to-load-path))

;; add path(s) to load-path so they can be required
;;(add-to-list 'load-path (directory-file-name "~/.config/emacs/path/pkgname"))

;; Disable the splash screen (to enable it agin, replace the t with nil)
;;(setq inhibit-splash-screen t)

;; Enable transient mark mode
(transient-mark-mode 1)

;; Prevent Extraneous Tabs
(setq-default indent-tabs-mode nil)


;;; Org mode configuration:
;; Enable Org mode:
(require 'org)

;; Make Org mode work with files ending in .org
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))

;; global key bindings for org-mode
(global-set-key (kbd "C-c l") 'org-store-link)
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c c") 'org-capture)

;; handle tel: links
(require 'org-dial)

;; use skype to handle tel: links
(setq org-dial-program "skype callto:")

;; org-babel configurations for the shell
(require 'ob-shell)

;; languages to make available in org-mode
(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (python . t)
   (shell . t)
   (blockdiag . t)
   (dot . t)
   (js . t)))

;; fontify code in code blocks
(setq org-src-fontify-natively t)


;; Allow org-cut-special and org-paste special to paste folded subtrees
;; org-cut-special (C-c C-x C-w) to kill the subtree initially and then
;; org-paste-special (C-c C-x C-y) to yank that subtree
;; from https://emacs.stackexchange.com/a/35858
(setq org-yank-folded-subtrees t)

;; Adds timestamp for completion of tasks
(setq org-log-done 'time)

;; Allow for log to be put in drawers, requires configuring every word
;; in the org-todo-keywords sequence
(setq org-log-into-drawer t)

;; Keywords to use for tasks and meetings
(setq org-todo-keywords
      '((sequence "TODO(t)" "IN-PROGRESS(i!)" "WAITING(w@/!)" "|" "CANCELLED(c@)" "DONE(d!)")
        (sequence "MEET(m!)" "|" "CALLEDOFF(C!)" "MET(M!)")))

;; fast tag selection
(setq org-tag-alist
      '(("@work" . ?w)
        ("@home" . ?h)
        ("@online" . ?o)
        ("courses" . ?c)
        ("diet" . ?d)
        ("finance" . ?f)
        ("jobhunt" . ?j)
        ("meeting" . ?m)
        ("nederlands" . ?n)))

;; default target file for notes
(setq org-default-notes-file (concat org-directory "/notes.org"))

;; capture templates
(setq org-capture-templates
      '(("t" "Todo" entry (file+headline "~/org/gtd.org" "Tasks")
         "* TODO %?\n  %i\n  %a")
        ("m" "Meeting" entry (file+headline "~/org/gtd.org" "Meetings")
         "* MEET %?\n %i\n  %T\n  %a")
        ("j" "Journal" entry (file+datetree "~/org/journal.org")
         "* %?\n  Entered on %U\n  %i\n  %a")
        ("s" "Selection" entry (file+headline "~/org/capture.org" "Selections from Links")
         "* %a %^g\n %?\n %T\n %i")))

;; ignore scheduling of events after deadline
(setq org-agenda-skip-scheduled-if-deadline-is-shown "repeated-after-deadline")

;; make parent todo list count all items
(setq org-hierarchical-todo-statistics nil)

;; custom agenda views
(setq org-agenda-custom-commands
      '(("u" tags "urgent")
        ("v" tags-todo "urgent")
        ("W" todo "WAITING")
        ("x" agenda)
        ("y" agenda*)
        ("h" . "@home+Tag searches") ; describe prefix "h"
        ("hi" tags "+@home+improvement")
        ("hm" tags "+@home+maintenance")
        ("n" . "nederlands+Tag searches") ; describe prefix "n"
        ("nh" tags "+nederlands+huiswerk")
        ("o" . "@online+Tag searches") ; describe prefix "o"
        ("oc" tags "+@online+courses")
        ("oh" tags "+@online+homework")
        ("om" tags "+@online+meeting")
        ("w" . "@work+Tag searches") ; describe prefix "w"
        ("wi" tags "+@work+improvement")
        ("wj" tags "+@work+jobhunt")
        ("wm" tags "+@work+meeting")))

;; conversion of LaTeX Maths to MathML
(setq org-latex-to-mathml-convert-command
 "latexmlmath \"%i\" --presentationmathml=%o")

;; instead of ODT, use docx
;(setq org-odt-preferred-output-format "docx")


;; couldn't manage to make Emacs open mp4 files with the default option
;; so, we're using an add-on to help us force use it; we can try
;; using mpv or vlc
(require 'openwith)
(openwith-mode t)
(setq openwith-associations
      '(("\\.mp3\\'" "mpv" (file))
        ("\\.mp4\\'" "mpv" (file))
        ("\\.webm\\'" "mpv" (file))))

;; set specific browser to open links
(setq browse-url-browser-function 'browse-url-firefox)


;;; org-roam pre-configuration:
(setq org-roam-directory (file-truename "~/org-roam"))

;; disable warning about using v2
(setq org-roam-v2-ack t)

;; enable org-roam
(require 'org-roam)

;; org-roam autosync 
(org-roam-db-autosync-mode)

;;; org-roam configuration

;; what is displayed in buffer
(setq org-roam-mode-section-functions
      (list #'org-roam-backlinks-section
            #'org-roam-reflinks-section
            ;;#'org-roam-unlinked-references-section
            ))

;; for org-roam-buffer-toggle
;; recommendation in the official manual
(add-to-list 'display-buffer-alist
               '("\\*org-roam\\*"
                  (display-buffer-in-direction)
                  (direction . right)
                  (window-width . 0.33)
                  (window-height . fit-window-to-buffer)))

;; global key bindings for org-roam
(global-set-key (kbd "C-c n c") 'org-roam-capture)
(global-set-key (kbd "C-c n f") 'org-roam-node-find)
(global-set-key (kbd "C-c n g") 'org-roam-graph)
(global-set-key (kbd "C-c n r") 'org-roam-node-random)

;; global key bindings for org-roam dailies
(global-set-key (kbd "C-c n j") 'org-roam-dailies-capture-today)

;; key binding for org-roam to: add aliases, insert nodes, toggle buffer
;; get/create id, add tag, or insert node links using completion
;; NOTE: Since with-eval-after-load is a macro, not a function, it
;;     doesn't need quote to prevent arguments evaluation.  By the way,
;;     the function body doesn't need to be wrapped inside a progn.
(setq org-roam-completion-everywhere t)
(with-eval-after-load 'org
    (define-key org-mode-map (kbd "C-c n a") 'org-roam-alias-add)
    (define-key org-mode-map (kbd "C-c n i") 'org-roam-node-insert)
    (define-key org-mode-map (kbd "C-c n l") 'org-roam-buffer-toggle)
    (define-key org-mode-map (kbd "C-c n o") 'org-id-get-create)
    (define-key org-mode-map (kbd "C-c n t") 'org-roam-tag-add)
    (define-key org-mode-map (kbd "C-M-i") 'completion-at-point))

;;; org-roam-capture-templates
;; C-h v org-roam-capture-templates for more info
;(add-to-list 'org-roam-capture-templates
;             '(
;               ;;("d" "default" plain "%?" :if-new
;               ;;   (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n")
;               ;;   :unnarrowed t)
;               )
;             '("p" "project" plain
;               (function org-roam--capture-get-point) "%?"
;               :file-name "project/%<%Y-%m-%dT%H%M%S>"
;               :head "#+title: ${title}\n#+created: %<%Y-%m-%dT%H%M%S>"
;               :unnarrowed t))

; location.href='org-protocol://roam-ref?template=r&ref='+encodeURIComponent(location.href)+'&title='+encodeURIComponent(document.title)

;;; org-protocol
;; start server
(server-start)

;; require protocol packages
(require 'org-protocol)
(require 'org-roam-protocol)


;;; Magit
;; global key binding for magit
(global-set-key (kbd "C-x g") 'magit-status)


;;; Bibliography
;; require the org-cite library
(require 'citeproc)
(require 'oc)
(require 'oc-basic)
(require 'oc-biblatex)
(require 'oc-csl)
(require 'oc-natbib)

;; org-cite global bibliography
(setq org-cite-global-bibliography '("~/org/references.bib"))

;; help citeproc find CSL citation styles
(setq org-cite-csl-styles-dir (file-truename "~/.local/share/csl"))

;; set export processors by backend; fallback is t
(setq org-cite-export-processors '(
   (beamer natbib humannat)
   (latex biblatex)
   (t csl "iso690-numeric-en.csl")))

;; RefTex default bibliography
(setq reftex-default-bibliography '("~/org/references.bib"))

;; RefTex Environment variables, paths separated by colons
(setq reftex-bibpath-environment-variables
  '("/home/rolandog/Documents/references/:/home/rolandog/org/"))


;;; org-mode export configurations
;; org-export latex
(require 'ox-latex)

;; tell org to use listings
(setq org-latex-listings t)

;; add listings as a common dependency, to fontify code exports
(add-to-list 'org-latex-packages-alist '("" "listingsutf8"))

;; if you want colored source code then you need to include the color package
(add-to-list 'org-latex-packages-alist '("" "xcolor"))

;; include the option to use the "letter" class in LaTeX
(add-to-list 'org-latex-classes
        '("letter"
         "\\documentclass{letter}"
         ("\\section{%s}" . "\\section*{%s}")
         ("\\subsection{%s}" . "\\subsection*{%s}")
         ("\\subsubsection{%s}" . "\\subsubsection*{%s}")))

;; PDF export via PDFLaTeX
(setq org-latex-pdf-process (list "latexmk -bibtex -f -file-line-error -interaction=nonstopmode -output-format=pdf -pdf -shell-escape %f"))

;; do export with email
(setq org-export-with-email t)

;; don't export with priority keywords
(setq org-export-with-priority nil)

;; don't export with todo keywords
(setq org-export-with-todo-keywords nil)

;; don't export with statistics cookies [/] or [%]
(setq org-export-with-statistics-cookies nil)


;;; Emacs Sessions
;; save the state of Emacs from one session to another
(desktop-save-mode 1)
;;set to nil to disable saving the frame and window configuration
(setq desktop-restore-frames nil)

;; global key binding to toggle auto-fill mode
(global-set-key (kbd "C-c q") 'auto-fill-mode)


;;; File browsing
;; To open all of the marked files at once you need dired-x.el
;;     1. Use C-x d to visit a directory (folder)
;;     2. Mark (m) or unmark (u) the files you want to open
;;     3. You match filenames with a regular expression:
;;            % m marks files whose names that match a RegExp.
;;            % g marks files whose contents match a RegExp.
;;            * * marks executable files.
(require 'dired-x)


;;; ox-extras
;; require the package
(require 'ox-extra)

;; ignore headings
(ox-extras-activate '(ignore-headlines))


;;; Formatting
;; add es-MX and nl quotation marks to org-export-smart-quotes-alist
(push
 '("es-MX"
   (primary-opening :utf-8 "“" :html "&ldquo;" :latex "``" :texinfo "``")
   (primary-closing :utf-8 "”" :html "&rdquo;" :latex "''" :texinfo "''")
   (secondary-opening :utf-8 "‘" :html "&lsquo;" :latex "`" :texinfo "`")
   (secondary-closing :utf-8 "’" :html "&rsquo;" :latex "'" :texinfo "'")
   (apostrophe :utf-8 "’" :html "&rsquo;"))
 org-export-smart-quotes-alist)

(push
 '("nl"
   (primary-opening :utf-8 "“" :html "&ldquo;" :latex "``" :texinfo "``")
   (primary-closing :utf-8 "”" :html "&rdquo;" :latex "''" :texinfo "''")
   (secondary-opening :utf-8 "‘" :html "&lsquo;" :latex "`" :texinfo "`")
   (secondary-closing :utf-8 "’" :html "&rsquo;" :latex "'" :texinfo "'")
   (apostrophe :utf-8 "’" :html "&rsquo;"))
 org-export-smart-quotes-alist)

;; enable or disable smart-quotes
(setq org-export-with-smart-quotes t)

;; set org-indent-mode
(setq org-startup-indented t)


;;; Columns
;; display column numbers in mode line
(setq column-number-mode t)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#2d3743" "#ff4242" "#74af68" "#dbdb95" "#34cae2" "#008b8b" "#00ede1" "#e1e1e0"])
 '(custom-enabled-themes '(manoj-dark))
 '(org-agenda-files
   '("/home/rolandog/org/schedule.org" "/home/rolandog/org/albeda-a2-studiewijzer.org" "/home/rolandog/org/journal.org" "/home/rolandog/org/projects.org" "/home/rolandog/org/gtd.org" "/home/rolandog/org/dates.org"))
 '(org-export-backends '(ascii beamer html icalendar latex md odt texinfo))
 '(org-file-apps
   '((auto-mode . emacs)
     ("\\.mm\\'" . default)
     ("\\.x?html?\\'" . default)
     ("\\.pdf\\'" . default)
     ("\\.mkv\\'" . "mpv %s")
     ("\\.mp4\\'" . "mpv %s")))
 '(package-selected-packages
   '(elfeed ob-blockdiag string-inflection citeproc org-roam org-drill org openwith htmlize)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
