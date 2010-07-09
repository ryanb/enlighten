$(document).ready(function() {
  $("#console").submit(function() {
    $.post(this.action, $(this).serialize(), function(result) {
      alert(result);
    });
    return false;
  });
})
