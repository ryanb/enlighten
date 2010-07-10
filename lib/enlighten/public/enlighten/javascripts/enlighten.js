$(function() {
  $("#console").submit(function() {
    $.post(this.action, $(this).serialize(), function(result) {
      $("#prompt_section").before("<div>&gt;&gt; " + $("#prompt").val() + "<br />" + "=&gt; " + result + "</div>");
      $("#prompt").val("");
    });
    return false;
  });
})
