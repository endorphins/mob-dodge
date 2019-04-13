extends Area2D

signal hit

export(int) var SPEED
var velocity = Vector2()
var screen_size

func _ready():
	hide()
	screen_size = get_viewport_rect().size
	# TODO(endorphins) remove once we are done testing and it is hooked up to game start
	start(Vector2(screen_size.x / 2, screen_size.y / 2))

func _process(delta):
	velocity = Vector2()
	
	# detect key
	# TODO(endorphins) use keybindings instead of forcing player to use arrow keys
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * SPEED
		$AnimatedSprite.speed_scale = 1
	else:
		# TODO(endorphins) probably replace with a separate idle animation
		$AnimatedSprite.animation = "right"
		# don't flip horizontal, we want to be facing whatever way we were facing before we stopped moving
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.speed_scale = 0.5
	
	# move
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	# use appropriate animation
	if velocity.x != 0:
		$AnimatedSprite.animation = "right"
		$AnimatedSprite.flip_h = velocity.x < 0
		$AnimatedSprite.flip_v = velocity.y > 0
	elif velocity.y != 0:
		$AnimatedSprite.animation = "up"
		# don't flip horizontal, we want to be facing whatever way we were facing before we stopped
		$AnimatedSprite.flip_v = velocity.y > 0

func _on_Player_body_entered(body):
	hide()
	emit_signal("hit")
	call_deferred("set_monitoring", false)

func start(pos):
	position = pos
	show()
	$AnimatedSprite.play()
	monitoring = true
