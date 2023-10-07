extends OmniLight3D
class_name DamageLight

var tween

func _ready():
    light_energy = 0.0

func flash():
    if tween != null:
        tween.stop()
    self.light_energy = 4.0
    tween = create_tween()
    tween.set_trans(Tween.TRANS_QUART)
    tween.tween_property(self, "light_energy", 0.0, 0.4)

