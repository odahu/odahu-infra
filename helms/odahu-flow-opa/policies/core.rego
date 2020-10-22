package odahu.core

import data.odahu.mapper.parsed_input
import data.odahu.mapper
import data.odahu.permissions.permissions

default allow = false

# Static role based policy
allow {
  any_user_role := parsed_input.user.roles[_]
  any_permission_of_user_role := permissions[any_user_role][_]
  action := any_permission_of_user_role[0]
  resource := any_permission_of_user_role[1]

  re_match(action, parsed_input.action)
  re_match(resource, parsed_input.resource)
}

# Dynamic role based policy
allow {
  some i
  mapper.required_role == mapper.raw_roles[i]
}

# Website is not protected
allow {
  parsed_input.action == "GET"
  parsed_input.resource == "/"
}

# Swagger are not protected
allow {
  parsed_input.action == "GET"
  re_match("/swagger*", parsed_input.resource)
}

# These endpoints are invoked for model pod port 8012 (queue-proxy)
# by not authenticated pods "Activator" and "Autoscaler"
allow {
  parsed_input.action == "GET"
  parsed_input.resource == "/healthz"
}

allow {
  parsed_input.action == "GET"
  parsed_input.resource == "/metrics"
}
