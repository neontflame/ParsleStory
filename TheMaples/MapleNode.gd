extends Node2D
class_name MapleNode

var masterParse:Dictionary

func highParse(type:String, file:String):
	var pathle = "%s/%s/%s.img.json" % [FileUtils.get_wz_folder_path("Map"), type, file]
	masterParse = FileUtils.load_json_from_file(pathle)
	for thingy in masterParse:
		var thing = masterParse[thingy]
		if thing is Dictionary:
			lowParse(thing)

func lowParse(thing:Dictionary):
	pass
