extends Node3D

const world_size: int = 40
var rng = RandomNumberGenerator.new()
var dungeon_floor_scene : Resource
var dungeon_floor_detailed_scene : Resource
var dungeon_floor_miscs: Array[Resource]
var stone_wall_scene: Resource
var stone_wall_damaged_scene: Resource
# A array of all border items.
# For now we don't do anything with it, but we might do so lateron.
var border_elements: Array[Node3D]

# The actual world grid.
# It's a nested 2d grid, where each entry represents a single tile.
# The dictionary has this structure:
# Dictionary<Int, Dictionary<Int, Dictionary<Tile>>>>
# grid[x_coordinate][z_coordinate] = Tile;
#
# This is not an Array, since we have to handle negative indices, which an Array cannot do.
var grid: Dictionary = {}

func _ready():
    # Subscribe to the map generation event.
    GlobalSignals.new_level_chosen.connect(func(_upgrade): generate_map())

    # Preload scenes
    dungeon_floor_scene = preload("res://World/DungeonFloor.tscn")
    dungeon_floor_detailed_scene = preload("res://World/DungeonFloorDetailed.tscn")
    dungeon_floor_miscs.append(preload("res://World/DungeonFloorCandles.tscn"))
    dungeon_floor_miscs.append(preload("res://World/DungeonFloorDebris.tscn"))
    dungeon_floor_miscs.append(preload("res://World/DungeonFloorGravestone.tscn"))
    dungeon_floor_miscs.append(preload("res://World/DungeonFloorGravestoneBroken.tscn"))
    dungeon_floor_miscs.append(preload("res://World/DungeonFloorLantern.tscn"))

    stone_wall_scene = preload("res://World/StoneWall.tscn")
    stone_wall_damaged_scene = preload("res://World/StoneWallDamaged.tscn")

    rng.seed = hash(Time.get_time_string_from_system())

    # Generate the map borders once at the start of the game.
    # These won't be removed or regenerated lateron (for now).
    generate_borders()

    # Generate the map tiles at the start of the game.
    generate_map()


var timer = 0
func _process(delta):

    timer += delta

    if timer > 10:
        # Constantly regenerate maps for debugging
        #generate_map()
        timer = 0

    pass

func generate_map():
    print("Generating new map!")

    # Reset a previously generated map.
    reset_map()

    # Build a new seed every time we generate a map, based on the current system time.
    rng.seed = hash(Time.get_time_string_from_system())
    # Generate a 100*100 tile grid plane around the world center.
    var lower_border = int(floor(-world_size/2.0))
    var upper_border = int(floor(world_size/2.0)) + 1
    for x in range(lower_border, upper_border):
        for z in range(lower_border, upper_border):
            # Create a detailed tile every so often
            var tile_resource: Node3D
            var random = rng.randf_range(0, 1)
            if random < 0.10:
                tile_resource = dungeon_floor_detailed_scene.instantiate()
            elif rng.randf_range(0, 1) < 0.03:
                # 3% chance for special floor
                # Choose one of our random misc floors
                tile_resource = dungeon_floor_miscs[randi() % dungeon_floor_miscs.size()].instantiate()
            else:
                tile_resource = dungeon_floor_scene.instantiate()

            tile_resource.position.x += x
            tile_resource.position.z += z
            add_child(tile_resource)

            if grid.get(x) == null:
                grid[x] = {}

            grid[x][z] = Tile.new(tile_resource)


# Clean a previously generated map
func reset_map():
    print("Removing old map!")

    # Remove and free all child tiles
    for z_items in grid.values():
        for tile in z_items.values():
            remove_child(tile.resource)
            tile.resource.queue_free()

    # Reset the grid
    grid = {}

func generate_borders():
    print("Generating map borders!")

    # Reset a previously generated map.
    reset_map()

    # Build a new seed every time we generate a map, based on the current system time.
    rng.seed = hash(Time.get_time_string_from_system())

    # Generate a 100*100 tile grid plane around the world center.
    var lower_border = int(floor(-world_size/2.0))
    var upper_border = int(floor(world_size/2.0)) + 1

    # Damaged walls should always come in pairs.
    var next_x_wall_damaged: bool = false;
    for x in [lower_border, upper_border-1]:
        for z in range(lower_border, upper_border):
            var wall;
            if next_x_wall_damaged:
                # The previous wall was damaged, also have the next one damaged
                wall = stone_wall_damaged_scene.instantiate()
                wall.rotate_y(PI)
                wall.position.x -= 0.9
                next_x_wall_damaged = false
            elif z == lower_border || (z >= upper_border - 2):
                # Corner cases must always be full walls
                wall = stone_wall_scene.instantiate()
            elif rng.randf_range(0, 1) < 0.1:
                # 1 in 10 walls are broken
                wall = stone_wall_damaged_scene.instantiate()
                next_x_wall_damaged = true
            else:
                wall = stone_wall_scene.instantiate()

            wall.rotate_y(PI/2)
            wall.position.x += x
            wall.position.z += z

            # The borders at the right also need to moved one tile to the right.
            if x == (upper_border - 1):
                wall.position.x += 1

            add_child(wall)
            border_elements.append(wall)

    # Damaged walls should always come in pairs.
    var next_z_wall_damaged: bool = false;
    # Generate upper and lower borders
    for z in [lower_border, upper_border-1]:
        for x in range(lower_border, upper_border):
            var wall;
            if next_z_wall_damaged:
                # The previous wall was damaged, also have the next one damaged
                wall = stone_wall_damaged_scene.instantiate()
                next_z_wall_damaged = false
            elif x == lower_border || (x >= upper_border - 2):
                # Corner cases must always be full walls
                wall = stone_wall_scene.instantiate()
            elif rng.randf_range(0, 1) < 0.1:
                # 1 in 10 walls are broken
                wall = stone_wall_damaged_scene.instantiate()
                wall.rotate_y(PI)
                wall.position.z -= 0.90
                next_z_wall_damaged = true
            else:
                wall = stone_wall_scene.instantiate()

            wall.position.x += x
            wall.position.z += z

            # The borders at the bottom also need to moved one tile to the bottom.
            if z == (upper_border - 1):
                wall.position.z += 1

            add_child(wall)
            border_elements.append(wall)
