{{- $params := dict -}}
{{- $slug := "" -}}
{{- $site := .page.Site -}}
{{- $page := .page -}}
{{- $isServer := $site.IsServer -}}
{{- $append := false -}}
{{- with .page.Param "juliette.slug" -}}
	{{- if not $isServer -}}
		{{- $slug = . -}}
	{{- end -}}
{{- end -}}

{{- $url := .url -}}
{{- with $.url -}}
	{{- $urlObject := urls.Parse . -}}
	{{- $url = replace (. | absURL) $urlObject.Path (printf (cond (ne $slug "") "/%s%s" "%s%s") $slug $urlObject.Path) -}}
{{- end -}}
{{- with .pagination -}}
	{{- $append = "index.json" -}}
	{{- with $page.Param "juliette.pagination_append" -}}
		{{- $append = .}}
	{{- end -}}
	{{- $url = $append | add $url -}}
{{- end -}}
{{- $url | absURL | safeURL -}}

