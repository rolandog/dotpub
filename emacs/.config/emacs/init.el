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
;(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/") t)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)

;; set repository priority:
(setq package-archive-priorities
      '(("gnu" . 15)
        ;("org" . 10)
        ("melpa-stable" . 5)
        ("melpa" . 0)))

;; list the packages you want:
(setq package-list
    '(
        ;;citeproc
        ;;dash
        ;;dired-x
        emacsql
        ; emacsql-sqlite
        ; emacsql-sqlite3
        f
        ; git-commit
        htmlize
        ;magit
        ;magit-section
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
        ; transient
        ; with-editor
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


;; Abbreviations
;; see C-h p abbrev for defined abbrevs, dynamic abbrevs
;; and hippie expansion
(setq abbrev-file-name "~/.config/emacs/abbrev_defs")


;;;; Password management (password-store)

(auth-source-pass-enable)

; TODO: test if one can require 'xdg package and call (xdg-data-home)?
(setq auth-sources (list
                    (concat (getenv "XDG_DATA_HOME") "/authinfo.gpg")
                    "~/.authinfo.gpg"))


;;; Org mode configuration:
;; Enable Org mode:
(require 'org)

;; org-ai
(require 'org-ai)
(add-hook 'org-mode-hook #'org-ai-mode)
(setq org-ai-openai-api-token (funcall
                                (plist-get
                                  (car
                                    (auth-source-search
                                      :host "api.openai.com"
                                      :user "org-ai"
                                    )
                                  )
                                  :secret
                                )
                              )
)

;(defun znc ()
;  "Connect to ZNC."
;  (interactive)
;  (let ((user "thblt")
;        (pass (funcall (plist-get
;                        (car
;                         (auth-source-search
;                          :max 1
;                          :host "znc.thb.lt"))
;                        :secret))))
;    (erc-tls
;     :server "k9.thb.lt"
;     :port 2002
;     :nick user
;     :password (format "%s:%s" user pass))))


;; Make Org mode work with files ending in .org
(add-to-list 'auto-mode-alist '("\.org\'" . org-mode))
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))

;; weird org-ref error may require org-export backend
(require 'ox)
(require 'ox-org)
;(require 'ob-ipython)
;(require 'ox-ipynb)
;(add-to-list 'org-latex-listings-langs '(ipython "python"))

;; github-flavored markdown
(eval-after-load "org"
  '(require 'ox-gfm nil t))

(defun my-org-roam-update-id-locations-before-export (backend)
  "Update org-roam ID locations before exporting."
  (org-roam-update-org-id-locations))

(add-hook 'org-export-before-processing-hook 'my-org-roam-update-id-locations-before-export)


(autoload 'gnuplot-mode "gnuplot" "Gnuplot major mode" t)
(autoload 'gnuplot-make-buffer "gnuplot" "open a buffer in gnuplot-mode" t)
(add-to-list 'auto-mode-alist '("\.gp\'" . gnuplot-mode))
(add-to-list 'auto-mode-alist '("\\.gp$" . gnuplot-mode))
(add-to-list 'auto-mode-alist '("\\.gp\\'" . gnuplot-mode))

;; Enable gnuplot-mode
(require 'gnuplot)

;; Enable graphviz-dot-mode
(require 'graphviz-dot-mode)
(setq graphviz-dot-indent-width 4)

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

;; add plantuml to lang-modes
(add-to-list
  'org-src-lang-modes '("plantuml" . plantuml))

;; languages to make available in org-mode
(org-babel-do-load-languages
 'org-babel-load-languages
 '(
   (blockdiag . t)
   (ditaa . t)
   (dot . t)
   ;;(emacs-lisp . t)  ;; unknown emacs-lisp mode?
   (fortran . t)
   (gnuplot . t)
   ;(ipython . t)
   ;;(ini . t)  ;; no ob-ini, but there's a built-in conf-mode
   (js . t)
   (latex . t)
   (org . t)
   (php . t)
   (plantuml . t)
   (python . t)
   (shell . t)
   )
 )

(use-package eglot
  :config
  (add-to-list 'eglot-server-programs '((sh-mode bash-ts-mode) . ("bash-language-server" "start")))

  :hook
  (sh-mode . eglot-ensure)
  (bash-ts-mode . eglot-ensure))

;; display/update images in the buffer after evaluation
(add-hook 'org-babel-after-execute-hook 'org-display-inline-images 'append)

; thanks gregoryg and Vaddson
; https://emacs.stackexchange.com/a/64379/36303
(defun gjg/time-call (time-call &rest args)
(message "Ohai %s" args)
(let ((start-time (float-time))
      (result (apply time-call args)))
  (message "Function call took %f seconds" (- (float-time) start-time))
  result))
(advice-add 'org-babel-execute-src-block :around #'gjg/time-call)

; To remove the advice, execute
; (advice-remove 'org-babel-execute-src-block #'gjg/time-call)

;; built-in conf/ini mode; does it auto-load?
;(require 'conf-mode)

;; fontify code in code blocks
(setq org-src-fontify-natively t)

;; dynamically find jar path (fallback if not guix)
(setq org-plantuml-jar-path
      (expand-file-name
       (or (string-trim
            (shell-command-to-string
             "cat \"$(command -v plantuml)\" | tail -n 1 | awk '{print $3}'"))
           "~/.local/share/plantuml/plantuml-1.2024.7.jar")))

;; dynamically find binary (fallback if not guix)
(setq org-plantuml-jar-pathplantuml-executable-path
      (expand-file-name
       (or (string-trim
            (shell-command-to-string
             "command -v plantuml"))
           "~/.local/bin/plantuml")))

;(setq plantuml-default-exec-mode 'jar)
(setq plantuml-default-exec-mode 'executable)


;; mexican holidays
(require 'mexican-holidays)
(customize-set-variable 'holiday-bahai-holidays t)
(customize-set-variable 'holiday-hebrew-holidays t)
(customize-set-variable 'holiday-islamic-holidays t)
(setq calendar-holidays (append calendar-holidays holiday-mexican-holidays))

(require 'netherlands-holidays)
(setq calendar-holidays (append calendar-holidays holiday-netherlands-holidays))

;; Allow org-cut-special and org-paste special to paste folded
;; subtrees org-cut-special (C-c C-x C-w) to kill the subtree
;; initially and then org-paste-special (C-c C-x C-y) to yank that
;; subtree (from https://emacs.stackexchange.com/a/35858 )
(setq org-yank-folded-subtrees t)

;; causes the repeater to be ignored after the deadline
(setq org-agenda-skip-scheduled-if-deadline-is-shown 'repeated-after-deadline)

;;; clocking work time
;; assume that I have worked on this task while outside Emacs
(setq org-clock-persist t)

;; save the clock history across Emacs sessions
(setq org-clock-persist 'history)
(org-clock-persistence-insinuate)

;; app to check idle time (/usr/bin/xprintidle)
;(setq org-clock-x11idle-program-name "xprintidle")
(setq org-clock-idle-time 60)

;; seconds until auto-clockout if I forget to clock-out
(setq org-clock-auto-clockout-timer 5400)
(org-clock-auto-clockout-insinuate)

;; default duration for appointments in minutes
(setq org-agenda-default-appointment-duration 25)

;; include expected effort time in agenda
(setq org-agenda-columns-add-appointments-to-effort-sum t)

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
        ("j" "Journal" entry (file+olp+datetree "~/org/journal.org")
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
    (define-key org-mode-map (kbd "C-M-i") 'completion-at-point)
    (define-key org-mode-map (kbd "C-M-g") 'org-plot/gnuplot))

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

(setq org-roam-graph-executable
      (executable-find "neato"))

(setq org-roam-graph-extra-config '(("overlap" . "false")))


;;; org-protocol
;; start server
(server-start)

;; require protocol packages
(require 'org-protocol)
(require 'org-roam-protocol)


;;; Magit
;; global key binding for magit
;(global-set-key (kbd "C-x g") 'magit-status)


;;; Bibliography
;; require the org-cite library
(require 'citeproc)
(require 'oc)
(require 'oc-basic)
(require 'oc-biblatex)
(require 'oc-csl)
;;(require 'oc-natbib)

;; org-cite global bibliography
(setq org-cite-global-bibliography '("~/org/references.bib"))

;; help citeproc find CSL citation styles
(setq org-cite-csl-styles-dir (file-truename "~/.local/share/csl"))

;; set export processors by backend; fallback is t
(setq org-cite-export-processors '(
   (beamer biblatex)
   (latex biblatex)
   (t csl "iso690-numeric-en.csl")))


;;; org-mode export configurations
;; org-export latex
(require 'ox-latex)

;; Helps remove active objects from pdfs
(defun compress-pdf-after-latex-export (&rest _args)
  "Compress PDF file after org-latex export using Ghostscript.
This function removes active content and compresses the PDF file.
Based on the solution provided at https://tex.stackexchange.com/a/481609/29430.

The compression process removes embedded objects that might be flagged as
potential security threats in PDFs with active content. This is particularly
useful when sharing PDFs with others or submitting to systems that may
flag active content.

The function will only proceed if Ghostscript (gs) is installed on the system."
  (unless (executable-find "gs")
    (message "Ghostscript (gs) not found. Please install it to enable PDF compression.")
    (sleep-for 2)
    (return-nil))

  ;; Get the PDF file path from the current buffer
  (let* ((pdf-file (concat (file-name-sans-extension (buffer-file-name)) ".pdf"))
         (temp-file (concat pdf-file ".temp")))
    (when (file-exists-p pdf-file)
      (message "Compressing PDF and removing active content...")
      (call-process "gs" nil nil nil
                   "-dNOPAUSE"
                   "-sDEVICE=pdfwrite"
                   (concat "-sOUTPUTFILE=" temp-file)
                   "-dBATCH"
                   pdf-file)
      ;; Replace original file with compressed version
      (if (file-exists-p temp-file)
          (progn
            (delete-file pdf-file)
            (rename-file temp-file pdf-file)
            (message "PDF compression completed successfully"))
        (message "PDF compression failed")))))

;; Add advice after org-latex-export-to-pdf
(advice-add 'org-latex-export-to-pdf :after #'compress-pdf-after-latex-export)

;; set org-ref dialect as biblatex
(setq bibtex-dialect "biblatex")

;; add cleveref (and natbib?) for org-ref
(add-to-list 'org-latex-packages-alist '("" "cleveref"))
;;(add-to-list 'org-latex-packages-alist '("" "natbib"))

;; Add ability to specify :file-coding utf-8-unix on shell codeblocks
;; Thanks https://emacs.stackexchange.com/a/28890/36303
(defadvice org-babel-sh-evaluate (around set-shell activate)
  "Add header argument :file-coding that sets the buffer-file-coding-system."
  (let ((file-coding-param (cdr (assoc :file-coding params))))
    (if file-coding-param
        (let ((file-coding (intern file-coding-param))
        (default-file-coding (default-value 'buffer-file-coding-system)))
          (setq-default buffer-file-coding-system file-coding)
          ad-do-it
          (setq-default buffer-file-coding-system default-file-coding))
      ad-do-it)))

;; Add ability to remove links across all org-mode
;; thanks https://emacs.stackexchange.com/a/68142/36303
(defun night/org-remove-link-to-desc-at-point ()
    "Replace an org link by its description or if empty its address"
  (interactive)
  (if (org-in-regexp org-link-bracket-re 1)
      (save-excursion
        (let ((remove (list (match-beginning 0) (match-end 0)))
              (description
               (if (match-end 2)
                   (org-match-string-no-properties 2)
                 (org-match-string-no-properties 1))))
          (apply 'delete-region remove)
          (insert description)))))

(defun night/org-remove-link-to-desc (beg end)
  (interactive "r")
  (save-mark-and-excursion
    (goto-char beg)
    (while (re-search-forward org-link-bracket-re end t)
      (goto-char (match-beginning 0))
      (night/org-remove-link-to-desc-at-point))))


;; tell org to use listings
;(setq org-latex-listings t)

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
;(setq org-latex-pdf-process (list "latexmk -bibtex -f -file-line-error -interaction=nonstopmode -output-format=pdf -pdf -shell-escape %f"))

;; do export with email
(setq org-export-with-email t)

;; don't export with priority keywords
(setq org-export-with-priority nil)

;; don't export with tags
(setq org-export-with-tags nil)

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

;;; Stefan Monnier <foo at acm.org>. It is the opposite of fill-paragraph
(defun unfill-paragraph (&optional region)
  "Takes a multi-line paragraph and makes it into a single line of text."
  (interactive (progn (barf-if-buffer-read-only) '(t)))
  (let ((fill-column (point-max))
        ;; This would override `fill-column' if it's an integer.
        (emacs-lisp-docstring-fill-column t))
    (fill-paragraph nil region)))

;; Handy key definition
(define-key global-map "\M-Q" 'unfill-paragraph)

;; global key binding to copy as formatted text without wrapping
(global-set-key (kbd "s-w") 'ox-clip-formatted-copy) ; lower case "s" is for super

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
(require 'org-contrib)
(require 'ox-extra)

;; ignore headings
(ox-extras-activate '(ignore-headlines))


;;; Jinja2
(require 'jinja2-mode)

;; Make Jinja2 mode work with files ending in .jinja
(add-to-list 'auto-mode-alist '("\.jinja\'" . jinja2-mode))
(add-to-list 'auto-mode-alist '("\\.jinja$" . jinja2-mode))
(add-to-list 'auto-mode-alist '("\\.jinja\\'" . jinja2-mode))

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

;; format marginpar drawer
(setq org-latex-format-drawer-function
      (lambda (name contents)
              (cond ((string= name "marginpar")
                     (format "\\marginpar{%s}" contents))
                    (t (format "\\textbf{Note}: %s" contents)))))


;;; Yaml
(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))


;;; Columns
;; display column numbers in mode line
(setq column-number-mode t)


;;; Editar celdas con (mucho) contenido en las tablas de Org Mode
; gracias Juan Manuel Macías
; https://gnutas.juanmanuelmacias.com/editar_celdas.html
(defun reemplaza (antes despues)
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (re-search-forward antes nil t)
      (replace-match despues t nil))))

(defun mi-edicion-celda ()
  (interactive)
  (if (not (equal (org-element-type (org-element-at-point)) 'table-row))
      (error "No estás en una tabla!")
    (setq mi-buf (current-buffer))
    (setq desde (save-excursion
                  (re-search-backward "|" nil t)
                  (forward-char)
                  (point)))
    (setq hasta (save-excursion
                  (re-search-forward "|" nil t)
                  (forward-char -1)
                  (point)))
    (let ((celda (buffer-substring-no-properties desde hasta)))
      (when (get-buffer "edit-celda")
        (kill-buffer "edit-celda"))
      (get-buffer-create "edit-celda")
      (set-buffer "edit-celda")
      (insert celda)
      (org-mode)
      (mark-whole-buffer)
      (org-fill-paragraph)
      (deactivate-mark)
      (reemplaza "{{{nl}}}" "{{{nl}}}\n")
      (reemplaza "{{{par}}}" "{{{par}}}\n")
      (pop-to-buffer "edit-celda"))))

(defun salir-edicion-celda-y-guardar ()
  (interactive)
  (reemplaza "\n\n+" "\n")
  (save-excursion
    (goto-char (point-max))
    (when (looking-at-p "^$")
      (re-search-backward ".")
      (end-of-line)
      (delete-blank-lines)
      (delete-forward-char 1)))
  (mark-whole-buffer)
  (call-interactively 'unfill-paragraph)
  (deactivate-mark)
  (setq bufer-edit (buffer-substring-no-properties (point-min) (point-max)))
  (if (window-full-width-p)
      (kill-buffer)
    (kill-buffer-and-window))
  (switch-to-buffer mi-buf)
  (save-restriction
    (narrow-to-region desde hasta)
    (delete-region (point-min) (point-max))
    (insert bufer-edit)
    (save-buffer))
  (org-table-toggle-column-width))


;;;; anki-editor configuration
;; thanks Cheong Yiufung: https://yiufung.net/post/anki-org/

(require 'anki-editor)

;; key bindings for org-mode
(define-key org-mode-map (kbd "<f12>") 'anki-editor-cloze-region-auto-incr)
(define-key org-mode-map (kbd "<f11>") 'anki-editor-cloze-region-dont-incr)
(define-key org-mode-map (kbd "<f10>") 'anki-editor-reset-cloze-number)
(define-key org-mode-map (kbd "<f9>")  'anki-editor-push-tree)

;; resets cloze number to 1 after each capture
(add-hook 'org-capture-after-finalize-hook 'anki-editor-reset-cloze-number)

;; allow anki-editor to create a new deck if it doesn't exist
(setq anki-editor-create-decks t)
(setq anki-editor-org-tags-as-anki-tags t)

;; function definitions
(defun anki-editor-cloze-region-auto-incr (&optional arg)
  "Cloze region without hint and increase card number."
  (interactive)
  (anki-editor-cloze-region my-anki-editor-cloze-number "")
  (setq my-anki-editor-cloze-number (1+ my-anki-editor-cloze-number))
  (forward-sexp))

(defun anki-editor-cloze-region-dont-incr (&optional arg)
  "Cloze region without hint using the previous card number."
  (interactive)
  (anki-editor-cloze-region (1- my-anki-editor-cloze-number) "")
  (forward-sexp))

(defun anki-editor-reset-cloze-number (&optional arg)
  "Reset cloze number to ARG or 1"
  (interactive)
  (setq my-anki-editor-cloze-number (or arg 1)))

(defun anki-editor-push-tree ()
  "Push all notes under a tree."
  (interactive)
  (anki-editor-push-notes '(4))
  (anki-editor-reset-cloze-number))

;; initialize my-anki-editor-cloze-number to 1
(anki-editor-reset-cloze-number)


;; org-capture templates for anki
(setq org-my-anki-file
      (expand-file-name "~/org/anki.org"))

(add-to-list 'org-capture-templates
             '("a" "Anki basic"
               entry
               (file+headline org-my-anki-file "Dispatch Shelf")
               "* %<%H:%M>   %^g\n:PROPERTIES:\n:ANKI_NOTE_TYPE: Basic\n:ANKI_DECK: Mega\n:END:\n** Front\n%?\n** Back\n%x\n"))
(add-to-list 'org-capture-templates
             '("A" "Anki cloze"
               entry
               (file+headline org-my-anki-file "Dispatch Shelf")
               "* %<%H:%M>   %^g\n:PROPERTIES:\n:ANKI_NOTE_TYPE: Cloze\n:ANKI_DECK: Mega\n:END:\n** Text\n%x\n** Extra\n"))

;; allow Emacs to access content from clipboard.
(setq select-enable-clipboard t
      select-enable-primary t)


(defun make-orgcapture-frame ()
    "Create a new frame and run org-capture."
    (interactive)
    (make-frame '((name . "org-capture") (window-system . x)))
    (select-frame-by-name "org-capture")
    (org-capture)
    (delete-other-windows)
    )

;;; removed packages
; modules:
; org-annotate-file org-checklist
; selected-packages
; with-editor transient magit git-commit emacsql-sqlite emacsql-sqlite3

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#2d3743" "#ff4242" "#74af68" "#dbdb95" "#34cae2" "#008b8b" "#00ede1" "#e1e1e0"])
 '(auto-dark-themes '((leuven-dark) (leuven)))
 '(column-number-mode t)
 '(custom-enabled-themes nil)
 '(holiday-bahai-holidays t)
 '(holiday-hebrew-holidays t)
 '(holiday-islamic-holidays t)
 '(openwith-associations
   '(("\\.pdf\\'" "evince"
      (file))
     ("\\.mp3\\'" "rhythmbox-client"
      ("--play-uri=" file))
     ("\\.\\(?:mpe?g\\|avi\\|mov\\|mp4\\|webm\\|wmv\\)\\'" "mpv"
      (file))
     ("\\.\\(?:jp?g\\|png\\)\\'" "eog"
      (file))))
 '(openwith-mode t)
 '(org-agenda-files
   '("~/org-work/gtd.org" "~/org/duties.org" "~/org/habits.org" "~/org/chores.org" "~/org/capture.org" "~/org/iwt.org" "~/org/journal.org" "~/org/projects.org" "~/org/gtd.org" "~/org/dates.org"))
 '(org-columns-default-format "%40ITEM(Task) %17Effort(Estimated Effort){:} %CLOCKSUM")
 '(org-export-backends '(ascii beamer gfm html icalendar latex md odt texinfo))
 '(org-file-apps
   '((auto-mode . emacs)
     ("\\.mm\\'" . default)
     ("\\.x?html?\\'" . default)
     ("\\.pdf\\'" . "evince %s")
     ("\\.mkv\\'" . "mpv %s")
     ("\\.mp4\\'" . "mpv %s")))
 '(org-global-properties
   '(("Effort_ALL" . "0 0:05 0:10 0:25 1:00 2:00 4:00 8:00 16:00")))
 '(org-habit-graph-column 45)
 '(org-latex-src-block-backend 'listings)
 '(org-link-file-path-type 'relative)
 '(org-loop-over-headlines-in-active-region t)
 '(org-modules
   '(ol-bbdb ol-bibtex ol-docview ol-doi ol-eww ol-gnus org-habit ol-info ol-irc ol-mhe ol-rmail ol-w3m))
 '(package-selected-packages
   '(llama ox-gfm tablist pg transient anki-editor request tree-sitter-langs markdown-mode php-mode yaml-mode python-black graphviz-dot-mode ox-clip org-contrib org-ai plantuml-mode lsp-mode poetry biblio citeproc gnuplot htmlize jinja2-mode mexican-holidays netherlands-holidays ob-blockdiag ob-php ob-sql-mode openwith org org-drill org-roam org-roam-bibtex string-inflection))
 '(reftex-bibpath-environment-variables
   '("BIBINPUTS" "TEXBIB" "~/Documents/references/" "~/org/" "~/org-roam/"))
 '(reftex-default-bibliography '("~/org/references.bib")))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(require 'auto-dark)
(auto-dark-mode t)
