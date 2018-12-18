{{- $s := newScratch -}}
{{- with .Title -}}
{{- $.Scratch.SetInMap "item" "title" . -}}	
{{- end -}}
{{- with .Date -}}
	{{- $.Scratch.SetInMap "item" "created" . -}}
{{- end -}}
{{- with .Params.lastMod -}}
{{- $.Scratch.SetInMap "item" "updated" . -}}
{{- end -}}
{{- $translations := slice -}}
{{- with .Translations -}}
	{{- range . -}}
		{{- $translations = $translations | append (dict "lang" .Lang "url" .Permalink) -}}
	{{- end -}}
{{- end -}}
{{- with $translations -}}
	{{- $.Scratch.SetInMap "item" "translations" . -}}
{{- end -}}
{{- $urls := slice -}}
{{- with .OutputFormats -}}
	{{- range . -}}
		{{- $output_url := .Permalink -}}
		{{- if ne .MediaType.Type "text/html" -}}
			{{- $output_url = partial "formatURL.tpl" (dict "page" $ "url" .Permalink) -}}
		{{- end -}}
		{{- $urls = $urls | append (dict "type" .MediaType.SubType "url" $output_url) -}}
	{{- end -}}
{{- end -}}
{{- with $urls -}}
	{{- $.Scratch.SetInMap "item" "endpoints" . -}}
{{- end -}}
{{- .Scratch.SetInMap "item" "type" .Type -}}
{{- .Scratch.SetInMap "item" "draft" (default false .Draft) -}}
{{- .Scratch.SetInMap "item" "permalink" .Permalink -}}
{{- .Scratch.SetInMap "item" "relpermalink" .RelPermalink -}}