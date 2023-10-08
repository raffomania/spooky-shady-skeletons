class_name Upgrade

enum Kind {
    Cake,
    Speed
}

static func description(kind: Kind):
    match kind:
        Kind.Cake:
            return "A cake weapon to smash your enemies"
        Kind.Speed:
            return "10% more speed to make you blazingly fast"