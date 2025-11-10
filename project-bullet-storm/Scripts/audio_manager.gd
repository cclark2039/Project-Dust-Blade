# AudioManager.gd
extends Node

@onready var sound_players = $SoundPlayers
@onready var music_player = $MusicPlayer

func _ready():
	# Create audio players
	var sound_players_node = Node.new()
	sound_players_node.name = "SoundPlayers"
	add_child(sound_players_node)
	
	var music_player_node = AudioStreamPlayer.new()
	music_player_node.name = "MusicPlayer"
	add_child(music_player_node)

func play_sound(sound_path: String, volume: float = 0.0) -> void:
	var sound = load(sound_path)
	if sound:
		var player = AudioStreamPlayer.new()
		sound_players.add_child(player)
		player.stream = sound
		player.volume_db = volume
		player.play()
		await player.finished
		player.queue_free()

func play_music(music_path: String, volume: float = 0.0) -> void:
	var music = load(music_path)
	if music:
		music_player.stream = music
		music_player.volume_db = volume
		music_player.play()

func stop_music() -> void:
	music_player.stop()
