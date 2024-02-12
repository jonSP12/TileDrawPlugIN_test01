@tool
extends EditorPlugin



const editorAddon = preload("res://addons/tiletest/tilePlugTest.tscn");
const tileDrawNode = preload("res://addons/tiletest/tileDrawNode.gd");
const tileDrawIcon = preload("res://addons/tiletest/icon.png");
const editorDraw = preload("res://addons/tiletest/editor_draw.tscn");


var dockedCanvas;
var dockedEditorDraw;

var dockedScene;
var subVcont;
var subVport;
var label1;
var label2;
var camTl;


var img;
var Mimg: int = 0;
var MouseOnImage;
var blk;
var blk2;


var mouseGroup = {
	'Fnum': []
}

var canvasTex = {};



func _enter_tree():
	add_custom_type("TileDraw", "Node2D", tileDrawNode, tileDrawIcon );
	dockedScene = editorAddon.instantiate();
	add_control_to_container(CONTAINER_CANVAS_EDITOR_SIDE_RIGHT, dockedScene );
	dockedScene.custom_minimum_size = Vector2(10,0);
	
	dockedEditorDraw = editorDraw.instantiate();
	get_editor_interface().get_edited_scene_root().get_viewport().add_child(dockedEditorDraw)
	#add_child(dockededitorDraw)
	
	
	set_force_draw_over_forwarding_enabled()
	
	#if not is_instance_valid(dockedScene):
		#return;
	
	subVcont = dockedScene.get_node("SubViewportContainer");
	subVport = dockedScene.get_node("SubViewportContainer/SubViewport");
	
	label1 = dockedScene.get_node("Label");
	label2 = dockedScene.get_node("Label2");
	img = dockedScene.get_node("SubViewportContainer/SubViewport/Icon");
	camTl = dockedScene.get_node("SubViewportContainer/SubViewport/Camera2D");
	blk = dockedScene.get_node("Blk");
	blk2 = dockedScene.get_node("Blk2");
	
	
	#dockedScene.visible = false;
	#var editorSel = get_editor_interface().get_selection().get_selected_nodes()
	#if ( editorSel.has('TileDraw') ):
		#dockedScene.visible = false;
	#else:
		#dockedScene.visible = true;
	



func _handles(object: Object) -> bool:
	return object is tileDrawNode

func _make_visible(visible: bool) -> void:
	dockedScene.visible = visible

func _forward_canvas_gui_input(event):
	if (event is InputEventMouseButton ):
		dockedScene.visible = true;
		return true
	#print(event);
	#update_overlays();




func _physics_process(delta):
	if not is_instance_valid(dockedScene) || dockedScene.visible == false:
		return;
	
	var scene_root = get_tree().get_edited_scene_root();
	var mG = dockedScene.get_local_mouse_position();
	
	
	if ( mG.x > 0 ):
		label1.text = "DOCK: " + str( mG );
	else:
		label1.text = "DOCK: ";
	
	
	var sVp = subVcont.position;
	var sVs = subVcont.size;
	var sVendR = sVp.x + sVs.x;
	var sVendB = sVp.y + sVs.y;
	
	if ( (mG.x >= sVp.x && mG.y >= sVp.y) && (mG.x <= sVendR && mG.y <= sVendB )  ):
		Mimg = 1;
		MouseOnImage = abs(sVp-mG);
	else:
		Mimg = 0;
	
	if ( ! Input.is_key_pressed(KEY_SHIFT) ):
		if ( Input.is_key_pressed(KEY_LEFT) ):
			subVcont.position.x -= 4;
		elif ( Input.is_key_pressed(KEY_RIGHT ) ):
			subVcont.position.x += 4;
		if ( Input.is_key_pressed(KEY_UP) ):
			subVcont.position.y -= 4;
		elif ( Input.is_key_pressed(KEY_DOWN ) ):
			subVcont.position.y += 4;
		
		blk.position = subVcont.position;
		blk2.position = subVcont.position-Vector2(5, 5);
		
	else:
		if ( Input.is_key_pressed(KEY_LEFT) ):
			subVcont.size.x -= 4;
		elif ( Input.is_key_pressed(KEY_RIGHT ) ):
			subVcont.size.x += 4;
		if ( Input.is_key_pressed(KEY_UP) ):
			subVcont.size.y -= 4;
		elif ( Input.is_key_pressed(KEY_DOWN ) ):
			subVcont.size.y += 4;
		
		blk.size = subVcont.size;
		blk2.size = subVcont.size+Vector2(10, 10);
	
	
	
	



func _input(event):
	if ! is_instance_valid(dockedScene) || dockedScene.visible == false:
		return;
	
	if ( Mimg == 1 ):
		if( Input.is_mouse_button_pressed(MOUSE_BUTTON_MIDDLE)  ):
			
			if event is InputEventMouseMotion:
				camTl.position -= event.relative;
		elif( Input.is_mouse_button_pressed(MOUSE_BUTTON_WHEEL_DOWN) ):
			camTl.zoom -= Vector2(0.03, 0.03);
			
			
		elif( Input.is_mouse_button_pressed(MOUSE_BUTTON_WHEEL_UP) ):
			camTl.zoom += Vector2(0.03, 0.03);
			
		
		
		if event is InputEventMouseButton:
			if event.pressed:
				if event.button_mask == MOUSE_BUTTON_LEFT:
					
					if ( img.Mimg == 1 && img.mouseIN == true ):
						var temp_mX = img.mGx-16;
						var temp_mY = img.mGy-16;
						img.selectRect = Rect2(temp_mX, temp_mY, 32, 32 );
						
						var tempRect = Rect2(temp_mX-16, temp_mY-16, 32, 32 );
						
						dockedEditorDraw.mouse_tex2 = ImageTexture.create_from_image(img.texture.get_image().get_region( tempRect ) );
						
						#dockedEditorDraw.mouse_tex2 = img.mouse_tex;
						
					else:
						img.selectRect = Rect2(0, 0, 0, 0 );
			
			
		
	
	





func _forward_canvas_draw_over_viewport(overlay):
	# Draw a circle at cursor position.
	#overlay.draw_circle(overlay.get_local_mouse_position(), 164, Color.WHITE)
	
	#overlay.draw_texture( img.mouse_tex, overlay.get_local_mouse_position() );
	pass;




func _exit_tree():
	remove_custom_type("TileDraw");
	remove_control_from_docks(dockedScene);
	dockedScene.free();
	
