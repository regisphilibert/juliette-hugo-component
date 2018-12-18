{{- $partial := printf "transformers/%s.tpl" .Type -}}
{{- if templates.Exists (printf "partials/%s" $partial) -}}
	{{- partial $partial . -}}
{{- else -}}
	{{- partial "transformers/default.tpl" . -}}
{{- end -}}
