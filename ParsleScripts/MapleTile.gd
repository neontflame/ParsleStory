extends MapleNode
class_name MapleTile

@export var tile:Sprite2D
var variation:String = ''
var subvar:String = ''

func setup(tile, type, subtype):
	highParse("Tile", tile)
	var subtypeConvert:int = round(subtype)
	parseTile(type, str(subtypeConvert))

func parseTile(type:String, subtype:String):
	var theParsley = masterParse[type][subtype]
	var img = Image.new()
	img.load_png_from_buffer(
		Marshalls.base64_to_raw(theParsley["_image"])
	)
	tile.texture = ImageTexture.create_from_image(img)
	tile.offset = Vector2i(theParsley["origin"]["_x"], theParsley["origin"]["_y"]) * -1
	# z_index -= theParsley["z"]["_value"]
	
	variation = type
	subvar = subtype
