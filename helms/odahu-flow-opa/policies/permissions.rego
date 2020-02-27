package odahu.permissions

import data.odahu.roles

permissions := {
	roles.data_scientist: [
    	[".*", "api/v1/model/deployment.*"],
    	[".*", "api/v1/model/packaging.*"],
    	[".*", "api/v1/model/training.*"],
    	["GET", "api/v1/configuration.*"],
    	["GET", "api/v1/connection.*"],
    	["GET", "api/v1/packaging/integration.*"],
    	["GET", "api/v1/toolchain/integration.*"]
    ],
  roles.admin : [
      [".*", ".*"]
  ],
  roles.viewer : [
      ["GET", ".*"]
  ]
}