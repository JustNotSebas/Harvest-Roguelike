extends CharacterBody2D

@export var speed := 120.0
@export var max_health := 3
@export var damage := 1
@export var attack_cooldown := 1.0

var health: int
var player: Node2D
var attack_timer := 0.0

@onready var sprite: AnimatedSprite2D = $Sprite2D
@onready var hitbox: Area2D = $HitBox

func _ready() -> void:
	add_to_group("enemy")
	health = max_health
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta: float) -> void:
	if player == null or not is_instance_valid(player):
		return

	var dir := (player.global_position - global_position).normalized()
	velocity = dir * speed
	move_and_slide()

	sprite.flip_h = dir.x < 0

	attack_timer -= delta
	if attack_timer <= 0.0:
		for body in hitbox.get_overlapping_bodies():
			if body.is_in_group("player") and body.has_method("take_damage"):
				body.take_damage(damage)
				attack_timer = attack_cooldown
				break

func take_damage(amount: int) -> void:
	health -= amount
	flash()
	if health <= 0:
		die()

func flash() -> void:
	sprite.modulate = Color.RED
	var t := create_tween()
	t.tween_property(sprite, "modulate", Color.WHITE, 0.1)

func die() -> void:
	queue_free()
