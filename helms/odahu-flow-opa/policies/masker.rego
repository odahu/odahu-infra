package system.log

mask[{"op": "upsert", "path": "/input/attributes/request/http/headers/x-jwt", "value": x}] {
  x := "**REDACTED**"
}

mask[{"op": "upsert", "path": "/input/attributes/request/http/headers/cookie", "value": x}] {
  x := "**REDACTED**"
}

mask[{"op": "upsert", "path": "/input/attributes/request/http/headers/authorization", "value": x}] {
  x := "**REDACTED**"
}
