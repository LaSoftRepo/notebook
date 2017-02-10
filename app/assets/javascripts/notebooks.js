// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).on('turbolinks:load', function() {
  $('.collapse-button').on('click', function(e) {
    children = $(e.currentTarget).children('svg');
    $(children[0]).toggle()
    $(children[1]).toggle()
  });
});
