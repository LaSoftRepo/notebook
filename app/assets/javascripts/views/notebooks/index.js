$(document).on('turbolinks:load', function() {
  if (!$('#notebooks-index')[0]) return;
  enableModalFormValidation($("#new_notebook"));
});
