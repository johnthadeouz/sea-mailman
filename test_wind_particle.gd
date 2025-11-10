@tool
extends CSGSphere3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	horizontal_tween()
	vertical_tween()

func horizontal_tween():
	var tween:Tween = create_tween()
	tween.tween_property(self,"position:x",2.0,4).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT_IN)

func vertical_tween():
	var tween:Tween = create_tween()
	tween.tween_property(self,"position:y",1.0,1.5).set_ease(Tween.EASE_IN)
	tween.tween_property(self,"position:y",0.0,2.0)
