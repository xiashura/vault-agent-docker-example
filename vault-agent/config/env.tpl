{{ with secret "kv/data/secrets/static" -}}
{ 
  "user": "{{ .Data.data.user }}",
  "id": {{ .Data.data.id }},
  "password": "{{ .Data.data.password }}"
}
{{- end }}