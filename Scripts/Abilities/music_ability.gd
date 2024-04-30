extends Ability

@onready var basic16th = $basic16th
@onready var bass = $bass
@onready var keys = $keys
@onready var melody = $melody
@onready var vibe = $vibe

var play_melody : int
var play_bass : int
var play_vibe : int
var play_basic : int
var play_keys : int

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func execute(args: Dictionary) -> void:
	
	play_melody = args["melody_melee"] as int
	play_bass = args["bass_dash"] as int
	play_vibe = args["vibe_basicProjectile"] as int
	play_basic = args["basic16th_tripleProjectile"] as int
	play_keys = args["keys_movement"] as int
	
	melody.stop()
	basic16th.stop()
	bass.stop()
	keys.stop()
	vibe.stop()
	
	melody.play()
	basic16th.play()
	bass.play()
	keys.play()
	vibe.play()
	
	if(play_melody > 0):
		melody.volume_db = -3
	if(play_bass > 0):
		bass.volume_db = -12
	if(play_vibe > 0):
		vibe.volume_db = -3
	if(play_basic > 0):
		basic16th.volume_db = -9
	if(play_keys > 0):
		keys.volume_db = -12

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if( !basic16th.playing &&
		!bass.playing &&
		!keys.playing &&
		!melody.playing &&
		!vibe.playing):
			
		execute({"melody_melee" = play_melody,
				   "bass_dash" = play_bass, 
				   "vibe_basicProjectile" = play_vibe,
				   "basic16th_tripleProjectile" = play_basic,
				   "keys_movement" = play_keys})
