extends Node2D

var slot_load
var prox_madereira
var prox_pedreira = {"Madeira" : 0, "Pedra" : 0}
var prox_fabrica = {"Pedra" : 0, "Metal" : 0}
var evento

func _ready():
	#slot_load = SaveFile.new()
	#ResourceSaver.save("res://Saves/save.tres", slot_load)
	carregar_jogo()
	start_reset_timer()
	atribuir_valores()
	calcular_valores()

func _physics_process(delta):
	atribuir_valores()
	up_level()
	calcular_valores()
	game_over()

func _on_Madereira_pressed():
	if (slot_load.recursos["Madeira"] >= prox_madereira):
		slot_load.recursos["Madeira"] -= prox_madereira
		slot_load.construcoes["Madereira"]  += 1

func _on_Pedreira_pressed():
	if (slot_load.recursos["Pedra"] >= prox_pedreira["Pedra"] and
		slot_load.recursos["Madeira"] >= prox_pedreira["Madeira"]):
		
		slot_load.recursos["Pedra"] -= prox_pedreira["Pedra"]
		slot_load.recursos["Madeira"] -= prox_pedreira["Madeira"]
		slot_load.construcoes["Pedreira"]  += 1

func _on_Metaleira_pressed():
	if (slot_load.recursos["Metal"] >= prox_fabrica["Metal"] and
		slot_load.recursos["Pedra"] >= prox_fabrica["Pedra"]):
		
		slot_load.recursos["Pedra"] -= prox_fabrica["Pedra"]
		slot_load.recursos["Metal"] -= prox_fabrica["Metal"]
		slot_load.construcoes["Fabrica"]  += 1 

func _on_Save_pressed():
	salvar_jogo()

func _on_RestarButton_pressed():
	var dir = Directory.new()
	dir.remove("res://Saves/save.tres")
	slot_load = SaveFile.new()
	ResourceSaver.save("res://Saves/save.tres", slot_load)
	#slot_load = preload("res://Saves/save.tres")
	reset_slot()
	$RestarButton.visible = false
	get_tree().reload_current_scene()

func _on_Tickes_timeout():
	var incrementar = 10
	slot_load.recursos["Madeira"] += int(slot_load.construcoes["Madereira"] * 40)
	slot_load.recursos["Pedra"] += int(slot_load.construcoes["Pedreira"] * 40)
	slot_load.recursos["Metal"] += int(slot_load.construcoes["Fabrica"] * 40)
	if  (int(slot_load.level/5) >= 1):
		slot_load.recursos["Populacao"] += 1
	else:
		slot_load.recursos["Populacao"] += 2
	start_reset_timer()
		

func _on_Automatic_save_timeout():
	ResourceSaver.save("res://Saves/save.tres", slot_load)
	$Automatic_save.set_wait_time(300)
	$Automatic_save.start()


func _on_Button_pressed():
	$Save.visible = not $Save.visible
	$RestarButton.visible = not $RestarButton.visible

func _on_eventTrigger_timeout():
	
	$textEvent.visible = true
	$escolhaEsquerda.visible = true
	$escolhaDireita.visible = true
	$backEvent.visible = true
	
	var escolha_dificuldade
	if (slot_load.level < 15):
		escolha_dificuldade = [1,1,1,1,1,1,1,2,2,3]
	elif (slot_load.level >= 15 and slot_load.level < 35):
		escolha_dificuldade = [1,1,1,1,2,2,2,2,3,3]
	else:
		escolha_dificuldade = [1,1,2,2,2,2,3,3,3,3]
	
	var dificuldade = escolha_dificuldade[int(rand_range(0,10))]
	var materiais = ["Madeira", "Pedra", "Metal"]
	var material = materiais[int(rand_range(0,3))]
	var sorteio = int(rand_range(0,lista_eventos.size()))
	var evento_sorteado = lista_eventos[sorteio]
	
	var tipo_decisao = [true, false]
	var tipo = tipo_decisao[int(rand_range(0,tipo_decisao.size()))]
	
	$textEvent.set_text(evento_sorteado["Titulo"])
	$escolhaEsquerda.text = evento_sorteado["Escolhas1"]
	$escolhaDireita.text = evento_sorteado["Escolhas2"]

	if (dificuldade ==  1):
		evento = [sorteio, [material,int(slot_load.recursos[material] * 0.05)],
		[tipo, not tipo], 3, 5]
	elif (dificuldade == 2):
		evento = [sorteio, [material,int(slot_load.recursos[material] * 0.20)],
		[tipo, not tipo], 5, 7]
	else:
		evento = [sorteio, [material,int(slot_load.recursos[material] * 0.25)],
		[tipo, not tipo], 7, 10]
	
func _on_restart_pressed():
	var dir = Directory.new()
	dir.remove("res://Saves/save.tres")
	slot_load = SaveFile.new()
	ResourceSaver.save("res://Saves/save.tres", slot_load)
	#slot_load = preload("res://Saves/save.tres")
	reset_slot()
	$gameOver.visible = false
	$restart.visible = false
	get_tree().reload_current_scene()

func _on_continueEvent_pressed():
	$respostaEvent.visible = false
	$backEvent.visible = false
	$continueEvent.visible = false
	$eventTrigger.set_wait_time(30)
	$eventTrigger.start()

func _on_escolhaEsquerda_pressed():	
	if(evento[2][0] == true):
		slot_load.recursos[evento[1][0]] += evento[1][1]
		
		if (slot_load.recursos["Popularidade"] + evento[3] >=100):
			slot_load.recursos["Popularidade"] = 100
		else:
			slot_load.recursos["Popularidade"] += evento[3]
			
		slot_load.recursos["Populacao"] += evento[4]
		
		var resposta = lista_eventos[evento[0]]
		$respostaEvent.text = resposta["Resposta1-1"]
	
	else:
		slot_load.recursos[evento[1][0]] -= evento[1][1]
		
		if (slot_load.recursos["Popularidade"] - evento[3] <= 0):
			slot_load.recursos["Popularidade"] = 0
		else:
			slot_load.recursos["Popularidade"] -= evento[3]
			
		slot_load.recursos["Populacao"] -= evento[4]
		
		var resposta = lista_eventos[evento[0]]
		$respostaEvent.text = resposta["Resposta1-2"]

	$respostaEvent.visible = true
	$continueEvent.visible = true
	$textEvent.visible = false
	$escolhaEsquerda.visible = false
	$escolhaDireita.visible = false

func _on_escolhaDireita_pressed():
	if(evento[2][1] == true):
		slot_load.recursos[evento[1][0]] += evento[1][1]
		
		if (slot_load.recursos["Popularidade"] + evento[3] >=100):
			slot_load.recursos["Popularidade"] = 100
		else:
			slot_load.recursos["Popularidade"] += evento[3]
			
		slot_load.recursos["Populacao"] += evento[4]
		
		var resposta = lista_eventos[evento[0]]
		$respostaEvent.text = resposta["Resposta2-1"]
	
	else:
		slot_load.recursos[evento[1][0]] -= evento[1][1]
		
		if (slot_load.recursos["Popularidade"] - evento[3] <= 0):
			slot_load.recursos["Popularidade"] = 0
		else:
			slot_load.recursos["Popularidade"] -= evento[3]
			
		slot_load.recursos["Populacao"] -= evento[4]
		
		var resposta = lista_eventos[evento[0]]
		$respostaEvent.text = resposta["Resposta2-2"]

	$respostaEvent.visible = true
	$continueEvent.visible = true
	$textEvent.visible = false
	$escolhaEsquerda.visible = false
	$escolhaDireita.visible = false

func carregar_jogo():
	slot_load = preload("res://Saves/save.tres")

func salvar_jogo():
	ResourceSaver.save("res://Saves/save.tres", slot_load)

func game_over():
	if(slot_load.recursos["Popularidade"] <= 0 or slot_load.recursos["Populacao"] <= 0):
		$backGameOver.visible = true
		$gameOver.visible = true
		$restart.visible = true

func start_reset_timer():
	$Tickes.set_wait_time(slot_load.tickes)
	$Tickes.start()

func calcular_valores():
	prox_madereira = (int(slot_load.construcoes["Madereira"])*100*1.5)
	
	if (slot_load.construcoes["Pedreira"] == 0):
		prox_pedreira["Madeira"] = 300
	else:
		prox_pedreira["Madeira"] = int((slot_load.construcoes["Pedreira"])*100*2)
		prox_pedreira["Pedra"] = int((slot_load.construcoes["Pedreira"])*100*1.5)
	
	if (slot_load.construcoes["Fabrica"] == 0 ):
		prox_fabrica["Pedra"] = 300
	else:
		prox_fabrica["Pedra"] = int((slot_load.construcoes["Fabrica"])*100*2)
		prox_fabrica["Metal"] = int((slot_load.construcoes["Fabrica"])*100*1.5)


func up_level():
	var qtd_construcoes = (slot_load.construcoes["Fabrica"] + 
		slot_load.construcoes["Madereira"] + 
		slot_load.construcoes["Pedreira"])
	
	if (int(qtd_construcoes/3)>1):
		slot_load.level = int(qtd_construcoes/3)
	
	var level_defesa = int(slot_load.level/2)
	if (level_defesa >= 2):
		$defesaEsquerda.set_texture(preload("res://Arte/Defesas/defesaMadeira.png"))
		$defesaDireita.set_texture(preload("res://Arte/Defesas/defesaMadeira.png"))
	elif(level_defesa >= 5):
		$defesaEsquerda.set_texture(preload("res://Arte/Defesas/defesaPedra.jpg"))
		$defesaDireita.set_texture(preload("res://Arte/Defesas/defesaPedra.jpg"))
	elif(level_defesa >= 8):
		$defesaEsquerda.set_texture(preload("res://Arte/Defesas/defesaMetal.png"))
		$defesaDireita.set_texture(preload("res://Arte/Defesas/defesaMetal.png"))
	

func reset_slot():
	slot_load.level = 1
	slot_load.recursos = {
	"Madeira" : 100,
	"Pedra" : 0,
	"Metal" : 0, 
	"Popularidade" : 70,
	"Populacao" : 5}
	
	slot_load.construcoes = {
	"Madereira" : 1,
	"Pedreira" : 0,
	"Fabrica" : 0}
	
	slot_load.defesa = 0
	slot_load.tickes = 5

func atribuir_valores():
	$contFabrica.text = str(slot_load.construcoes["Fabrica"])
	$contMadereira.text = str(slot_load.construcoes["Madereira"])
	$contPedreira.text = str(slot_load.construcoes["Pedreira"])
	$IconeColonia/lvlColonia.text = str(slot_load.level)
	$IconeMadeira/qtdMadeira.text = str(slot_load.recursos["Madeira"])
	$IconePedra/qtdPedra.text = str(slot_load.recursos["Pedra"])
	$IconeMetal/qtdMetal.text = str(slot_load.recursos["Metal"])
	$IconePopulacao/qtdPopulacao.text = str(int(slot_load.recursos["Populacao"]))
	$IconePopularidade/qtdPopularidade.text = str(slot_load.recursos["Popularidade"]) + "%"
	$proxNvMadereira.text = str("Proximo Nv:\n" + str(prox_madereira) + " Madeira")
	$proxNvPedreira.text = str("Proximo Nv:\n" + str(prox_pedreira["Madeira"]) + 
	" Madeiras\n" + str(prox_pedreira["Pedra"])+ " Pedras")
	$proxNvFabrica.text = str("Proximo Nv:\n" + str(prox_fabrica["Pedra"]) + 
	" Pedras\n" + str(prox_fabrica["Metal"]) + " Metais")

var lista_eventos = [
	#Titulo do evento mais as 2 opções de escolha que ele pode fazer
	{"Titulo" : "Você escuta gritos de socorro do lado de fora da colônia", 
		"Escolhas1" : "Averiguar barulho", 
		"Escolhas2" : "Ignorar os gritos",
		#Aqui e gerado um texto resposta que sera decidio caso a opão seja ruim ou boa
		#Basta escrever umapara falso e uma para true com base na escolha, seguindo o exemplo
		#Sendo uma resposta positiva e uma negativa para cada esolha
		"Resposta1-1" : "Por sorte você encontra uma mulher e seu filho machucados mas ainda vivos",
		"Resposta1-2" : "Você havia mandado seus homens irem verificar mas era uma armadilha e eles foram mortos",
		"Resposta2-1" : "Você decide ignorar os gritos, no outro dia encontra rastros do que seria uma armadilha no local dos gritos",
		"Resposta2-2" : "Você ignora os gritos e na manhã seguinte encontra corpos de uma mulher e seu filho"
	},
	{"Titulo" : "Membros da colônia querem averiguar uma mina de ouro", 
		"Escolhas1" : "Permitir a partida dos membros", 
		"Escolhas2" : "Negar partida",
		#Aqui e gerado um texto resposta que sera decidio caso a opão seja ruim ou boa
		#Basta escrever umapara falso e uma para true com base na escolha, seguindo o exemplo
		#Sendo uma resposta positiva e uma negativa para cada esolha
		"Resposta1-1" : "Seus homens encontraram recursos perdidos na mina.",
		"Resposta1-2" : "A mina desabou e metade dos homens morreram",
		"Resposta2-1" : "Ao amanhecer alguns homens de patrulha decobrem que a mina havia desabado",
		"Resposta2-2" : "A colônia fica enfurecida por sua decisão"
	},
	{"Titulo" : "Uma mensagem de ataque foi enviada para você", 
		"Escolhas1" : "Se preparar para o ataque", 
		"Escolhas2" : "Sem tempo para isso",
		#Aqui e gerado um texto resposta que sera decidio caso a opão seja ruim ou boa
		#Basta escrever umapara falso e uma para true com base na escolha, seguindo o exemplo
		#Sendo uma resposta positiva e uma negativa para cada esolha
		"Resposta1-1" : "Com sua preparação um massacre foi evitado",
		"Resposta1-2" : "A mensagem era falsa e você gasta recursos para nada",
		"Resposta2-1" : "Se passam vários dias e nada aconteceu",
		"Resposta2-2" : "Por falta de preparação sua colônia teve muitos prejuízos"
	},
	{"Titulo" : "Um ladrão foi capturado pelos civis", 
		"Escolhas1" : "Poupar o ladrão", 
		"Escolhas2" : "Mandá-lo para prisão",
		#Aqui e gerado um texto resposta que sera decidio caso a opão seja ruim ou boa
		#Basta escrever umapara falso e uma para true com base na escolha, seguindo o exemplo
		#Sendo uma resposta positiva e uma negativa para cada esolha
		"Resposta1-1" : "Você poupa ele e mais tarde descobre \n que ele tinha filhos a beira da morte",
		"Resposta1-2" : "A população se revolta com sua benevolência e senso de justiça",
		"Resposta2-1" : "A populaçãp o aplaude por fazer o certo e ser justo",
		"Resposta2-2" : "Após 3 dias presos você encontra o homem morto \n o motivo a parente foi n ter chegado a tempo para salvar sua crianças da fome"
	},
	{"Titulo" : "Um estraho chega a colônia e é barrado de entrar", 
		"Escolhas1" : "Permitir Entrada", 
		"Escolhas2" : "Negar Entrada",
		#Aqui e gerado um texto resposta que sera decidio caso a opão seja ruim ou boa
		#Basta escrever umapara falso e uma para true com base na escolha, seguindo o exemplo
		#Sendo uma resposta positiva e uma negativa para cada esolha
		"Resposta1-1" : "O estranho se revela um mercador \n e em troca de sua entrada ele entrega algumas mecadorias",
		"Resposta1-2" : "Após algumas horas o estranho foi visto fugindo com mercadorias roubadas",
		"Resposta2-1" : "Enfurecido ele tenta atacar um dos guardas mas é contido \n na verdade ele era ladrão tentando se infiltrar",
		"Resposta2-2" : "Ele se revela ser um mercador e vai embira com suas mercadorias"
	},
]
