# frozen_string_literal: true

require 'roda'

module PermitParams
  module InstanceMethods
    def permit_params(params, allowed_keys)
      params.slice(*allowed_keys)
    end
  end
end

Roda::RodaPlugins.register_plugin(:permit_params, PermitParams)
