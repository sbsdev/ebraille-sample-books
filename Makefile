DP2    := /opt/daisy-pipeline2-cli/dp2
SAXON  := /usr/share/java/Saxon-HE.jar
FILTER_XSL := /home/eglic/src/dp2/resources/xslt/filterBrlContractionhints.xsl
BRAILLE_CODE := (liblouis-table:"de-g2.ctb")

# Add weltklasse_gotthard here locally if you have the source (copyrighted, not in git)
TITLES := defaultbook kleinere_novellen greatpainters atthezoo

SINGLE := $(patsubst %,ebraille/result/%.ebrl,$(TITLES))
MULTI  := $(patsubst %,ebraille-multi-rendition/result/%.ebrl,$(TITLES))
ZIPS   := $(patsubst %,zip/%.zip,$(TITLES))

.PHONY: all clean
.SECONDARY: $(ZIPS)

all: $(SINGLE) $(MULTI)

# $$* in prerequisites requires .SECONDEXPANSION because GNU Make does not support
# % appearing more than once within a single prerequisite path.
.SECONDEXPANSION:

# Filter braille contraction hints (output needs manual review/cleanup before building)
# Invoke as: make dtbook/kleinere_novellen/kleinere_novellen_filtered.xml
dtbook/%_filtered.xml: dtbook/$$*_original.xml
	java -jar $(SAXON) -xsl:$(FILTER_XSL) -s:$< > $@

# Bundle DTBook XML, images and stylesheet into zip for dp2
zip/%.zip: css/sbs.css $$(wildcard dtbook/$$*/*)
	zip --junk-paths $@ $^

# Single-rendition eBraille
ebraille/result/%.ebrl: zip/%.zip
	$(DP2) dtbook-to-ebraille \
	  --source $*.xml \
	  --data $< \
	  --epub-package true \
	  --braille-code '$(BRAILLE_CODE)' \
	  --include-original-text false \
	  --validation off \
	  --output ebraille \
	  --attach-stylesheet sbs.css

# Multi-rendition eBraille (braille + original text)
ebraille-multi-rendition/result/%.ebrl: zip/%.zip
	$(DP2) dtbook-to-ebraille \
	  --source $*.xml \
	  --data $< \
	  --epub-package true \
	  --braille-code '$(BRAILLE_CODE)' \
	  --include-original-text true \
	  --validation off \
	  --output ebraille-multi-rendition \
	  --attach-stylesheet sbs.css

# Single-rendition english eBraille
ebraille/result/greatpainters.ebrl: zip/greatpainters.zip
	$(DP2) dtbook-to-ebraille \
	  --source greatpainters.xml \
	  --data $< \
	  --epub-package true \
	  --braille-code '(liblouis-table:"en-ueb-g2.ctb")' \
	  --include-original-text false \
	  --validation off \
	  --output ebraille \
	  --attach-stylesheet sbs.css

# Multi-rendition english eBraille (braille + original text)
ebraille-multi-rendition/result/greatpainters.ebrl: zip/greatpainters.zip
	$(DP2) dtbook-to-ebraille \
	  --source greatpainters.xml \
	  --data $< \
	  --epub-package true \
	  --braille-code '(liblouis-table:"en-ueb-g2.ctb")' \
	  --include-original-text true \
	  --validation off \
	  --output ebraille-multi-rendition \
	  --attach-stylesheet sbs.css

# Single-rendition english eBraille
ebraille/result/atthezoo.ebrl: zip/atthezoo.zip
	$(DP2) dtbook-to-ebraille \
	  --source atthezoo.xml \
	  --data $< \
	  --epub-package true \
	  --braille-code '(liblouis-table:"en-ueb-g2.ctb")' \
	  --include-original-text false \
	  --validation off \
	  --output ebraille \
	  --attach-stylesheet sbs.css

# Multi-rendition english eBraille (braille + original text)
ebraille-multi-rendition/result/atthezoo.ebrl: zip/atthezoo.zip
	$(DP2) dtbook-to-ebraille \
	  --source atthezoo.xml \
	  --data $< \
	  --epub-package true \
	  --braille-code '(liblouis-table:"en-ueb-g2.ctb")' \
	  --include-original-text true \
	  --validation off \
	  --output ebraille-multi-rendition \
	  --attach-stylesheet sbs.css

# Rename .ebrl to .epub for clients that don't recognise the .ebrl extension
%.epub: %.ebrl
	cp $< $@

clean:
	rm -f zip/*.zip ebraille/result/* ebraille-multi-rendition/result/*
