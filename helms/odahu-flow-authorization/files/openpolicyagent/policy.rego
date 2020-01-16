package odahu

# roles.rego

admin := "admin"
data_scientist := "data_scientist"

# rbac.rego

rbac := {
	data_scientist: [
    	["*", "api/v1/model/deployment.*"],
    	["*", "api/v1/model/packaging.*"],
    	["*", "api/v1/model/training.*"],
    	["GET", "api/v1/connection.*"],
    	["POST", "api/v1/connection.*"],
    	["GET", "api/v1/packaging/integration.*"],
    	["GET", "api/v1/toolchain/integration.*"]
    ],
  admin : [
      [".*", ".*"]
  ]
}

# input_mapper

roles_map = {
	"odahu_admin": admin,
    "odahu_data_scientist": data_scientist
}

jwt = input.attributes.metadata_context.filter_metadata["envoy.filters.http.jwt_authn"].fields.jwt_payload

keycloak_user_roles[role]{
	role = jwt.Kind.StructValue.fields.realm_access.Kind.StructValue.fields.roles.Kind.ListValue.values[_].Kind.StringValue
}

user_roles[role]{
	role = roles_map[keycloak_user_roles[_]]
}


parsed_input = {
	"action": input.attributes.request.http.method,
    "resource": input.attributes.request.http.path,
    "user": {
    	"roles": user_roles
    }
}


# core

default allow = false
allow {
	any_user_role := parsed_input.user.roles[_]
    any_permission_of_user_role := rbac[any_user_role][_]
    action := any_permission_of_user_role[0]
    resource := any_permission_of_user_role[1]

    re_match(action, parsed_input.action)
    re_match(resource, parsed_input.resource)
}


