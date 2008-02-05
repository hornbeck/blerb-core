// This file is automatically included by javascript_include_tag :defaults
$(document).ready(function(){
	$(".delete").click(function(){
		$.ajax({
      type: "POST",
      data: {_method: "delete"},
      url: "/"+this.href.replace(/http:\/\/.+?\//,""),
      dataType: "script",
      beforeSend: function(xhr){ confirm("are you sure?");}
  	});return false;
	});
	$(".update").click(function(){
	  $.ajax({
	      type: "POST",
	      data: {_method: "put"},
	      url: "/"+this.href.replace(/http:\/\/.+?\//,""),
	      dataType: "script"
	  });return false;
	});
	$(".wymeditor").each(function(){ $(this).wymeditor();});
});