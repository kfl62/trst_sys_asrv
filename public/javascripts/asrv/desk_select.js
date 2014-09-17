(function() {
  define(function() {
    $.extend(true, Asrv, {
      desk: {
        select: {
          unit: function(node) {
            var $select;
            $select = node;
            $select.change(function() {
              var $dialog, $model;
              if ($select.val() === 'null') {
                Asrv.unit_info.update();
              } else {
                Asrv.unit_info.update($select.find('option:selected').text());
              }
              $model = Trst.desk.hdo.js_ext.split(/_(.+)/)[1];
              $dialog = Trst.desk.hdo.dialog;
              Trst.desk.init("/utils/units/asrv/" + $model + "/" + $dialog + "/" + ($select.val()));
            });
          },
          select2: function(node) {
            var $sd, $select;
            $select = node;
            $sd = $select.data();
            $.extend(true, $.fn.select2.defaults, {
              formatInputTooShort: function(input, min) {
                return Asrv.desk.select.inputTooShortMsg(input, min);
              },
              formatSearching: function() {
                return Trst.i18n.msg.searching;
              },
              formatNoMatches: function(term) {
                return Trst.i18n.msg.no_matches;
              }
            });
          },
          inputTooShortMsg: function(input, min) {
            var $msg;
            if (input.length === 0) {
              $msg = Trst.i18n.msg.input_too_short_strt.replace('%{nr}', min - input.length);
            }
            if (input.length !== 0) {
              $msg = Trst.i18n.msg.input_too_short_more.replace('%{nr}', min - input.length);
            }
            if ((min - input.length) === 1) {
              $msg = Trst.i18n.msg.input_too_short_last;
            }
            return $msg;
          },
          init: function() {
            $('select.asrv, input.select2').each(function() {
              var $select;
              $select = $(this);
              if ($select.hasClass('select2')) {
                Asrv.desk.select.select2($select);
              } else if ($select.hasClass('unit')) {
                Asrv.desk.select.unit($select);
              } else if ($select.hasClass('freight') || $select.hasClass('y') || $select.hasClass('m') || $select.hasClass('p03')) {

                /*
                Handled by Asrv.desk.expenditure|delivery_note...
                 */
              } else {
                $log('Unknown class for select...');
              }
            });
            return $log('Asrv.select.init() OK...');
          }
        }
      }
    });
    return Asrv.desk.select;
  });

}).call(this);
