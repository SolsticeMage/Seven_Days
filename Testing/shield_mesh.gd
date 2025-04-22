# Resources:
#	"Create Mesh with Code: ArrayMesh Basics" [DitzyNinja's Godojo; April 22, 2022]
#	"GodotDocs->Math->VectorMath->CrossProduct->CalculatingNormals"
# Links:
#	https://youtu.be/w9KBxifGYiU
#	https://docs.godotengine.org/en/stable/tutorials/math/vector_math.html#calculating-normals
# Notes for Godot Version 4.4.1:
#	tool is @tool
#	Pool...Array is Packed...Array

@tool
extends MeshInstance3D

var mesh_data = [] #declares mesh_data as array (empty)

func _ready():
	mesh_data.resize(ArrayMesh.ARRAY_MAX) #Resize for Mesh.ArrayType data (enum)
	#All vertex points in the mesh
	mesh_data[ArrayMesh.ARRAY_VERTEX] = PackedVector3Array(
		[
			Vector3(.6,.6,0),	#0
			Vector3(.6,.6,.3),	#1
			Vector3(-.6,.6,.3),	#2
			Vector3(-.6,.6,0),	#3
			Vector3(-.3,-.6,0),	#4
			Vector3(0,-.9,0),	#5
			Vector3(.3,-.6,0),	#6
			Vector3(.3,-.6,.3),	#7
			Vector3(0,-.9,.3),	#8
			Vector3(-.3,-.6,.3)	#9
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
	# If the vertex is part of multiple faces then its normal should be the average of the faces
	#	note: THERE MUST BE A NORMAL FOR EVERY VERTEX otherwise 'add_surface_from_arrays()' breaks.
	#TODO: Write algo to get vertex normals from averages of connected faces from ARRAY_INDEX
	mesh_data[ArrayMesh.ARRAY_NORMAL] = PackedVector3Array(
		[
			get_normalized_average(PackedVector3Array(
				[	#Vertex 0 and all shared faces
					get_triangle_normal(0,1,2),
					get_triangle_normal(0,2,3),
					get_triangle_normal(0,3,4),
					get_triangle_normal(0,4,6),
					get_triangle_normal(0,6,1)
				]
			)),
			get_normalized_average(PackedVector3Array(
				[	#Vertex 1 and all shared faces
					get_triangle_normal(0,1,2),
					get_triangle_normal(0,6,1),
					get_triangle_normal(1,6,7),
					get_triangle_normal(1,7,9),
					get_triangle_normal(1,9,2)
				]
			)),
			Vector3.ZERO,
			Vector3.ZERO,
			Vector3.ZERO,
			Vector3.ZERO,
			Vector3.ZERO,
			Vector3.ZERO,
			Vector3.ZERO,
			Vector3.ZERO
		]
	)
	mesh = ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, mesh_data)

#TODO: Did you just fuckin' do it?
func get_vertex_normal(vertex:int):
	var face_normals = PackedVector3Array()
	for i in mesh_data[ArrayMesh.ARRAY_INDEX].Size():
		if mesh_data[ArrayMesh.ARRAY_INDEX][i] == vertex:
			var first_tri = i - i % 3 #first vertex in the set of 3 vertices used to draw the face
			face_normals.append(get_triangle_normal(first_tri,first_tri+1,first_tri+2))
	return get_normalized_average(face_normals)

func get_vertex(i):
	return mesh_data[ArrayMesh.ARRAY_VERTEX][i]

##Takes three indices in Array_Vertex and returns the facing direction of the resulting triangle
func get_triangle_normal(a:int, b:int, c:int):
	var side1 = get_vertex(b) - get_vertex(a)
	var side2 = get_vertex(c) - get_vertex(a)
	var normal = side2.cross(side1) #Cross product is perpendicular to the surface (normal)
	return normal.normalized()
	
func get_normalized_average(vectors: PackedVector3Array) -> Vector3:
	var sum := Vector3.ZERO
	for vector in vectors:
		sum += vector
	return (sum / vectors.size()).normalized()
