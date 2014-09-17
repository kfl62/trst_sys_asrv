# encoding: utf-8
module Asrv
  class CacheBook < Trst::CacheBook

    embeds_many :lines,       class_name: 'Asrv::CacheBook::Line',      cascade_callbacks: true

  end # CacheBook

  class CacheBook::Line < Trst::CacheBookLine

    embedded_in :cb,          class_name: 'Asrv::CacheBook',            inverse_of: :lines

  end # CacheBookIn
end #Asrv
