extends CanvasLayer

var level_path = {"A" : "res://game_levels/level-A/level-A-1.tscn",
"A3" : "res://game_levels/level-A/level-A-3.tscn",
"B" : "res://game_levels/level-B/level-B-1.tscn",
"B3" : "res://game_levels/level-B/level-B-3.tscn",
"C" : "res://game_levels/level-C/level-C-1.tscn",
"C3" : "res://game_levels/level-C/level-C-3.tscn",
"D" : "res://game_levels/level-D/level-D-1.tscn",
"D2" : "res://game_levels/level-D/level-D-2.tscn",
"E" : "res://game_levels/level-E/level-E-1.tscn",
"F" : "res://game_levels/level-F/level-F-1.tscn",
"F3" : "res://game_levels/level-F/level-F-3.tscn",
"G" : "res://game_levels/level-G/level-G-End.tscn"}

var level_transition_animation = {"res://game_levels/level-A/level-A-1.tscn" : "A",
"res://game_levels/level-B/level-B-1.tscn" : "B",
"res://game_levels/level-C/level-C-1.tscn" : "C",
"res://game_levels/level-D/level-D-1.tscn" : "D",
"res://game_levels/level-E/level-E-1.tscn" : "E",
"res://game_levels/level-F/level-F-1.tscn" : "F",
"res://game_levels/level-G/level-G-End.tscn" : "G"}

var big_coin_total = {"A" : 3, "B" : 3, "C" : 3,
"D" : 3,"E" : 1,"F" : 2,"G" : 3}

var big_coin_curr_total = {"A" : 0, "B" : 0, "C" : 0,
"D" : 0,"E" : 0,"F" : 0,"G" : 0}

var next_level : String
var next_level_label_on : bool
#dictionary that saves coin data as you play, similar to health, it carries on throughout
#the game

var newest_spawn_point : String


var hearts_list : Array[TextureRect]
var default_player_health : int = 3
var curr_coin_count : int = 0
var saved_coin_count : int = 0

#big coin info
var curr_level : String
var curr_big_coin_total : int
var curr_save_point_big_coin_total : int

#for debugging, give this a value, otherwise 0
var player_health : int
@export var curr_health : ProgressBar

var continue_level : bool

var in_main_menu : bool
const course_clear_sound = preload("res://game_levels/level_transition/Retro Magic 34.wav")
@onready var course_clear_music_player = AudioStreamPlayer.new()

@export var health_bar: HBoxContainer
const HEART_WIDTH: int = 128

func _ready() -> void:
	add_child(course_clear_music_player)
	course_clear_music_player.stream = course_clear_sound
	course_clear_music_player.process_mode = Node.PROCESS_MODE_ALWAYS
	for child in health_bar.get_children():
			hearts_list.append(child)

func set_ui_visibility():
	health_bar.visible = !health_bar.visible
	$total_coins.visible = !$total_coins.visible
	$coin_icon.visible = !$coin_icon.visible
	$total_big_coins.visible = !$total_big_coins.visible
	$big_coin.visible = !$big_coin.visible

#pause game
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause"):
		set_ui_visibility()
		$pause_icon.visible = !$pause_icon.visible
		get_tree().paused = !get_tree().paused

func start_of_level_transition() -> void:
	#get_tree().paused = true
	#display_player_health()
	set_ui_visibility()
	$AnimationPlayer.play_backwards("dissolve")
	await $AnimationPlayer.animation_finished
	set_ui_visibility()
	#get_tree().paused = false

func change_scene(target: String) -> void:
	#changing stages
	get_tree().paused = true
	set_ui_visibility()
	$AnimationPlayer.play('dissolve')
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file(target)
	get_tree().paused = false
	$AnimationPlayer.play_backwards("dissolve")
	set_ui_visibility()

#end of level score thing
#display coin and big coin total for a few seconds, then do level transition
#when button is pressed, do level transition -> this will be changed
func level_complete(target: String) -> void:
	next_level = target
	set_ui_visibility()
	get_tree().paused = true
	$AnimationPlayer.play("level_complete")
	await $AnimationPlayer.animation_finished
	#display all of the coin found
	$course_clear.visible = true
	#animation for rainbow course clear text
	course_clear_music_player.play()
	await course_clear_music_player.finished
	$big_coin_complete.visible = true
	$level_complete.visible = true
	$total_big_coin_end_of_level.visible = true
	$next_level_button.visible = true
	next_level_label_on = true

func _on_next_level_button_pressed() -> void:
	$level_transition_images/title_3.visible = false
	level_transition(next_level)

#going from one level to the next. C -> D
func level_transition(target: String) -> void:
	BackgroundMusic.restart_music()
	#Main_DeathScreenMusic.play(0.0)
	$big_coin_complete.visible = false
	$level_complete.visible = false
	$total_big_coin_end_of_level.visible = false
	$next_level_button.visible = false
	get_tree().change_scene_to_file(target)
	#have a singular image, that shows info, then go from there
	#currntly playing example text level loading img
	$AnimationPlayer.play(str(level_transition_animation[target]))
	await $AnimationPlayer.animation_finished
	if get_tree().paused:
		get_tree().paused = false
	set_ui_visibility()
	#how can I make so that the scene appears

func game_over_transition(curr_level: String) -> void:
	#reset coins here based on length of
	BackgroundMusic.fade_music_out_background()
	Main_DeathScreenMusic.restart_music()
	#if newest_spawn_point != null:
		#curr_level = newest_spawn_point
	#await get_tree().create_timer(1.5).timeout
	#Main_DeathScreenMusic.play(0.0)
	var target = level_path[curr_level]
	next_level = target
	$AnimationPlayer.play("game_over")
	await $AnimationPlayer.animation_finished
	#Main_DeathScreenMusic.play(0.0)
	$"Restart Level".visible = true
	continue_level = true
	set_ui_visibility()
	if !get_tree().paused:
		get_tree().paused = true
	#get_tree().change_scene_to_file(target)
	#$AnimationPlayer.play_backwards("game_over")

func game_over_to_level_start(target: String) -> void:
	set_coin_count_after_death()
	get_tree().change_scene_to_file(target)
	$"Restart Level".visible = false
	continue_level = false
	$AnimationPlayer.play("game_restart")
	await $AnimationPlayer.animation_finished
	set_ui_visibility()
	get_tree().paused = false
	get_tree().change_scene_to_file(target)
	Main_DeathScreenMusic.fade_music_out_main_death()
	BackgroundMusic.restart_music()
	#expand on this. only pause and start certain elements at a time
#managing player data
func set_default_player_health():
	#define visibility of hearts
	player_health = default_player_health
	##if hearts_list.size() < 3:
	#for child in health_bar.get_children():
			#hearts_list.append(child)
			#child.visible = true
	for i in range(hearts_list.size()):
		hearts_list[i].visible = true
	return player_health

func set_curr_health(health: int):
	#player_health = health
	#set visibility based on curr health
	#print(player_health)
	#player_health = health
	#print("set curr health: ", health)
	for i in range(hearts_list.size()):
		hearts_list[i].visible = i < player_health
	return player_health

func get_curr_health():
	return player_health
#func display_player_health():
	#$health.text = "Health: " + str(player_health)

func update_coin_count():
	curr_coin_count += 1

func set_coin_count_after_death():
	curr_coin_count = saved_coin_count

func save_curr_coin_count(curr):
	#call this when starting level or touching checkpoint
	saved_coin_count = curr_coin_count

func save_curr_big_coin_count():
	curr_save_point_big_coin_total = big_coin_curr_total[curr_level]

func set_big_coin_count():
	big_coin_curr_total[curr_level] = curr_save_point_big_coin_total

func update_big_coin_count(curr_level):
	big_coin_curr_total[curr_level] += 1

func reset_big_coin_count(curr_level):
	big_coin_curr_total[curr_level] = 0

func pause_during_transfer():
	get_tree().paused = true
	#pause everything expect the star

func main_menu():
	in_main_menu = true

func exit_main_menu():
	in_main_menu = false
	#BackgroundMusic.play(0.0)
	#set_ui_visibility()

func _physics_process(delta: float) -> void:
	#update ui as game progresses
	if not in_main_menu:
		#$health.text = "[b][outline_color=black][outline_size=3][font_size=13]Health: %d[/font_size][/outline_size][/outline_color][/b]" % player_health
		#player_health = clampi(player_health,0,0)
		#hearts_rect.custom_minimum_size.x = player_health * HEART_WIDTH
		$total_coins.text = "[b][color=white][outline_color=black][outline_size=3]X %d[/outline_size][/outline_color][/color][/b]" % curr_coin_count
		$total_big_coins.text = "[b][color=white][outline_color=black][outline_size=3]%d/%d[/outline_size][/outline_color][/color][/b]" % [big_coin_curr_total[curr_level], big_coin_total[curr_level]]
		$total_big_coin_end_of_level.text = "[b][color=white][outline_color=black][outline_size=3]%d/%d[/outline_size][/outline_color][/color][/b]" % [big_coin_curr_total[curr_level], big_coin_total[curr_level]]
	if next_level_label_on:
		if Input.is_action_just_pressed("punch_action"):
			next_level_label_on = false
			$course_clear.visible = false
			$level_transition_images/title_3.visible = false
			level_transition(next_level)
	if continue_level:
		if Input.is_action_just_pressed("punch_action"):
			game_over_to_level_start(next_level)
