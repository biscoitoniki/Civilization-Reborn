extends Node2D

var slot_load

func _ready():
	carregar_jogo()
	
	

func _on_Pedreira_pressed():
	print("pedra")

func _on_Madereira_pressed():
	print("madeira")

func _on_Save_pressed():
	salvar_jogo()

func carregar_jogo():
	slot_load = preload("res://Saves/save.tres")

func salvar_jogo():
	ResourceSaver.save("res://Saves/save.tres", slot_load)

func atribuir_valores():
	$contFabrica.text = str(slot_load.construcoes["Fabrica"])
	$contMadereira.text = str(slot_load.construcoes["Madereira"])
	$contPedreira.text = str(slot_load.construcoes["Pedreira"])
	$qtdMadeira.text = "Madeira:" + str(slot_load.recursos["Madeira"]) 
