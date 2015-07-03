CSS = book.css
HTML_TEMPLATE = template.html
TEX_HEADER = header.tex
CHAPTERS = title.txt introduction.md environment_and_booting.md \
		   getting_to_c.md output.md segmentation.md interrupts.md \
		   the_road_to_user_mode.md virtual_memory.md \
		   paging.md page_frame_allocation.md user_mode.md file_systems.md \
		   syscalls.md scheduling.md \
		   references.md
BIB = bibliography.bib
CITATION = citation_style.csl

all: book.html

book.html: $(CHAPTERS) $(CSS) $(HTML_TEMPLATE) $(BIB) $(CITATION)
	pandoc -s -S --toc -c $(CSS) --template $(HTML_TEMPLATE) \
		   --bibliography $(BIB) --csl $(CITATION) --number-sections \
		   $(CHAPTERS) -o $@

book.pdf: $(CHAPTERS) $(TEX_HEADER) $(BIB) $(CITATION)
	pandoc --toc -H $(TEX_HEADER) --latex-engine=pdflatex --chapters \
		   --no-highlight --bibliography $(BIB) --csl $(CITATION) \
		   $(CHAPTERS) -o $@

book.epub: $(CHAPTERS) $(CSS) $(TEX_HEADER) $(BIB) $(CITATION)
	pandoc -s -S --toc --toc-depth=2 -H $(TEX_HEADER) --chapters \
		   --epub-cover-image=cover.jpg --epub-stylesheet=$(CSS) \
		   --bibliography $(BIB) --csl $(CITATION) \
		   $(CHAPTERS) -o $@

book.mobi: book.epub
	kindlegen book.epub

ff: book.html
	firefox book.html

release: book.html book.pdf book.epub book.mobi
	mkdir -p ../littleosbook.github.com/images
	cp images/*.png ../littleosbook.github.com/images/
	mkdir -p ../littleosbook.github.com/files
	cp files/* ../littleosbook.github.com/files/
	cp book.pdf ../littleosbook.github.com/
	cp book.html ../littleosbook.github.com/index.html
	cp book.css ../littleosbook.github.com/
	cp book.epub ../littleosbook.github.com/
	cp book.mobi ../littleosbook.github.com/

clean:
	rm -f book.pdf book.html book.epub book.mobi
