$(function() {
  $("#prompt form").submit(function() {
    $.post(this.action, $(this).serialize(), function(result) {
      $("#prompt_section").before("<pre>&gt;&gt; " + $("#prompt_field").val() + "\n" + "<span class='response'>=&gt; " + result + "</span></pre>");
      $("#prompt_field").val("");
    });
    return false;
  });
})
