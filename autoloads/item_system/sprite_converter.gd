extends Node2D

# Path to the spritesheet image
const SPRITESHEET_PATH = "res://item_system/assets/super_pixel_objects/spritesheet/spritesheet.png"
# Path to the spritesheet description file
const SPRITESHEET_DESC_PATH = "res://item_system/assets/super_pixel_objects/spritesheet/spritesheet.txt"

func _ready():
	var sprite_frames = SpriteFrames.new()
	
	var file = FileAccess.open(SPRITESHEET_DESC_PATH, FileAccess.READ)
	if file:
		while not file.eof_reached():
			var line = file.get_line()
			if line.strip_edges() == "":
				continue
			
			var parts = line.split(" = ")
			var sprite_path = parts[0]
			var coords = parts[1].split(" ")
			var x = int(coords[0])
			var y = int(coords[1])
			var width = int(coords[2])
			var height = int(coords[3])
			
			var region = Rect2(x, y, width, height)
			var image = Image.load_from_file(SPRITESHEET_PATH)
			var texture = ImageTexture.create_from_image(image)
			var region_image = texture.get_rect(region)
			
			var frame_name_parts = sprite_path.split("/")
			var animation_name = frame_name_parts[1]
			var frame_name = frame_name_parts[2].split(".")[0]
			
			if not sprite_frames.has_animation(animation_name):
				sprite_frames.add_animation(animation_name)
			
			var region_texture = ImageTexture.new()
			region_texture.create_from_image(region_image)
			sprite_frames.add_frame(animation_name, region_texture)
		
		file.close()
	
	var animated_sprite = AnimatedSprite2D.new()
	animated_sprite.sprite_frames = sprite_frames
	add_child(animated_sprite)
	
	# Play the first animation
	if sprite_frames.get_animation_names().size() > 0:
		animated_sprite.animation = sprite_frames.get_animation_names()[0]
		animated_sprite.play()
