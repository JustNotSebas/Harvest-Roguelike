extends Node2D

const BULLET = preload("res://Gun/bullet.tscn")

@onready var muzzle: Marker2D = $Gun/Muzzle

func _process(_delta: float) -> void:
	var aim_dir := get_global_mouse_position() - global_position
	rotation = aim_dir.angle()
	scale.y = -1 if aim_dir.x < 0 else 1

	if Input.is_action_just_pressed("fire"):
		shoot()

func shoot() -> void:
	var bullet_instance = BULLET.instantiate()
	get_tree().current_scene.add_child(bullet_instance)
	bullet_instance.global_position = muzzle.global_position
	bullet_instance.rotation = (get_global_mouse_position() - muzzle.global_position).angle()
