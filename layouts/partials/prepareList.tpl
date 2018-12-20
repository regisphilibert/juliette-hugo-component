{{- .Scratch.Set "items" slice -}}
{{- with (.Param "juliette.pagination") -}}
	{{- $pagi := $.Paginator . -}}
	{{- $.Scratch.Set "pages" $pagi.Pages -}}
	{{- $.Scratch.SetInMap "pagination" "page" $pagi.PageNumber -}}
	{{- $.Scratch.SetInMap "pagination" "pages" $pagi.TotalPages -}}
	{{- $.Scratch.SetInMap "pagination" "self" (partial "formatURL.tpl" (dict "pagination" true "page" $ "url" ($pagi.URL | absURL))) -}}
	{{- $.Scratch.SetInMap "pagination" "first" (partial "formatURL.tpl" (dict "pagination" true "page" $ "url" ($pagi.First.URL| absURL))) -}}
	{{- $.Scratch.SetInMap "pagination" "last" (partial "formatURL.tpl" (dict "pagination" true "page" $ "url" ($pagi.Last.URL | absURL))) -}}
	{{- if $pagi.HasNext -}}
	{{- $.Scratch.SetInMap "pagination" "next" (partial "formatURL.tpl" (dict "pagination" true "page" $ "url" ($pagi.Next.URL | absURL))) -}}
	{{- end -}}
	{{- if $pagi.HasPrev -}}
	{{- $.Scratch.SetInMap "pagination" "prev" (partial "formatURL.tpl" (dict "pagination" true "page" $ "url" ($pagi.Prev.URL | absURL))) -}}
	{{ end }}
	{{- $.Scratch.SetInMap "data" "pagination" ($.Scratch.Get "pagination") -}}
{{- else -}}
	{{- $.Scratch.Set "pages" .Pages -}}
{{- end -}}
{{- range (.Scratch.Get "pages") -}}
	{{ partial "getTransformer.tpl" . }}
	{{- $.Scratch.Add "items" (slice (.Scratch.Get "item")) -}}
{{- end -}}
{{- with eq .Kind "section" -}}
{{- $.Scratch.SetInMap "data" "section" $.Section -}}
{{- end -}}
{{- with eq .Kind "taxonomy" -}}
{{- $.Scratch.SetInMap "data" "taxonomy" $.Data.Singular -}}
{{- $.Scratch.SetInMap "data" "term" $.Data.Term -}}
{{- end -}}
{{- .Scratch.SetInMap "data" "count" (len .Pages) -}}
{{- .Scratch.SetInMap "data" "items" (.Scratch.Get "items") -}}
{{- .Scratch.SetInMap "output" "data" (.Scratch.Get "data") -}}