package odahu.core

import data.odahu.mapper.parsed_input
import data.odahu.permissions.permissions

default allow = false

allow {
	any_user_role := parsed_input.user.roles[_]
    any_permission_of_user_role := permissions[any_user_role][_]
    action := any_permission_of_user_role[0]
    resource := any_permission_of_user_role[1]

    re_match(action, parsed_input.action)
    re_match(resource, parsed_input.resource)
}

allow {
	parsed_input.action == "GET"
  parsed_input.resource == "/"
}

allow {
	parsed_input.action == "GET"
  re_match("/swagger*", parsed_input.resource)
}
