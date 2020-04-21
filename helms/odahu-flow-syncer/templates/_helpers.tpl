{{/* vim: set filetype=mustache: */}}

{{/*
----------- VERSIONING -----------
*/}}

{{- define "syncer.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "syncer.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

    - . - root HELM scope
*/}}
{{- define "syncer.application-version" -}}
{{ default .Chart.AppVersion .Values.syncerVersion }}
{{- end -}}


{{/*
Function builds default labels for all components
It section uses "syncer.application-version"
Arguments:
    - . - root HELM scope
*/}}
{{- define "syncer.helm-labels" -}}
app.kubernetes.io/component: {{ .component | quote }}
app.kubernetes.io/version: "{{ include "syncer.application-version" .root }}"
app: {{ .component | quote }}
version: "{{ include "syncer.application-version" .root }}"
app.kubernetes.io/instance: {{ .root.Release.Name | quote }}
app.kubernetes.io/managed-by: {{ .root.Release.Service | quote }}
app.kubernetes.io/name: "syncer"
helm.sh/chart: "{{ .root.Chart.Name }}-{{ .root.Chart.Version }}"
{{- end -}}

{{/*
Function builds additional search labels
Arguments:
    - . - root HELM scope
*/}}
{{- define "syncer.helm-labels-for-search" -}}
app.kubernetes.io/component: {{ .component | quote }}
app: {{ .component | quote }}
app.kubernetes.io/instance: {{ .root.Release.Name | quote }}
{{- end -}}
