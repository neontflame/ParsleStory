extends Node
class_name MapleFileUtils

static func get_wz_folder_path(wz:String):
	return "mapleExport/%s.wz" % wz
	
static func get_user_path():
	return OS.get_executable_path().get_base_dir()

static func get_text_file_content(pathness) -> String:
	var filePath = get_user_path() + "/" + pathness
	
	if FileAccess.file_exists(filePath):
		return FileAccess.get_file_as_string(filePath)
	return ''

static var jsonCache:Dictionary = {}

static func load_json_from_file(path:String):
	if jsonCache.has(path):
		return jsonCache[path]
	
	var jsonToLoad:String = get_text_file_content(path)
	jsonCache[path] = JSON.parse_string(jsonToLoad)
	
	return jsonCache[path]

static func load_song(song:String):
	var leSplit:Array = song.split("/", false)
	var songpath = get_user_path() + "/" + get_wz_folder_path("Sound")
	songpath += "/%s.img/%s.img/%s.mp3" % [leSplit[0], leSplit[0], leSplit[1]]
	
	var bytery = FileAccess.get_file_as_bytes(songpath)
	var mpstream = AudioStreamMP3.new()
	
	mpstream.data = bytery
	mpstream.loop = true
	
	return mpstream
