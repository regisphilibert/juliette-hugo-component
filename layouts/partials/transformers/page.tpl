{{- /* Each custom transformers can use "transformers/default" as a base of key/values */ -}}
{{- partial "transformers/default.tpl" . -}}
{{- /* Each subsequent extra field must be added to `.Scratch.SetInMap`:  */ -}}
{{- .Scratch.SetInMap "item" "menu" (default dict .Params.menu) -}}
