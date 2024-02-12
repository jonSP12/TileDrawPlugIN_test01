@tool
extends Sprite2D


@onready var subVcont = get_node_or_null("../..");
@onready var label2 = get_node_or_null("../../../Label2");

var Mimg: int = 0;
var mGx;
var mGy;
var mG;
var mouseIN = false;

var selectRect = Rect2(16, 16, 32, 32 );
var mouse_tex;



func MouseOnMe():
	if (  ( mGx >= position.x+16 && mGx <= texture.get_width()) &&  ( mGy >= position.y+16 && mGy <= texture.get_height())         ):
		Mimg = 1;
	else:
		Mimg = 0;



func _ready():
	set_process_input(true)
	
	var tempSelectRect2 = Rect2(0, 0, 32, 32 );
	mouse_tex = ImageTexture.create_from_image(texture.get_image().get_region( tempSelectRect2 ) );
	
	
	
	pass 



func _process(delta):
	
	mGx = snapped( get_local_mouse_position().x, 32 );
	mGy = snapped( get_local_mouse_position().y, 32 );
	mG = Vector2(mGx, mGy);
	var sVp = subVcont.position;
	var sVs = subVcont.size;
	var sVendR = sVp.x + sVs.x;
	var sVendB = sVp.y + sVs.y;
	
	MouseOnMe();
	if ( label2 != null ):
		if ( Mimg == 1 && mouseIN == true ):
			label2.text = "IMG: " + str( mGx ) + str(",") + str( mGy );
			pass;
		else:
			label2.text = "IMG: ";
			pass;
	
	
	
	queue_redraw();
	




func _draw():
	
	var icX = position.x+16;
	var icY = position.y+16;
	
	var grid1W = texture.get_width()+16;
	var grid1H = texture.get_height()+16;
	
	var rX = grid1W/32+1;
	var rY = grid1H/32+1;
	
	#-grid---
	for i in range( rY ): # Rows
		var ia = i*32;
		draw_line(Vector2( icX , icY+ia ), Vector2( grid1W, icY+ia ), Color(1, 1, 1, 0.5 ) , 1, false  ); #horizontal
	for i in range( rX ): # Columns
		var ia = i*32;
		draw_line(Vector2( icX+ia , icY ), Vector2( icX+ia, grid1H ), Color(1, 1, 1, 0.5 ) , 1, false  ); #horizontal
	
	if ( Mimg == 1 ):
		draw_rect(Rect2(mG.x-16, mG.y-16, 32, 32 ), Color.YELLOW, false, 1 );
		
	
	draw_rect( selectRect, Color.YELLOW, false, 2 );
	
	
	#draw_texture( mouse_tex, Vector2(200, 100) );
	



func _on_sub_viewport_container_mouse_entered():
	mouseIN = true;


func _on_sub_viewport_container_mouse_exited():
	mouseIN = false;
