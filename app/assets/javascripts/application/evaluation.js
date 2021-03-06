var evaluation = (function(Rx, $) {
  var module = {};

  module.init = function() {
    var input = document.querySelectorAll('.point-input');
    if (input != null) {
      var inputStream = Rx.Observable.fromEvent(input, 'change')
        .map(event => event.target);

      inputStream.subscribe(inputChange);
    }

    $('.principle').click(function() {
      principleModal($(this));
    });
  }

  function principleModal(principle) {
    var sumPoint = 0, table = '';

    $('.point-input[data-principle="' + principle.data('id') + '"]').each(function(){
      var value = $(this).val();
      if (value == 0) { return; }

      var userName = $(this).data('user-name');
      table += '<tr><td>' + userName + '</td><td>' + value + '</td></tr>';
      sumPoint += parseInt(value);
    });

    UIkit.modal.alert('<h2>' + principle.text() + '</h2><p>' + principle.data('description') + '</p><table class="uk-table uk-table-striped">' + table + '<tr><td><strong>Összeg</strong></td><td><strong>' + sumPoint + '</strong></td></tr></table>');
  }

  function inputChange(input) {
    $('#save-icon').fadeIn();
    var value = input.value;
    var principle = input.getAttribute('data-principle');
    var user = input.getAttribute('data-user');

    $.ajax({
      method: 'POST',
      url: updateURL,
      data: {
        principle_id: principle,
        user_id: user,
        point: value
      }
    }).done(function (resp) {
      $('#save-icon').fadeOut();
    }).error(function () {
      UIkit.notify({
        message: 'Hiba történt a mentés során! Ellenőrizd az internetkapcsolatod!',
        timeout: 10000,
        status: 'danger'
      });
      $('#save-icon').fadeOut();
    });
  }

  return module;
}(Rx, jQuery));

$(document).ready(evaluation.init);
