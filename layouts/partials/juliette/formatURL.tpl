{{- $params := dict -}}
{{- $slug := "" -}}
{{- $beautify := false -}}
{{- $site := .page.Site -}}
{{- $page := .page -}}
{{- $isServer := false -}}

{{- $append := false -}}
{{- if not $isServer -}}
	{{- with .page.Param "juliette.slug" -}}
		{{- $slug = . -}}
	{{- end -}}
	{{- with .page.Param "juliette.beautify" -}}
		{{- $beautify = true -}}
	{{- end -}}
{{- end -}}

{{- $url := .url -}}
{{- with .pagination -}}
	{{- $append = "index.json" -}}
	{{- with $page.Param "juliette.pagination_append" -}}
		{{- $append = .}}
	{{- end -}}
	{{- $url = $append | add $url -}}
{{- end -}}

{{- with $slug -}}
	{{- $urlObject := urls.Parse $url -}}
	{{- $url = replace ($url | absURL) $urlObject.Path (printf (cond (ne $slug "") "/%s%s" "%s%s") $slug $urlObject.Path) -}}
{{- end -}}
{{- with $beautify -}}
	{{- $url = strings.TrimRight "index.json" $url -}}
{{- end -}}
{{- $url | absURL | safeURL -}}