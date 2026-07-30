module LicenseEngine
  module ApplicationHelper
    def actor_label(actor)
      return "—" if actor.nil?
      "#{actor.external_type}##{actor.external_id}"
    end
  end
end
