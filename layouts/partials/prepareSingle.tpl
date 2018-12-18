{{- partial "getTransformer.tpl" . -}}
{{- .Scratch.SetInMap "output" "data" (.Scratch.Get "item") -}}
{{- .Scratch.Delete "item" -}}