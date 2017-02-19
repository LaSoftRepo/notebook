$(document).on('turbolinks:load', function() {
  if (!$('#sections-index')[0]) return;

  $('.collapse-button').on('click', function(e) {
    children = $(e.currentTarget).children('svg');
    $(children[0]).toggle()
    $(children[1]).toggle()
  });
});
