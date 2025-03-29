extends Area2D

@export var speed: float = 150.0
var screen_size # Size of the game window.
var orientation = Vector2.ZERO #at the top of the class
signal hit

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	#ide()
	
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Input.get_vector('move_left', 'move_right', 'move_up', 'move_down') * speed
	var direction = ""
	var animtoplay = "walk"

	if velocity.y < 0:
		direction = "up"
	elif velocity.y > 0:
		direction = "down"

	if velocity.x < 0:
		direction += "left"
	elif velocity.x > 0:
		direction += "right"
	
	$AnimatedSprite2D.play(animtoplay)
	
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		position += velocity * delta
		position = position.clamp(Vector2.ZERO, screen_size)
	else:
		$AnimatedSprite2D.play('',0)


func _on_body_entered(body: Node2D) -> void:
	hide() # Player disappears after being hit.
	hit.emit()
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)
