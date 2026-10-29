
extends Node3D

# PHISHING AWARENESS GAME
# ITSE Panama - Electiva II
# Diseno de nivel: Juan V. Herrera
# VERSION 3 - Oficina corporativa
# Godot 4.x

const BLANCO = Color(0.88, 0.90, 0.93)
const GRIS = Color(0.47, 0.52, 0.58)
const PISO = Color(0.66, 0.70, 0.74)
const AZUL = Color(0.06, 0.43, 0.80)
const MADERA = Color(0.48, 0.27, 0.15)
const OSCURO = Color(0.12, 0.17, 0.22)
const VERDE = Color(0.16, 0.48, 0.36)


func _ready() -> void:
	crear_oficina()


# Genera un bloque visible con colision.
func crear_bloque(
	nombre: String,
	posicion: Vector3,
	tamano: Vector3,
	color: Color
) -> void:
	var cuerpo = StaticBody3D.new()
	cuerpo.name = nombre
	cuerpo.position = posicion
	add_child(cuerpo)

	var visual = MeshInstance3D.new()
	var malla = BoxMesh.new()
	malla.size = tamano
	visual.mesh = malla

	var material = StandardMaterial3D.new()
	material.albedo_color = color
	visual.material_override = material
	cuerpo.add_child(visual)

	var colision = CollisionShape3D.new()
	var forma = BoxShape3D.new()
	forma.size = tamano
	colision.shape = forma
	cuerpo.add_child(colision)


func crear_muro_horizontal(
	nombre: String,
	x_inicio: float,
	x_fin: float,
	z: float
) -> void:
	var ancho = x_fin - x_inicio
	crear_bloque(
		nombre,
		Vector3((x_inicio + x_fin) / 2.0, 1.6, z),
		Vector3(ancho, 3.2, 0.2),
		BLANCO
	)


func crear_puerta_h(
	nombre: String,
	x_inicio: float,
	x_fin: float,
	x_puerta: float,
	z: float
) -> void:
	# Abertura de 2 metros
	var izquierda = x_puerta - 1.0
	var derecha = x_puerta + 1.0

	if izquierda > x_inicio:
		crear_muro_horizontal(
			nombre + "_Izq", x_inicio, izquierda, z
		)

	if derecha < x_fin:
		crear_muro_horizontal(
			nombre + "_Der", derecha, x_fin, z
		)


func crear_oficina() -> void:
	crear_estructura()
	crear_recepcion()
	crear_area_trabajo()
	crear_servidores()
	crear_reuniones()
	crear_gerencia()
	crear_banos_almacen()


func crear_estructura() -> void:
	# Piso general de 30 x 20 metros
	crear_bloque(
		"PisoPrincipal",
		Vector3(0, -0.15, 0),
		Vector3(30, 0.3, 20),
		PISO
	)

	# Paredes exteriores
	crear_bloque(
		"ParedIzquierda",
		Vector3(-15, 1.6, 0),
		Vector3(0.2, 3.2, 20),
		BLANCO
	)

	crear_bloque(
		"ParedDerecha",
		Vector3(15, 1.6, 0),
		Vector3(0.2, 3.2, 20),
		BLANCO
	)

	crear_muro_horizontal(
		"ParedFondo", -15, 15, -10
	)

	# Entrada principal de 3 metros
	crear_muro_horizontal(
		"FachadaIzquierda", -15, -1.5, 10
	)
	crear_muro_horizontal(
		"FachadaDerecha", 1.5, 15, 10
	)

	# Divisiones del lado norte
	for x in [-9.0, 8.0]:
		crear_bloque(
			"DivisionNorte_" + str(x),
			Vector3(x, 1.6, -5.5),
			Vector3(0.2, 3.2, 9),
			BLANCO
		)

	# Divisiones del lado sur
	for x in [-6.0, 0.0, 6.0]:
		crear_bloque(
			"DivisionSur_" + str(x),
			Vector3(x, 1.6, 5.5),
			Vector3(0.2, 3.2, 9),
			BLANCO
		)

	# Accesos desde el pasillo principal
	crear_puerta_h(
		"Recepcion", -15, -9, -12, -1
	)
	crear_puerta_h(
		"Oficinas", -9, 8, 0, -1
	)
	crear_puerta_h(
		"Servidores", 8, 15, 11.5, -1
	)

	crear_puerta_h(
		"Reuniones", -15, -6, -11, 1
	)
	crear_puerta_h(
		"Banos", -6, 0, -3, 1
	)
	crear_puerta_h(
		"Almacen", 0, 6, 3, 1
	)
	crear_puerta_h(
		"Gerencia", 6, 15, 10, 1
	)

	# Franja del pasillo central
	crear_bloque(
		"PasilloPrincipal",
		Vector3(0, 0.015, 0),
		Vector3(29.5, 0.03, 1.8),
		GRIS
	)


func crear_recepcion() -> void:
	crear_bloque(
		"MostradorRecepcion",
		Vector3(-12, 0.55, -6),
		Vector3(3.5, 1.1, 0.9),
		MADERA
	)

	crear_bloque(
		"SofaRecepcion",
		Vector3(-12, 0.35, -3.5),
		Vector3(2.5, 0.7, 0.8),
		AZUL
	)

	crear_bloque(
		"RespaldoSofa",
		Vector3(-12, 0.8, -3.9),
		Vector3(2.5, 0.9, 0.2),
		AZUL
	)


func crear_area_trabajo() -> void:
	# Seis estaciones: 3 columnas x 2 filas
	var numero = 0

	for fila in range(2):
		for columna in range(3):
			numero += 1
			var x = -6.0 + columna * 5.0
			var z = -7.0 + fila * 3.5

			crear_puesto(
				"Empleado_" + str(numero),
				Vector3(x, 0, z)
			)


func crear_puesto(
	nombre: String,
	origen: Vector3
) -> void:
	var x = origen.x
	var z = origen.z

	# Escritorio
	crear_bloque(
		nombre + "_Mesa",
		Vector3(x, 0.75, z),
		Vector3(2.0, 0.15, 1.1),
		MADERA
	)

	# Patas de mesa
	for lado in [-0.8, 0.8]:
		crear_bloque(
			nombre + "_Pata_" + str(lado),
			Vector3(x + lado, 0.35, z),
			Vector3(0.12, 0.7, 0.12),
			OSCURO
		)

	# Monitor y pantalla
	crear_bloque(
		nombre + "_Monitor",
		Vector3(x, 1.1, z - 0.3),
		Vector3(0.85, 0.55, 0.08),
		OSCURO
	)

	crear_bloque(
		nombre + "_Pantalla",
		Vector3(x, 1.1, z - 0.25),
		Vector3(0.72, 0.42, 0.02),
		AZUL
	)

	# Teclado
	crear_bloque(
		nombre + "_Teclado",
		Vector3(x, 0.86, z + 0.25),
		Vector3(0.6, 0.04, 0.2),
		OSCURO
	)

	# Silla
	crear_bloque(
		nombre + "_Asiento",
		Vector3(x, 0.43, z + 1.1),
		Vector3(0.7, 0.12, 0.7),
		OSCURO
	)

	crear_bloque(
		nombre + "_Respaldo",
		Vector3(x, 0.85, z + 1.45),
		Vector3(0.7, 0.85, 0.12),
		OSCURO
	)


func crear_servidores() -> void:
	for i in range(3):
		var x = 10.0 + float(i) * 1.5

		crear_bloque(
			"Rack_" + str(i),
			Vector3(x, 1.15, -7),
			Vector3(1.0, 2.3, 1.2),
			OSCURO
		)

		# Luces de estado azules
		for j in range(4):
			crear_bloque(
				"LED_" + str(i) + "_" + str(j),
				Vector3(
					x, 0.45 + j * 0.4, -6.39
				),
				Vector3(0.5, 0.08, 0.02),
				AZUL
			)


func crear_reuniones() -> void:
	crear_bloque(
		"MesaReuniones",
		Vector3(-10.5, 0.75, 5.5),
		Vector3(3.5, 0.18, 1.6),
		MADERA
	)

	for i in range(3):
		var x = -11.7 + float(i) * 1.2

		for lado in [-1.0, 1.0]:
			crear_bloque(
				"SillaReunion_" + str(i) + "_" + str(lado),
				Vector3(x, 0.45, 5.5 + lado * 1.3),
				Vector3(0.6, 0.2, 0.6),
				OSCURO
			)


func crear_gerencia() -> void:
	crear_bloque(
		"EscritorioGerente",
		Vector3(10.5, 0.75, 6),
		Vector3(2.4, 0.18, 1.2),
		MADERA
	)

	crear_bloque(
		"ComputadoraGerente",
		Vector3(10.5, 1.1, 5.7),
		Vector3(0.9, 0.6, 0.12),
		OSCURO
	)

	crear_bloque(
		"PantallaGerente",
		Vector3(10.5, 1.1, 5.77),
		Vector3(0.75, 0.45, 0.02),
		AZUL
	)

	crear_bloque(
		"ArchivadorGerente",
		Vector3(13.4, 0.8, 8),
		Vector3(1.1, 1.6, 0.7),
		GRIS
	)


func crear_banos_almacen() -> void:
	# Separadores de sanitarios
	for i in range(2):
		crear_bloque(
			"Sanitario_" + str(i),
			Vector3(-4.5 + i * 2.0, 0.35, 6),
			Vector3(0.6, 0.7, 0.7),
			BLANCO
		)

	# Estanterias de almacen
	for i in range(2):
		crear_bloque(
			"Estanteria_" + str(i),
			Vector3(1.5 + i * 2.0, 1, 7),
			Vector3(1.2, 2, 0.6),
			MADERA
		)

	# Cajas
	for i in range(3):
		crear_bloque(
			"Caja_" + str(i),
			Vector3(1.3 + i * 1.3, 0.3, 4),
			Vector3(0.8, 0.6, 0.8),
			MADERA
		)
