@tool
extends Node2D


@onready var mouse_tex2;


func _process(delta):
	queue_redraw();
	pass;


func _draw():
	if ( mouse_tex2 == null ):
		return;
	
	
	draw_texture(mouse_tex2, get_local_mouse_position() );
	pass;

