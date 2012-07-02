#
# This is the Makefile for formatting the Linux System Administrators' Guide.
# You need LaTeX2e (probably a recent version), fig2dev (version 3), and
# the usual UNIX tools to run everything.  The distribution contains
# all formatted files (especially figures).
#
# Command ``make'' will format the book into .dvi and PostScript.
# Command ``make clean'' will remove all formatted files.
#

# make _should_ set this
SHELL=/bin/sh

#
# The following are implicit rules for make that tell it how to
# convert a .fig to a .ps or a .tex.
#
.fig.ps:
	fig2dev -Lps $< > $@
.fig.tex:
	fig2dev -Llatex $< > $@
.SUFFIXES: $(SUFFIXES) .fig .ps .tex

#
# The book consists of a huge number of files.  Each chapter has its
# own macro that tells which files are needed to format it.  Some of
# the files may need to be built first.
#

backups = \
	backups/backups.tex \
	backups/backup-timeline.ps

boothalt = \
	boothalt/boothalt.tex

disks = \
	disks/disks.tex \
	disks/hd-mount-mounted.ps \
	disks/hd-mount-separate.ps \
	disks/hd-layout.ps \
	disks/hd-schematic.ps
	
emergencies = \
	emergencies/emergencies.tex

glossary = \
	glossary/glossary.tex
	
init = \
	init/init.tex
	
intro = \
	intro/intro.tex intro/blurb.tex intro/convntns.tex intro/rhyme.tex

logins = \
	logins/logins.tex \
	logins/logins-via-terminals.ps
	
measure = \
	measure-holes/measure-holes.tex

mem = \
	mem/mem.tex

overview = \
	overview/overview.tex \
	overview/overview-kernel.ps
	
printing = \
	printing/printing.tex
	
security = \
	security/security.tex

time = \
	time/time.tex
	
useradmin = \
	useradmin/useradmin.tex

walkabout = \
	walkabout/walkabout.tex \
	walkabout/fstree.ps

sources = \
	sag.tex \
	sag.bib \
	linuxdoc.sty \
	frontmatter.tex \
	linux-logo.ps \
	contents.tex \
	$(backups) \
	$(boothalt) \
	$(disks) \
	$(emergencies) \
	$(glossary) \
	$(init) \
	$(intro) \
	$(logins) \
	$(measure) \
	$(mem) \
	$(overview) \
	$(printing) \
	$(security) \
	$(time) \
	$(useradmin) \
	$(walkabout)

all: sag.ps HTML/sag/sag.html

update: sag.ps
	./make-html -n

sag.ps: sag.dvi
	dvips -f sag.dvi > sag.ps

sag.dvi: $(sources)
	latex sag
	grep '{chapter}' sag.toc > sag.soc
	bibtex sag
	latex sag
	grep '{chapter}' sag.toc > sag.soc
	makeindex sag.idx
	latex sag
	cp sag.dvi foo.dvi

HTML/sag/sag.html: sag.dvi
	./make-html

clean:
	find . -name '*.tex~' -print | xargs rm -f
	find . -name '*.toc' -print | xargs rm -f
	find . -name '*.soc' -print | xargs rm -f
	find . -name '*.idx' -print | xargs rm -f
	find . -name '*.ind' -print | xargs rm -f
	find . -name '*.ilg' -print | xargs rm -f
	find . -name '*.aux' -print | xargs rm -f
	find . -name '*.log' -print | xargs rm -f
	find . -name '*.dvi' -print | xargs rm -f
	find . -name '*.bbl' -print | xargs rm -f
	find . -name '*.blg' -print | xargs rm -f
	find . -name '*.fig' -print | sed 's/\.fig$$/.tex/' | xargs rm -f
	find . -name '*.fig' -print | sed 's/\.fig$$/.ps/' | xargs rm -f
	find . -name '*.tex' -print | sed 's/\.tex$$/.ps/' | xargs rm -f
	rm -rf HTML

#
# Dependencies for figures.  Note that figures which do not require special
# options for building do not have to be listed here.
#

backups/backup-timeline.ps: backups/backup-timeline.fig
	fig2dev -Lps -m 0.8 $< > $@
disks/hd-schematic.ps: disks/hd-schematic.fig 
	fig2dev -Lps -m 0.5 $< > $@
disks/hd-layout.ps: disks/hd-layout.fig 
	fig2dev -Lps -m 0.75 $< > $@
walkabout/fstree.ps: walkabout/fstree.fig
	fig2dev -Lps -m 1.00 $< > $@
