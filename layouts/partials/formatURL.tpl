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

{{- $url | absURL | safeURL -}}