// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require jquery.ui.draggable
//= require jquery.ui.droppable
//= require jquery.ui.resizable
//= require jquery.ui.selectable
//= require jquery.ui.sortable
//= require private_pub
//= require_tree .

$(document).on("mouseover", function(){
	$('.field>div').draggable({containment: '.desk', snap: ".field", snapMode: "inner" , cursor: "move", cursorAt: { top: 24, left: 24 } });
	$('.middle_top>div').draggable({containment: '.desk', snap: ".field", snapMode: "inner" , cursor: "move", cursorAt: { top: 24, left: 24 } });
	$('.middle_bottom>div').draggable({containment: '.desk', snap: ".field", snapMode: "inner" , cursor: "move", cursorAt: { top: 24, left: 24 } });

	// in game 
	$('.field').droppable({ drop: function(event, ui){
		var to = $(this).attr('id');
		var from = ui.draggable.attr("id");
		ui.draggable.attr("id", to);

		//ajax post request
		$.post("/desk/move", {id: $('#id_for_hidden').val(), from: from, to: to}, null, "script");
	}});

	//off game
	$('.game_sidebar>div').droppable({ drop: function(event, ui){
		var to = "off_game"
		var from = ui.draggable.attr("id");
		ui.draggable.attr("id", from+"_off_game");

		$.post("/desk/move", {id: $('#id_for_hidden').val(), from: from, to: to}, null, "script");
	}});
});
$(document).on("click", ".throw", function(){
	$.post("/desk/throw_d", {id: $('#id_for_hidden').val()}, null, "script");
});
$(document).on("click", ".skip", function(){
	$.post("/desk/skip_move", {id: $('#id_for_hidden').val()}, null, "script");
});

	

