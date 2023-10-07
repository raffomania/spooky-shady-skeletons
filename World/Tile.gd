class_name Tile

# This class represent a single tile on the Grid.
# It's a class to allow easier extension in case we want to
# add obstacles based on tiles.

var position: Vector3
# The actual resource that's associated with this tile
var resource: Node3D


func _init(init_resource: Node3D):
    self.resource = init_resource
