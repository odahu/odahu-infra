{{/* vim: set filetype=mustache: */}}

{{/* Expand the name of the chart */}}
{{- define "knative-operator.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "knative-operator.fullname" -}}
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

{{/* Create chart name and version as used by the chart label. */}}
{{- define "knative-operator.chartref" -}}
{{- replace "+" "_" .Chart.Version | printf "%s-%s" .Chart.Name -}}
{{- end }}

{{/* Generate basic labels */}}
{{- define "knative-operator.labels" }}
chart: {{ template "knative-operator.chartref" . }}
release: {{ $.Release.Name | quote }}
heritage: {{ $.Release.Service | quote }}
{{- if .Values.commonLabels}}
{{ toYaml .Values.commonLabels }}
{{- end }}
{{- end }}

{{/* Create the name of knative-operator service account to use */}}
{{- define "knative-operator.serviceAccountName" -}}
{{- if .Values.knativeOperator.serviceAccount.create -}}
  {{ default (include "knative-operator.fullname" .) .Values.knativeOperator.serviceAccount.name }}
{{- else -}}
  {{ default "default" .Values.knativeOperator.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/* Allow the release namespace to be overridden for multi-namespace deployments in combined charts */}}
{{- define "knative-operator.namespace" -}}
  {{- if .Values.namespaceOverride -}}
    {{- .Values.namespaceOverride -}}
  {{- else -}}
    {{- .Release.Namespace -}}
  {{- end -}}
{{- end -}}

{{/* Override the namespace for Knative Serving components */}}
{{- define "knative-serving.namespace" -}}
  {{- if .Values.knative.serving.namespaceOverride -}}
    {{- .Values.knative.serving.namespaceOverride -}}
  {{- else -}}
    {{- include "knative-operator.namespace" . -}}
  {{- end -}}
{{- end -}}

{{/* Override the namespace for Knative Eventing components */}}
{{- define "knative-eventing.namespace" -}}
  {{- if .Values.knative.eventing.namespaceOverride -}}
    {{- .Values.knative.eventing.namespaceOverride -}}
  {{- else -}}
    {{- include "knative-operator.namespace" . -}}
  {{- end -}}
{{- end -}}
