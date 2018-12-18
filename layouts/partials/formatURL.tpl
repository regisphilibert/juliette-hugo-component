{{- $params := dict -}}
{{- $slug := "" -}}
{{- $site := .page.Site -}}
{{- $isServer := false -}}
{{- $page := .page -}}
{{- $append := false -}}
{{- with .page.Param "juliette.slug" -}}
	{{- if not $isServer -}}
		{{- $slug = . -}}
	{{- end -}}
{{- end -}}

{{- $url := .url -}}
{{- with $.url -}}
	{{- $urlObject := urls.Parse . -}}
	{{- $url = replace (. | absURL) $urlObject.Path (printf "/%s%s" $slug $urlObject.Path) -}}
{{- end -}}
{{- with .pagination -}}
	{{- $append = "index.json" -}}
	{{- with $.page.Param "juliette.paginate_append" -}}
		{{- $append = .}}
	{{- end -}}
	{{- $url = $append | add $url -}}
{{- end -}}
{{- $url | absURL | safeURL -}}