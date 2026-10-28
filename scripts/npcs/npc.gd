extends CharacterBody3D

@export var npc_name: String = "Empleado"
@export var suspicion_amount: float = 25.0

enum State { IDLE, COMPROMISED, DETECTED }
var state: State = State.IDLE

func interact(player):
	match state:
		State.IDLE:
			GameManager.add_suspicion(suspicion_amount, npc_name)
			state = State.COMPROMISED
			print(npc_name + " interactuado")
		State.COMPROMISED:
			GameManager.register_clue("clue_" + npc_name)
			state = State.DETECTED
