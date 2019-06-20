extends Node

export (PackedScene) var Mob
var score
var totalRuntime
const mobGroup = "mobs"

func _ready():
	randomize()

func new_game():
	score = 0
	totalRuntime = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.show_message("Get Ready")
	$HUD.update_score(score)
	$HUD.update_runtime(totalRuntime)

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.game_over()
	# free all Mob nodes
	get_tree().call_group(mobGroup, "queue_free")

func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

func _on_ScoreTimer_timeout():
	# TODO(endorphins) make some sort of difficulty so score can be dynamically updated
	score += $ScoreTimer.wait_time
	# score timer is based in seconds, but we want to keep track of runtime in millis
	totalRuntime += 1000 * $ScoreTimer.wait_time
	$HUD.update_score(score)
	$HUD.update_runtime(totalRuntime)

func _on_MobTimer_timeout():
	$MobPath/MobSpawnLocation.set_offset(randi())
	var mob = Mob.instance()
	mob.add_to_group(mobGroup)
	add_child(mob)
	var direction = $MobPath/MobSpawnLocation.rotation + (PI/2) + rand_range(PI/4, -PI/4)
	mob.position = $MobPath/MobSpawnLocation.position
	mob.rotation = direction
	mob.set_linear_velocity(Vector2(rand_range(mob.MIN_SPEED, mob.MAX_SPEED), 0).rotated(direction))
