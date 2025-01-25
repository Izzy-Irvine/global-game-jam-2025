extends Node

@export var target: Node2D
@export var particle_scene: PackedScene
@export var duration: float = 0.1
@export var emit_interval: float = 1
var tween: Tween
var timer: float = 0



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(target)
	tween = create_tween()
	tween.tween_property(self, "global_position", target.global_position, duration)
	pass # Replace with function body.

func create_particles(position) -> void:
	print(particle_scene)
	var particles = particle_scene.instantiate()
	particles.get_child(0).global_position = position
	get_tree().root.add_child(particles)
	particles.get_child(0).emitting = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer += delta
	if self.global_position.distance_to(target.global_position) > 1:
		if timer >= emit_interval:
			create_particles(self.global_position)
			timer = 0
	else:
		queue_free()
