
extends Camera3D

@export var velocidad: float = 5.0
@export var sensibilidad_mouse: float = 0.003

var girando: bool = false

func _ready() -> void:
	current = true

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		girando = event.pressed
		Input.set_mouse_mode(
			Input.MOUSE_MODE_CAPTURED if girando
			else Input.MOUSE_MODE_VISIBLE
		)

	elif event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		girando = false
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	elif event is InputEventMouseMotion and girando:
		rotation.y -= event.relative.x * sensibilidad_mouse
		rotation.x = clamp(
			rotation.x - event.relative.y * sensibilidad_mouse,
			deg_to_rad(-89),
			deg_to_rad(89)
		)

func _process(delta: float) -> void:
	var direccion := Vector3.ZERO

	# Movimiento horizontal
	var adelante := -global_transform.basis.z
	var derecha := global_transform.basis.x

	adelante.y = 0.0
	derecha.y = 0.0

	adelante = adelante.normalized()
	derecha = derecha.normalized()

	if Input.is_physical_key_pressed(KEY_W):
		direccion += adelante

	if Input.is_physical_key_pressed(KEY_S):
		direccion -= adelante

	if Input.is_physical_key_pressed(KEY_A):
		direccion -= derecha

	if Input.is_physical_key_pressed(KEY_D):
		direccion += derecha

	# Movimiento vertical opcional
	if Input.is_physical_key_pressed(KEY_E):
		direccion += Vector3.UP

	if Input.is_physical_key_pressed(KEY_Q):
		direccion -= Vector3.UP

	if direccion.length_squared() > 0.0:
		global_position += direccion.normalized() * velocidad * delta

func _exit_tree() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
