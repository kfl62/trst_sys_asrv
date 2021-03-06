define () ->
  $.extend true,Asrv,
    desk:
      partner_firm:
        updateDocAry: (inpts)->
          inpts.filter(':checked').each ()->
            Asrv.desk.partner_firm.doc_ary.push(@id)
          inpts.filter('.param').val(@doc_ary)
          $params = jQuery.param($('.param').serializeArray())
          $url = "/sys/asrv/partner_firm/query?#{$params}"
          Trst.desk.init($url)
          return
        inputs: (inpts)->
          inpts.filter(':checkbox').on 'change', ()->
            Asrv.desk.partner_firm.updateDocAry(inpts)
        selects: (slcts)->
          slcts.each ()->
            $select = $(@)
            $sd = $select.data()
            $id = $select.attr('id')
            if $select.hasClass 'select2'
              $ph = Trst.i18n.select[Trst.desk.hdo.js_ext][$sd.ph]
              $select.select2
                placeholder: $ph
                minimumInputLength: $sd.minlength
                allowClear: true
                ajax:
                  url: "/utils/search/#{$sd.search}"
                  dataType: 'json'
                  quietMillis: 100
                  data: (term)->
                    q: term
                  results: (data)->
                    results: data
              $select.unbind()
              $select.on 'change', ()->
                Trst.desk.hdo.oid = if $select.select2('val') is '' then null else $select.select2('val')
                return
            else
              $select.on 'change', ()->
                $('.param.doc_ary').val('') if $(@).hasClass('firm')
                $params = jQuery.param($('.param').serializeArray())
                $url = "/sys/asrv/partner_firm/query?#{$params}"
                Trst.desk.init($url)
          return
        buttons: (btns)->
          btns.each ()->
            $button = $(@)
            $bd = $button.data()
            $id = $button.attr('id')
            if $bd.action is 'print'
              $button.on 'click', ()->
                Trst.msgShow Trst.i18n.msg.report.start
                $url  = "/sys/asrv/report/print?rb=yearly_stats"
                $url += "&fn=#{$bd.fn}" if $bd.fn
                $url += "&uid=#{$bd.uid}" if $bd.uid
                $.fileDownload $url,
                  successCallback: ()->
                    Trst.msgHide()
                  failCallback: ()->
                    Trst.msgHide()
                    Trst.desk.downloadError Trst.desk.hdo.model_name
                false
            else if $bd.action is 'toggle_checkbox'
              $button.on 'click', ()->
                if $('input.param.doc_ary').val().split(',')[0] is "" or $('input.param.doc_ary').val().split(',').length < $('input:checkbox').length
                  $('input:checkbox').each ()->
                    Asrv.desk.partner_firm.doc_ary.push(@id)
                else
                  Asrv.desk.partner_firm.doc_ary = []
                $('input.param.doc_ary').val(Asrv.desk.partner_firm.doc_ary)
                $params = jQuery.param($('.param').serializeArray())
                $url = "/sys/asrv/partner_firm/query?#{$params}"
                Trst.desk.init($url)
                return
              return
          return
        init: ()->
          @doc_ary = []
          Asrv.desk.partner_firm.buttons($('button'))
          Asrv.desk.partner_firm.selects($('select.param,input.select2'))
          Asrv.desk.partner_firm.inputs($('input.doc_ary'))
          $log 'Asrv.desk.partner_firm.init() OK...'
  Asrv.desk.partner_firm
