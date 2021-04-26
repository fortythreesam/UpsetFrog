extends Node2D
class_name Projectile

var damage: int
var entity
export(bool) var reflectable = true

var velocity: Vector2
var lifespan: float

onready var sounds = $Sounds 

func _ready():
	$HitBox.connect("body_entered", self, "_on_HitBox_Body_entered")
	$HitBox.connect("area_entered", self, "_on_HitBox_Area_entered")

func _process(delta):
	position += velocity * delta
	
	lifespan -= delta
	
	if lifespan < 0:
		queue_free()
	
func reflect(reflector):
	if reflectable:
		play_sound("reflect")
		velocity *= -1.5
		entity = reflector

func _on_HitBox_Body_entered(body):
	if body != entity and\
	   (body.is_player or entity.is_player)\
	   and body.has_method("hit"):
		body.hit(damage, sign(velocity.x))
		queue_free()
		
func _on_HitBox_Area_entered(area):
	if area.name == "HurtBox":
		var body = area.get_parent()
		
		if body != entity and\
		   (body.is_player or entity.is_player)\
		   and body.has_method("hit"):
			body.hit(damage, sign(velocity.x))
			queue_free()

func play_sound(sound):
	if sounds != null:
		if sounds.get_node(sound) != null:
			sounds.get_node(sound).play()
