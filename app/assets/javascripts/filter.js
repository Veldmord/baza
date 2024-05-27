$(document).ready(function() {
    $('#filter-form').submit(function(event) {
      event.preventDefault();
      $.ajax({
        type: 'GET',
        url: '/temps/show_table',
        data: $(this).serialize(),
        dataType: 'script'
      });
    });
  });

 /* $(document).ready(function() {
    $('#okpd').autocomplete({
      source: function(request, response) {
        $.ajax({
          url: '<%= auto_complete_okpd_temps_path %>',
          data: { term: request.term },
          dataType: 'json',
          success: function(data) {
            response(data);
          }
        });
      },
      select: function(event, ui) {
        $(this).val(ui.item.value);
        return false;
      }
    });
  });*/