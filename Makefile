

dist_dir=duckuments-dist/master

out_html=$(dist_dir)/duckiebook.html
out_pdf=$(dist_dir)/duckiebook.pdf

tmp_files=out/tmp

all: $(out_pdf)

.PHONY: $(out_html)

duckuments-dist:
	# clone branch "dist"
	git clone -b gh-pages git@github.com:duckietown/duckuments.git duckuments-dist

clean:
	rm -rf $(tmp_files)
	rm -rf $(dist_dir)/duckiebook*

$(out_html): $(wildcard docs/**/*md)
	$(MAKE) compile

compile-pdf:
	$(MAKE) compile
	$(MAKE) $(out_pdf)

compile:
	DISABLE_CONTRACTS=1 mcdp-render-manual \
		--src docs/ \
		--stylesheet v_manual_split \
		-o $(tmp_files) \
		--output_file $(out_html).tmp -c "config echo 1; rparmake"

	python -m mcdp_docs.add_edit_links < $(out_html).tmp > $(out_html).localcss.html
	python -m mcdp_docs.embed_css < $(out_html).localcss.html > $(out_html)

%.pdf: %.html
	prince --javascript -o $@ $<
	# open $@

split:
	python -m mcdp_docs.split $(out_html) $(dist_dir)/duckiebook
