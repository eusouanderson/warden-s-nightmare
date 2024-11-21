extends CharacterBody3D

# Configurações de movimento
const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const GRAVITY = 9.8
const DECELERATION = 10.0 # Suavização ao parar

# Configurações de câmera
@export var camera: Node3D
@export var mouse_sensitivity: float = 0.2
@export var vertical_limit: float = 80.0 # Limite de rotação vertical (em graus)

# Variáveis para rastrear a rotação da câmera
var rotation_x: float = 0.0 # Rotação vertical
var rotation_y: float = 0.0 # Rotação horizontal

func _ready():
	# Captura o cursor para a movimentação da câmera
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event: InputEvent) -> void:
	# Verifica se o evento é movimento do mouse
	if event is InputEventMouseMotion:
		# Rotação horizontal (gira o corpo do jogador)
		rotation_y -= event.relative.x * mouse_sensitivity
		
		rotation_degrees.y = rotation_y
		
		#Rotação horizontal  (gira a camera com limite)
		rotation_degrees.x = - rotation_x
		
		# Rotação vertical (gira apenas a câmera)
		rotation_x -= event.relative.y * mouse_sensitivity
		# Limita a rotação vertical para não ultrapassar os limites definidos
		rotation_x = clamp(rotation_x, -vertical_limit, vertical_limit)
		
		

		# Aplica a rotação no eixo Y no personagem (corpo)
		rotation_degrees.y = rotation_y

	# Libera o cursor ao pressionar ESC
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _physics_process(delta: float) -> void:
	# Adiciona gravidade
	if not is_on_floor():
		velocity.y -= GRAVITY * delta

	# Trata pulo
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Obtém direção de entrada usando WASD
	var input_dir := Input.get_vector("ui_right", "ui_left", "ui_down", "ui_up")
	var direction: Vector3 = Vector3.ZERO

	# Transforma o input baseado na orientação do jogador/câmera
	if camera:
		direction = (camera.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	else:
		direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	# Aplica velocidade
	if direction.length() > 0.1:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		# Suaviza a desaceleração ao parar
		velocity.x = move_toward(velocity.x, 0, DECELERATION * delta)
		velocity.z = move_toward(velocity.z, 0, DECELERATION * delta)

	# Move o jogador
	move_and_slide()
