extends CharacterBody2D
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D

# Configurações de movimento
const MAX_SPEED = 200.0
const ACCELERATION = 800.0
const FRICTION = 1000.0
const AIR_RESISTANCE = 200.0

# Configurações de pulo
const JUMP_VELOCITY = -250.0
const MAX_JUMPS = 2
const JUMP_CUT_MULTIPLIER = 0.5  # Reduz a velocidade se soltar o botão de pulo

var jump_count = 0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func jump():
	velocity.y = JUMP_VELOCITY

func _physics_process(delta: float) -> void:
	if (velocity.x > 1):
		sprite_2d.animation = "running_right"
	elif (velocity.x < -1):
		sprite_2d.animation = "running_left"
	else:
		sprite_2d.animation = "default"

	# Aplica gravidade
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		jump_count = 0  # Reseta o contador quando toca no chão

	# Controle de pulo mais responsivo
	if Input.is_action_just_pressed("ui_accept"):
		if is_on_floor() or jump_count < MAX_JUMPS:
			velocity.y = JUMP_VELOCITY
			jump_count += 1
	
	# Corte do pulo (personagem cai mais rápido se soltar o botão)
	if Input.is_action_just_released("ui_accept") and velocity.y < 0:
		velocity.y *= JUMP_CUT_MULTIPLIER

	# Movimento horizontal suavizado
	var direction := Input.get_axis("ui_left", "ui_right")
	
	if direction != 0:
		# Aceleração progressiva
		if is_on_floor():
			velocity.x = move_toward(velocity.x, direction * MAX_SPEED, ACCELERATION * delta)
		else:
			# Menor controle no ar
			velocity.x = move_toward(velocity.x, direction * MAX_SPEED, (ACCELERATION * 0.6) * delta)
	else:
		# Desaceleração progressiva
		if is_on_floor():
			velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
		else:
			# Menor atrito no ar
			velocity.x = move_toward(velocity.x, 0, AIR_RESISTANCE * delta)

	move_and_slide()
