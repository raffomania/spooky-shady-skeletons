extends Label3D
    

# Called every frame. 'delta' is the elapsed time since the previous frame.
func show_countdown():
    billboard = 1
    var countdown_text = "Zzz... "
    for c in countdown_text.length():
        text += countdown_text[c]
        await GlobalClock.beat
        
    
