# encoding: utf-8
module Asrv
  class PartnerFirm < Trst::PartnerFirm

    embeds_many :addresses,   class_name: "Asrv::PartnerFirm::Address", cascade_callbacks: true
    embeds_many :people,      class_name: "Asrv::PartnerFirm::Person",  cascade_callbacks: true
    embeds_many :banks,       class_name: "Asrv::PartnerFirm::Bank",    cascade_callbacks: true
    embeds_many :units,       class_name: "Asrv::PartnerFirm::Unit",    cascade_callbacks: true
    has_many    :dlns_client, class_name: "Asrv::DeliveryNote",         inverse_of: :client
    has_many    :grns_supplr, class_name: "Asrv::Grn",                  inverse_of: :supplr
    has_many    :invs_client, class_name: "Asrv::Invoice",              inverse_of: :client

    class << self
      # @todo
      def auto_search(params)
        if params[:w]
          default_sort.where(params[:w].to_sym => true)
          .and(name: /\A#{params[:q]}/i)
          .each_with_object([]){|pf,a| a << {id: pf.id.to_s,text: "#{pf.name[0][0..20]}"}}
        elsif params[:id]
          find(params[:id]).people.asc(:name_last).each_with_object([]){|d,a| a << {id: d.id.to_s,text: "#{d.name[0..20]}"}}.push({id: 'new',text: 'Adăugare delegat'})
        else
          default_sort.only(:id,:name,:identities)
          .or(name: /\A#{params[:q]}/i)
          .or(:'identities.fiscal' => /\A#{params[:q]}/i)
          .each_with_object([]){|pf,a| a << {id: pf.id.to_s,text: "#{pf.identities['fiscal'].ljust(18)} #{pf.name[1]}"}}
        end
      end
    end # Class methods
  end # PartnerFirm

  class PartnerFirm::Address < Trst::Address

    field :name,    type: String,   default: 'Main Address'

    embedded_in :firm,          class_name: 'Asrv::PartnerFirm',        inverse_of: :addresses

  end # FirmAddress
  PartnerFirmAddress = PartnerFirm::Address

  class PartnerFirm::Person < Trst::Person

    field :role,    type: String

    embedded_in :firm,          class_name: 'Asrv::PartnerFirm',        inverse_of: :people
    has_many    :dlns_client,   class_name: 'Asrv::DeliveryNote',       inverse_of: :client_d
    has_many    :grns_supplr,   class_name: 'Asrv::Grn',                inverse_of: :supplr_d
    has_many    :invs_client,   class_name: 'Asrv::Invoice',            inverse_of: :client_d

  end # FirmPerson
  PartnerFirmPerson = PartnerFirm::Person

  class PartnerFirm::Bank < Trst::Bank

    embedded_in :firm,          class_name: 'Asrv::PartnerFirm',        inverse_of: :banks

  end # FirmBank
  PartnerFirmBank = PartnerFirm::Bank

  class PartnerFirm::Unit < Trst::Unit

    embedded_in :firm,          class_name: 'Asrv::PartnerFirm',        inverse_of: :units
    has_many    :users,         class_name: 'Asrv::User',               inverse_of: :unit
    has_many    :dps,           class_name: 'Asrv::Cache',              inverse_of: :unit
    has_many    :stks,          class_name: 'Asrv::Stock',              inverse_of: :unit
    has_many    :dlns,          class_name: 'Asrv::DeliveryNote',       inverse_of: :unit
    has_many    :grns,          class_name: 'Asrv::Grn',                inverse_of: :unit
    has_many    :csss,          class_name: 'Asrv::Cassation',          inverse_of: :unit
    has_many    :cons,          class_name: 'Asrv::Consumption',        inverse_of: :unit
    has_many    :ins,           class_name: 'Asrv::FreightIn',          inverse_of: :unit
    has_many    :outs,          class_name: 'Asrv::FreightOut',         inverse_of: :unit
    has_many    :fsts,          class_name: 'Asrv::FreightStock',       inverse_of: :unit

    # @todo
    def stock_now
      stks.find_by(id_date: Date.new(2000,1,31))
    end
    # @todo
    def stock_monthly(y,m)
      if m == 12
        y,m = y + 1, 1
      else
        m = m + 1
      end
      stks.find_by(id_date: Date.new(y,m,1))
    end
    # @todo
    def stock_create(y,m)
      stk_new = stks.create(
        id_date: Date.new(y,m,1),
        name: "Stock_#{slug}_#{I18n.localize(Date.new(y,m,1), format: '%Y-%m')}",
        expl: "Stoc initial #{I18n.localize(Date.new(y,m,1), format: '%B, %Y').downcase}"
      )
      self.stock_now.freights.where(:qu.ne => 0).each{|f| stk_new.freights << f.clone}
      stk_new.freights.each{|f| f.set(:id_date,stk_new.id_date)}
      stk_new
    end
  end # FirmUnit
  PartnerFirmUnit = PartnerFirm::Unit

end # Wstm
