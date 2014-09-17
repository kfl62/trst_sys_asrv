# encoding: utf-8
module Asrv
  class User < Trst::User

    belongs_to    :unit,   class_name: 'Asrv::PartnerFirmUnit',  inverse_of: :users
    has_many      :dlns,   class_name: 'Asrv::DeliveryNote',     inverse_of: :signed_by
    has_many      :grns,   class_name: 'Asrv::Grn',              inverse_of: :signed_by
    has_many      :csss,   class_name: 'Asrv::Cassation',        inverse_of: :signed_by
    has_many      :invs,   class_name: 'Asrv::Invoice',          inverse_of: :signed_by
    embeds_many   :logins, class_name: 'Asrv::UserLogin'

    scope :by_unit_id, ->(unit_id) {where(unit_id: unit_id)}

    class << self
    end # Class methods

    # @todo
    def login(ip = '')
      l = logins.find_or_create_by(id_date: Date.today)
      l.push(:login,Time.now)
      l.set(:ip,ip)
    end
    # @todo
    def logout
      l = logins.find_or_create_by(id_date: Date.today)
      l.push(:logout,Time.now) if l.login.length > l.logout.length
    end
    # @todo
    def unit
      Asrv::PartnerFirm.unit_by_unit_id(unit_id) rescue nil
    end
  end # User

  class UserLogin
    include Mongoid::Document
    include Mongoid::Timestamps
    include Trst::DateHelpers

    field :id_date, type: Date,     default: -> {Date.today}
    field :login,   type: Array,    default: []
    field :logout,  type: Array,    default: []

    embedded_in   :user,  class_name: 'Asrv::User'
 end # UserLogin

end # Asrv
