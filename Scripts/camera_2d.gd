extends Camera2D

@export var desvio_maximo: Vector2 = Vector2(10.0, 10.0) # Distancia máxima del temblor en píxeles
@export var velocidad_recuperacion: float = 3.0       # Qué tan rápido vuelve la pantalla a la normalidad

var intensidad_temblor: float = 0.0

func _ready() -> void:
	# Asegura que la cámara pertenezca al grupo que buscan los bloques
	add_to_group("camara")

func _process(delta: float) -> void:
	if intensidad_temblor > 0.0:
		# Genera un desplazamiento aleatorio multiplicado por la intensidad actual
		offset = Vector2(
			randf_range(-desvio_maximo.x, desvio_maximo.x) * intensidad_temblor,
			randf_range(-desvio_maximo.y, desvio_maximo.y) * intensidad_temblor
		)
		# Reduce gradualmente el temblor hacia cero
		intensidad_temblor = move_toward(intensidad_temblor, 0.0, delta * velocidad_recuperacion)
	else:
		offset = Vector2.ZERO

# Método llamado por el último bloque al destruirse
func sacudir(fuerza: float = 1.0) -> void:
	intensidad_temblor = fuerza
