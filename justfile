DP2 := "/opt/daisy-pipeline2-cli/dp2"
BRAILLE_CODE := "'(liblouis-table:\"de-g2.ctb\")'"

# Display all avaliable recipes
help:
    @just --list --unsorted

# Create a zip file for given title
zip title:
	zip --junk-paths zip/{{title}}.zip dtbook/{{title}}/{{title}}.xml  css/sbs.css

# Build eBraille for given title
build title:
	{{DP2}} dtbook-to-ebraille --source {{title}}.xml --data dtbook/{{title}}/{{title}}.zip --epub-package true --braille-code {{BRAILLE_CODE}} --include-original-text true --validation off --output ebraille
# Filter contraction hints of given xml
filter xml:
	java -jar /usr/share/java/Saxon-HE.jar -xsl:/home/eglic/src/dp2/resources/xslt/filterBrlContractionhints.xsl -s:{{ without_extension(xml) }}.original.{{ extension(xml) }} > _filtered.


