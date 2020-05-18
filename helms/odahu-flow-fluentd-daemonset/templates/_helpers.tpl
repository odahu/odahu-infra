{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "odahu-flow-fluentd-daemonset.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "fluentd-daemonset.application-version" -}}
{{ default .Chart.AppVersion .Values.fluentdVersion }}
{{- end -}}

{{- define "fluentd-daemonset.helm-labels-for-search" -}}
app.kubernetes.io/component: {{ .component | quote }}
app: {{ .component | quote }}
app.kubernetes.io/instance: {{ .root.Release.Name | quote }}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "odahu-flow-fluentd-daemonset.fullname" -}}
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

{{- define "fluentd-daemonset.helm-labels" -}}
app.kubernetes.io/component: {{ .component | quote }}
app.kubernetes.io/version: "{{ include "fluentd-daemonset.application-version" .root }}"
app: {{ .component | quote }}
version: "{{ include "fluentd-daemonset.application-version" .root }}"
app.kubernetes.io/instance: {{ .root.Release.Name | quote }}
app.kubernetes.io/managed-by: {{ .root.Release.Service | quote }}
app.kubernetes.io/name: "fluentd-daemonset"
helm.sh/chart: "{{ .root.Chart.Name }}-{{ .root.Chart.Version }}"
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "odahu-flow-fluentd-daemonset.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "odahu-flow-fluentd-daemonset.labels" -}}
helm.sh/chart: {{ include "odahu-flow-fluentd-daemonset.chart" . }}
{{ include "odahu-flow-fluentd-daemonset.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "odahu-flow-fluentd-daemonset.selectorLabels" -}}
app.kubernetes.io/name: {{ include "odahu-flow-fluentd-daemonset.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "odahu-flow-fluentd-daemonset.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "odahu-flow-fluentd-daemonset.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}
{{- define "fluentd.default-image-name" -}}
{{ printf .tpl .root.Values.imagesRegistry (include "fluentd-daemonset.application-version" .root) }}
{{- end -}}
{{- define "fluentd.image-name" -}}
{{- if .service }}
{{- if (hasKey .service "image") }}
{{ .service.image  }}
{{- else -}}
{{- include "fluentd.default-image-name" . -}}
{{ end }}
{{- else }}
{{- include "fluentd.default-image-name" . -}}
{{ end }}
{{- end -}}

