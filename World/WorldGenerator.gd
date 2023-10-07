extends Node3D

const world_size: int = 50
var rng = RandomNumberGenerator.new()
var dungeon_floor_scene : Resource
var dungeon_floor_detailed_scene : Resource
# A array of all boundary items.
# For now we don't do anything with it, but we might do so lateron.
var boundaries: Array[Resource]

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
    GlobalSignals.connect("generate_map", generate_map)
    dungeon_floor_scene = preload("res://World/DungeonFloor.tscn")
    dungeon_floor_detailed_scene = preload("res://World/DungeonFloorDetailed.tscn")

    # Generate the map boundaries once at the start of the game.
    # These won't be removed or regenerated lateron (for now).
    # generate_map_boundary()

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
    print("Generating New Map!")

    # Reset a previously generated map.
    reset_map()

    # Build a new seed every time we generate a map, based on the current system time.
    rng.seed = hash(Time.get_time_string_from_system())
    # Generate a 100*100 tile grid plane around the world center.
    var lower_boundary = int(floor(-world_size/2.0))
    var upper_boundary = int(floor(world_size/2.0)) + 1
    for x in range(lower_boundary, upper_boundary):
        for z in range(lower_boundary, upper_boundary):
            # Create a detailed tile every so often
            var tile_resource: Node3D
            var random = rng.randf_range(0, 1)
            if random < 0.10:
                tile_resource = dungeon_floor_detailed_scene.instantiate()
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
