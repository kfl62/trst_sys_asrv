# encoding: utf-8
module Asrv
  class Payment < Trst::Payment

    belongs_to :doc_inv,      class_name: "Asrv::Invoice",              inverse_of: :pyms

    class << self
    end # Class methods

  end # Payment
end # Asrv
