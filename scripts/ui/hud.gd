extends CanvasLayer

@onready var suspicion_bar: ProgressBar = $SuspicionBar
@onready var suspicion_label: Label = $SuspicionLabel
@onready var game_over_panel: Panel = $GameOverPanel
@onready var game_over_label: Label = $GameOverPanel/GameOverLabel
@onready var restart_button: Button = $GameOverPanel/RestartButton

func _ready():
	GameManager.suspicion_changed.connect(_on_suspicion_changed)
	GameManager.game_over.connect(_on_game_over)
	restart_button.pressed.connect(_on_restart)

func _on_suspicion_changed(value: float):
	suspicion_bar.value = value
	suspicion_label.text = "Sospecha: %d%%" % int(value)

func _on_game_over(won: bool, reason: String):
	game_over_panel.visible = true
	game_over_label.text = "¡GANASTE!" if won else "DESCUBIERTO"
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_restart():
	GameManager.current_state = GameManager.GameState.PLAYING
	GameManager.suspicion_level = 0.0
	get_tree().reload_current_scene()
