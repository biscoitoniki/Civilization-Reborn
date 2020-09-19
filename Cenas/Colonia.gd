extends Node2D

func _ready():
	var save_file:= preload("res://Saves/save.res")
	if save_file.nome == "EU":
		print ("ola")
	#print (teste)
	#if ResourceLoader.exists("res://Saves/save.res"):
	#	var save_file = SaveFile.new()
	#	save_file.nome = "EU"
	#	ResourceSaver.save("res://Saves/save.res", save_file)
	#else:
	#	#var existe := preload("res://Saves/save.res")
	#	print("Existe")
	
	#var save_file = SaveFile.new()
	#save_file.nome = "EU"
	#ResourceSaver.save("res://Saves/save.res", save_file)
	
