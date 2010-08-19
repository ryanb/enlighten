$(function() {
  $("#console").submit(function() {
    $.post(this.action, $(this).serialize(), function(result) {
      $("#prompt_section").before("<pre>&gt;&gt; " + $("#prompt").val() + "<br />" + "=&gt; " + result + "</pre>");
      $("#prompt").val("");
    });
    return false;
  });
})
