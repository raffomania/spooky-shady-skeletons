class_name Upgrade

enum Kind {
    Cake,
    Speed,
    DashCooldown,
    Donut,
    BurgerDamage,
}

static func description(kind: Kind):
    match kind:
        Kind.Cake:
            return "A cake weapon to smash your enemies"
        Kind.Speed:
            return "10% more speed to make you blazingly fast"
        Kind.DashCooldown:
            return "Shorten dash cooldown by 25%"
        Kind.Donut:
            return "A circling donut weapon"
        Kind.BurgerDamage:
            return "Double damage for your burger"

static func can_get_upgrade(obtained_upgrades: Array[Kind], new_upgrade: Kind) -> bool:
    match new_upgrade:
        Kind.Speed, Kind.DashCooldown, Kind.Donut, Kind.BurgerDamage:
            return true
        _:
            return not obtained_upgrades.has(new_upgrade)