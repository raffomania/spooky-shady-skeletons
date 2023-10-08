extends Label3D

var countdown_running := false

signal countdown_finished

# Called every frame. 'delta' is the elapsed time since the previous frame.
func show_countdown():
    if not is_visible_in_tree(): return
    countdown_running = true
    var countdown_text = "Zzz... "
    for c in countdown_text.length():
        text += countdown_text[c]
        await GlobalClock.beat

        if not countdown_running: return

    # player has chosen this upgrade
    countdown_finished.emit()


func stop_countdown():
    countdown_running = false
    text = ""
