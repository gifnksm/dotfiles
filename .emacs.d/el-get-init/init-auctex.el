(require 'tex-site)
(require 'tex)

(setq TeX-default-mode 'japanese-latex-mode)
(setq japanese-LaTeX-default-style "ltjsarticle")
(setq japanese-TeX-engine-default 'luatex)

(setq-default TeX-master nil)

(cond
 ((eq system-type 'darwin)
  (setq TeX-view-program-list
        '(("pxdvi" "/usr/texbin/pxdvi -watchfile 1 %d")
          ("PictPrinter" "/usr/bin/open -a PictPrinter.app %d")
          ("Preview" "/usr/bin/open -a Preview.app %o")
          ("TeXShop" "/usr/bin/open -a TeXShop.app %o")
          ("TeXworks" "/usr/bin/open -a TeXworks.app %o")
          ("Skim" "/usr/bin/open -a Skim.app %o")
          ("displayline" "/Applications/Skim.app/Contents/SharedSupport/displayline %n %o \"%b\"")
          ("MuPDF" "/usr/local/bin/mupdf %o")
          ("AdobeReader" "/usr/bin/open -a \"Adobe Reader.app\" %o")))
  (setq TeX-view-program-selection '((output-dvi "PictPrinter")
                                     (output-pdf "displayline")))))

(defun LaTeX-mode-hook-fn ()
  (add-to-list 'TeX-command-list
               '("Latexmk" "/usr/texbin/latexmk %t"
                 TeX-run-TeX nil (latex-mode) :help "Run Latexmk"))
  (add-to-list 'TeX-command-list
               '("Latexmk1" "/usr/texbin/latexmk -e '$latex=q/platex %S %(mode)/' -e '$bibtex=q/pbibtex/' -e '$makeindex=q/mendex/' -e '$dvipdf=q/dvipdfmx %%O -o %%D %%S/' -norc -gg -pdfdvi %t"
                 TeX-run-TeX nil (latex-mode) :help "Run Latexmk1"))
  (add-to-list 'TeX-command-list
               '("Latexmk2" "/usr/texbin/latexmk -e '$latex=q/platex %S %(mode)/' -e '$bibtex=q/pbibtex/' -e '$makeindex=q/mendex/' -e '$dvips=q/dvips %%O -z -f %%S | convbkmk -g > %%D/' -e '$ps2pdf=q/ps2pdf %%O %%S %%D/' -norc -gg -pdfps %t"
                 TeX-run-TeX nil (latex-mode) :help "Run Latexmk2"))
  (add-to-list 'TeX-command-list
               '("Latexmk3" "/usr/texbin/latexmk -e '$latex=q/uplatex %S %(mode)/' -e '$bibtex=q/upbibtex/' -e '$makeindex=q/mendex/' -e '$dvipdf=q/dvipdfmx %%O -o %%D %%S/' -norc -gg -pdfdvi %t"
                 TeX-run-TeX nil (latex-mode) :help "Run Latexmk3"))
  (add-to-list 'TeX-command-list
               '("Latexmk4" "/usr/texbin/latexmk -e '$latex=q/uplatex %S %(mode)/' -e '$bibtex=q/upbibtex/' -e '$makeindex=q/mendex/' -e '$dvips=q/dvips %%O -z -f %%S | convbkmk -u > %%D/' -e '$ps2pdf=q/ps2pdf %%O %%S %%D/' -norc -gg -pdfps %t"
                 TeX-run-TeX nil (latex-mode) :help "Run Latexmk4"))
  (add-to-list 'TeX-command-list
               '("Latexmk5" "/usr/texbin/latexmk -e '$pdflatex=q/pdflatex %S %(mode)/' -e '$bibtex=q/bibtex/' -e '$makeindex=q/makeindex/' -norc -gg -pdf %t"
                 TeX-run-TeX nil (latex-mode) :help "Run Latexmk5"))
  (add-to-list 'TeX-command-list
               '("Latexmk6" "/usr/texbin/latexmk -e '$pdflatex=q/lualatex %S %(mode)/' -e '$bibtex=q/bibtexu/' -e '$makeindex=q/texindy/' -norc -gg -pdf %t"
                 TeX-run-TeX nil (latex-mode) :help "Run Latexmk6"))
  (add-to-list 'TeX-command-list
               '("Latexmk7" "/usr/texbin/latexmk -e '$pdflatex=q/luajitlatex %S %(mode)/' -e '$bibtex=q/bibtexu/' -e '$makeindex=q/texindy/' -norc -gg -pdf %t"
                 TeX-run-TeX nil (latex-mode) :help "Run Latexmk7"))
  (add-to-list 'TeX-command-list
               '("Latexmk8" "/usr/texbin/latexmk -e '$pdflatex=q/xelatex %S %(mode)/' -e '$bibtex=q/bibtexu/' -e '$makeindex=q/texindy/' -norc -gg -xelatex %t"
                 TeX-run-TeX nil (latex-mode) :help "Run Latexmk8"))
  (add-to-list 'TeX-command-list
               '("pdfpLaTeX" "/usr/texbin/platex %S %(mode) %t && /usr/texbin/dvipdfmx %d"
                 TeX-run-TeX nil (latex-mode) :help "Run pLaTeX and dvipdfmx"))
  (add-to-list 'TeX-command-list
               '("pdfpLaTeX2" "/usr/texbin/platex %S %(mode) %t && /usr/texbin/dvips -Ppdf -z -f %d | /usr/texbin/convbkmk -g > %f && /usr/local/bin/ps2pdf %f"
                 TeX-run-TeX nil (latex-mode) :help "Run pLaTeX, dvips, and ps2pdf"))
  (add-to-list 'TeX-command-list
               '("pdfupLaTeX" "/usr/texbin/uplatex %S %(mode) %t && /usr/texbin/dvipdfmx %d"
                 TeX-run-TeX nil (latex-mode) :help "Run upLaTeX and dvipdfmx"))
  (add-to-list 'TeX-command-list
               '("pdfupLaTeX2" "/usr/texbin/uplatex %S %(mode) %t && /usr/texbin/dvips -Ppdf -z -f %d | /usr/texbin/convbkmk -u > %f && /usr/local/bin/ps2pdf %f"
                 TeX-run-TeX nil (latex-mode) :help "Run upLaTeX, dvips, and ps2pdf"))
  (add-to-list 'TeX-command-list
               '("pBibTeX" "/usr/texbin/pbibtex %s"
                 TeX-run-BibTeX nil t :help "Run pBibTeX"))
  (add-to-list 'TeX-command-list
               '("upBibTeX" "/usr/texbin/upbibtex %s"
                 TeX-run-BibTeX nil t :help "Run upBibTeX"))
  (add-to-list 'TeX-command-list
               '("BibTeXu" "/usr/texbin/bibtexu %s"
                 TeX-run-BibTeX nil t :help "Run BibTeXu"))
  (add-to-list 'TeX-command-list
               '("Mendex" "/usr/texbin/mendex %s"
                 TeX-run-command nil t :help "Create index file with mendex"))
  (add-to-list 'TeX-command-list
               '("Preview" "/usr/bin/open -a Preview.app %s.pdf"
                 TeX-run-discard-or-function t t :help "Run Preview"))
  (add-to-list 'TeX-command-list
               '("TeXShop" "/usr/bin/open -a TeXShop.app %s.pdf"
                 TeX-run-discard-or-function t t :help "Run TeXShop"))
  (add-to-list 'TeX-command-list
               '("TeXworks" "/usr/bin/open -a TeXworks.app %s.pdf"
                 TeX-run-discard-or-function t t :help "Run TeXworks"))
  (add-to-list 'TeX-command-list
               '("Skim" "/usr/bin/open -a Skim.app %s.pdf"
                 TeX-run-discard-or-function t t :help "Run Skim"))
  (add-to-list 'TeX-command-list
               '("displayline" "/Applications/Skim.app/Contents/SharedSupport/displayline %n %s.pdf \"%b\""
                 TeX-run-discard-or-function t t :help "Forward search with Skim"))
  (add-to-list 'TeX-command-list
               '("AdobeReader" "/usr/bin/open -a \"Adobe Reader.app\" %s.pdf"
                 TeX-run-discard-or-function t t :help "Run Adobe Reader")))

;; (setq preview-image-type 'dvipng)
(setq TeX-source-correlate-method 'synctex)
(setq TeX-source-correlate-start-server t)
(add-hook 'LaTeX-mode-hook 'TeX-source-correlate-mode)
(add-hook 'LaTeX-mode-hook 'TeX-PDF-mode)
(add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)
(add-hook 'LaTeX-mode-hook 'LaTeX-mode-hook-fn)
(add-hook 'LaTeX-mode-hook 'turn-on-reftex)
(setq reftex-plug-into-AUCTeX t)

(el-get 'sync 'auto-complete)
(el-get 'sync 'auto-complete-latex)
(require 'auto-complete-latex)
(setq ac-l-dict-directory (concat user-emacs-directory "el-get/auto-complete-latex/ac-l-dict/"))
(add-to-list 'ac-modes 'latex-mode)
(add-hook 'LaTeX-mode-hook 'ac-l-setup)
