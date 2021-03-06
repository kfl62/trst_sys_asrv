# encoding: utf-8
module Asrv
  class FreightStock < Trst::FreightStock

    belongs_to  :freight,     class_name: 'Asrv::Freight',              inverse_of: :stks, index: true
    belongs_to  :unit,        class_name: 'Asrv::PartnerFirm::Unit',    inverse_of: :fsts, index: true
    belongs_to  :doc_stk,     class_name: 'Asrv::Stock',                inverse_of: :freights, index: true

    alias :unit :unit_belongs_to; alias :name :freight_name; alias :um :freight_um

    index({ freight_id: 1, id_date: 1, unit_id: 1 })

    before_save   :handle_freights_unit_id
    after_update  :handle_value

    class << self
    end # Class methods

    # @todo
    def view_filter
      [id, freight.name]
    end
    # @todo
    def doc
      doc_stk
    end
    protected
    # @todo
    def handle_freights_unit_id
      set(:unit_id,self.doc.unit_id)
    end
    # @todo
    def handle_value
      set :val, (pu * qu).round(2)
    end
  end # FreightStock
end # Asrv
