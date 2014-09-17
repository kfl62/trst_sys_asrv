# encoding: utf-8
module Asrv
  class Cache < Trst::Cache

    field :id_intern,         type: Boolean,                            default: false
    field :expl,              type: String,                             default: ''

    belongs_to  :unit,        class_name: 'Asrv::PartnerFirm::Unit',    inverse_of: :dps, index: true

    index({ unit_id: 1, id_date: 1 })

    class << self
    end # Class methods

  end # Cache
end # Asrv
