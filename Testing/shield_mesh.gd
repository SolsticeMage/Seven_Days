# Inspiration: "Create Mesh with Code: ArrayMesh Basics" [April 22, 2022]
# Attribution: DitzyNinja's Godojo
# Link:        https://youtu.be/w9KBxifGYiU
# Notes:
#	At time of writing (Godot version 4.4.1) 'tool' has been replaced with '@tool'.
#		Furthermore, 'Pool...' arrays have been replaced with 'Packed...' arrays.

@tool
extends MeshInstance3D


func _ready():
	var mesh_data = [] #declares mesh_data as array (empty)
	mesh_data.resize(ArrayMesh.ARRAY_MAX) #Resize for Mesh.ArrayType data (enum)
	#All vertex points in the mesh
	mesh_data[ArrayMesh.ARRAY_VERTEX] = PackedVector3Array(
		[
			Vector3(.6,.6,0),
			Vector3(.6,.6,.3),
			Vector3(-.6,.6,.3),
			Vector3(-.6,.6,0),
			Vector3(-.3,-.6,0),
			Vector3(0,-.9,0),
			Vector3(.3,-.6,0),
			Vector3(.3,-.6,.3),
			Vector3(0,-.9,.3),
			Vector3(-.3,-.6,.3)
		]
	)
	# Selects vertices by index for drawing triangles (3 verts per triangle)
	#	Triangle faces with vertices in clockwise order
	mesh_data[ArrayMesh.ARRAY_INDEX] = PackedInt32Array(
		[
			0,1,2, 0,2,3, 0,3,4, 0,4,6, 4,5,6, 0,6,1, 1,6,7, 5,7,6, 5,8,7, 4,8,5,
			4,9,8, 2,9,3, 3,9,4, 1,7,9, 1,9,2, 9,7,8
		]
	)
	mesh = ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, mesh_data)
