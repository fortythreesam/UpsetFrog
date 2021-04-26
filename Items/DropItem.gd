extends Node2D
class_name DropItem

var velocity: Vector2

func _ready():
	velocity = Vector2(rand_range(-40, 40), rand_range(40, -40))
	
func _process(delta):
	position += velocity * delta
	velocity = lerp(velocity, Vector2.ZERO, 0.1) 
