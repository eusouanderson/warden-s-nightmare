extends DirectionalLight3D

# Tempo real (em segundos) para completar um ciclo de 12 horas
const DAY_NIGHT_CYCLE_DURATION: float = 100 # minutos em tempo real
# Ângulo total de rotação para um ciclo completo
const FULL_ROTATION: float = 360.0

# Variável para rastrear o progresso do ciclo
var current_rotation: float = 0.0

# Chamada quando o nó entra na árvore da cena
func _ready() -> void:
	# Configura a rotação inicial (opcional)
	rotation_degrees.x = -90.0 # Luz começa no horizonte

# Chamado a cada frame
func _process(delta: float) -> void:
	# Calcula a velocidade de rotação
	var rotation_speed = FULL_ROTATION / DAY_NIGHT_CYCLE_DURATION
	# Atualiza a rotação da luz
	current_rotation += rotation_speed * delta
	current_rotation = fmod(current_rotation, FULL_ROTATION) # Garante que o valor fique dentro de 0-360
	rotation_degrees.x = current_rotation - 90.0 # Ajuste para simular o ciclo correto
