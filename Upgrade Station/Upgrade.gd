class_name Upgrade

enum Kind {
    Cake
}

static func description(kind: Kind):
    match kind:
        Kind.Cake:
            return "A cake weapon to smash your enemies"