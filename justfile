DP2 := "/opt/daisy-pipeline2-cli/dp2"
BRAILLE_CODE := "'(liblouis-table:\"de-g2.ctb\")'"

# Display all avaliable recipes
help:
    @just --list --unsorted

# Build eBraille for given title
build title:
	{{DP2}} dtbook-to-ebraille --source {{title}}.xml --data dtbook/{{title}}/{{title}}.zip --epub-package true --braille-code {{BRAILLE_CODE}} --include-original-text true --validation off --output ebraille

