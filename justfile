DP2 := "/opt/daisy-pipeline2-cli/dp2"

# Display all avaliable recipes
help:
    @just --list --unsorted

# Build eBraille for given title
build title:
	{{DP2}} dtbook-to-ebraille --source {{title}}.xml --data dtbook/{{title}}/{{title}}.zip --epub-package true --include-original-text true --validation off --output ebraille

