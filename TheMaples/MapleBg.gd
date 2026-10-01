extends MapleNode
class_name MapleBg

@export var textureRect:TextureRect
@export var parallax:Parallax2D

var copySpacing:Vector2 = Vector2.ZERO # cx, cy

var bgType:String = ''
var variation:String = ''
var behavior:int = 0

# a bit of the stuff here is taken from (or inspired in) https://github.com/mikuYongh/Godot-mapleStory
enum BackgroundBehavior {
	NORMAL = 0,
	HTILED = 1,
	VTILED = 2,
	TILED = 3,
	HMOVEA = 4,
	VMOVEA = 5,
	HMOVEB = 6,
	VMOVEB = 7,
}

func setup(bg, type):
	highParse("Back", bg)
	bgType = bg
	parseBG(type)

var viewportMiddle:Vector2 #thought i was gonna use this a lot more but i guess not lel

func parseBG(type:String):
	viewportMiddle = get_viewport().get_visible_rect().size * Vector2(0.5, 0.5)
	
	var theParsley = masterParse["back"][type]
	var img = Image.new()
	img.load_png_from_buffer(
		Marshalls.base64_to_raw(theParsley["_image"])
	)
	textureRect.size = Vector2(theParsley["_width"], theParsley["_height"])
	textureRect.texture = ImageTexture.create_from_image(img)
	textureRect.position = Vector2i(theParsley["origin"]["_x"], theParsley["origin"]["_y"]) * -1
	textureRect.position += viewportMiddle
	if theParsley.has("z"):
		textureRect.z_index -= theParsley["z"]["_value"]
	
	variation = type

# up and down and all around
func setupBehavior(_behavior:int):
	behavior = _behavior
	# print(bgType, variation, behavior)
	
	# ok so normal does nothing
	match (behavior):
		BackgroundBehavior.HTILED:
			parallax.repeat_size = (textureRect.size + copySpacing) * Vector2(1.0, 0.0)
		BackgroundBehavior.VTILED:
			parallax.repeat_size = (textureRect.size + copySpacing) * Vector2(0.0, 1.0)
		BackgroundBehavior.TILED:
			textureRect.position.x -= viewportMiddle.x
			parallax.repeat_size = (textureRect.size + copySpacing)
		BackgroundBehavior.HMOVEA:
			parallax.repeat_size = (textureRect.size + copySpacing) * Vector2(1.0, 0.0)
			parallax.autoscroll = parallax.scroll_scale.x * Vector2(1.0, 0.0) * 200
		BackgroundBehavior.VMOVEA:
			parallax.repeat_size = (textureRect.size + copySpacing) * Vector2(0.0, 1.0)
			parallax.autoscroll = parallax.scroll_scale.x * Vector2(0.0, 1.0) * 200
		BackgroundBehavior.HMOVEB:
			parallax.repeat_size = (textureRect.size + copySpacing)
			parallax.autoscroll = parallax.scroll_scale.x * Vector2(1.0, 0.0) * 200
		BackgroundBehavior.VMOVEB:
			parallax.repeat_size = (textureRect.size + copySpacing)
			parallax.autoscroll = parallax.scroll_scale.x * Vector2(0.0, 1.0) * 200
		_:
			pass
	# might not be the Ideal course of action but it works i guess !!
	var repeatThing = ceil((viewportMiddle * 2) / parallax.repeat_size)
	parallax.repeat_times = repeatThing.x + 2
	if repeatThing.y != INF:
		parallax.repeat_times += repeatThing.y
	print(parallax.repeat_times)
