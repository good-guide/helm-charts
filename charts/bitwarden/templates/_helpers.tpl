{{/*
Expand the name of the chart.
*/}}
{{- define "bitwarden.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "bitwarden.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "bitwarden.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "bitwarden.labels" -}}
helm.sh/chart: {{ include "bitwarden.chart" . }}
{{ include "bitwarden.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "bitwarden.selectorLabels" -}}
app.kubernetes.io/name: {{ include "bitwarden.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "bitwarden.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "bitwarden.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Prepare bitwarden config
*/}}
{{- define "bitwarden.config" -}}
{{- range $key, $value := .Values.config }}
{{ $key | lower }}: {{ $value }}
{{- end }}
{{- end }}

{{- define "bitwarden.secrets" -}}
{{- if .Values.envSecretName }}
{{-  .Values.envSecretName  }}
{{- else }}
{{-  include "bitwarden.fullname" .  }}
{{- end }}
{{- end }}
