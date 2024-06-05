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

 