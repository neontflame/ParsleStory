extends MapleNode
class_name MaplePortal

@export var sprite:AnimatedSprite2D
@export var spriteStatic:Sprite2D

@export var portalAccessArea:Area2D
@export var portalCollision:CollisionShape2D

var masterType:String = ''
var type:int = -1

var targetMap:int = 0
var targetPortal:String = ''

func setup(_masterType, _type):
	sprite.visible = false
	
	highParseRoot('MapHelper')
	
	masterType = _masterType
	type = _type
	
	# i now apologize for the uncommented code
	var masterAnimated = getCoolAnim(masterType, type)
	
	if masterParse['portal']['editor'].has(masterAnimated):
		var parsley:Dictionary = masterParse['portal']['editor'][masterAnimated]
		var img = Image.new()
		img.load_png_from_buffer(
			Marshalls.base64_to_raw(parsley["_image"])
		)
		spriteStatic.texture = ImageTexture.create_from_image(img)
		spriteStatic.offset = Vector2i(parsley["origin"]["_x"], parsley["origin"]["_y"]) * -1
	
	if masterParse['portal']['game'].has(masterAnimated):
		spriteStatic.visible = false
		sprite.visible = true
		
		var parsley:Dictionary = masterParse['portal']['game'][masterAnimated]
		if parsley.has("default"):
			parsley = parsley['default']['portalStart']
		parseAnimation(parsley)
		
		if parsley['0'].has("z"):
			z_index += parsley['0']["z"]["_value"]
			
	z_index += 100
	
	if not getCoolAnim(masterType, type) in ['pv', 'ph', 'psh']:
		visible = false

func getCoolAnim(willBeSwitched:String, type:int):
	match willBeSwitched:
		_:
			if willBeSwitched == 'out00' or willBeSwitched == 'in00':
				if type == 0:
					return 'pv'
				if type == 1:
					return 'ph'
				if type == 2:
					return 'psh'
			return willBeSwitched

var animSetup:bool = false
var frameOffsetIndex:Dictionary = {
}

func parseAnimation(parsled):
	var newFrames = SpriteFrames.new() # because to do otherwise would mean every sprite would have the same animation. And we dont want that
	
	sprite.sprite_frames = newFrames
	for frameKey in parsled:
		var frame = parsled[frameKey]
		if frame is Dictionary:
			if frame.has("_image"):
				#print('frame ', frameKey, ' of ', variation)
				
				var img = Image.new()
				img.load_png_from_buffer(
					Marshalls.base64_to_raw(frame["_image"])
				)
				var tex:ImageTexture = ImageTexture.create_from_image(img)
				
				# ok Now the animations are accurate
				var lengthInMultiplys:float = 1.0
				if frame.has("delay"):
					lengthInMultiplys = (frame["delay"]["_value"] / 1000.0) / (1.0/15.0)
				
				sprite.sprite_frames.add_frame("default", tex, lengthInMultiplys, int(frameKey))
				# every frame has a different offset for some godforsaken reason
				frameOffsetIndex[frameKey] = Vector2i(
					frame["origin"]["_x"], 
					frame["origin"]["_y"]
					) * -1
	sprite.sprite_frames.set_animation_speed("default", 15.0)
	sprite.play("default")
	animSetup = true

func onFrameChange():
	if frameOffsetIndex.has(str(sprite.frame)):
		sprite.offset = frameOffsetIndex[str(sprite.frame)]
		
	if animSetup:
		portalAccessArea.scale = sprite.sprite_frames.get_frame_texture(sprite.animation, 0).get_size() * Vector2(1, 0.9)
