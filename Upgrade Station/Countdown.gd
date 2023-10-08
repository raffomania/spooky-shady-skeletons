extends Label3D

var countdown_running := false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func show_countdown():
    countdown_running = true
    var countdown_text = "Zzz... "
    for c in countdown_text.length():
        text += countdown_text[c]
        await GlobalClock.beat

        if not countdown_running: return


func stop_countdown():
    countdown_running = false
    text = ""
