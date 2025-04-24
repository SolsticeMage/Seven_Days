# Author: SolsticeMage
# References:
#	"Create Mesh with Code" [DitzyNinja's Godojo; April 22, 2022]
#	"godot_docs->math->vector_math->cross_product->calculating_normals"
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
	mesh_data.resize(ArrayMesh.ARRAY_MAX) #Resize to fit Mesh.ArrayType enum
	#All vertex points in the mesh
	mesh_data[ArrayMesh.ARRAY_VERTEX] = PackedVector3Array([
		Vector3(.6,.6,0),	#0
		Vector3(.6,.6,.3),	#1
		Vector3(-.6,.6,.3),	#2
		Vector3(-.6,.6,0),	#3
		Vector3(-.3,-.6,0),	#4
		Vector3(0,-.9,0),	#5
		Vector3(.3,-.6,0),	#6
		Vector3(.3,-.6,.3),	#7
		Vector3(0,-.9,.3),	#8
		Vector3(-.3,-.6,.3),#9
	])
	# Selects vertices by index for drawing triangles (3 verts per triangle)
	#	The visible face is the side where its vertices are in clockwise order
	mesh_data[ArrayMesh.ARRAY_INDEX] = PackedInt32Array([
		0,1,2, 0,2,3, 0,3,4, 0,4,6, 4,5,6, 0,6,1, 1,6,7, 5,7,6,
		5,8,7, 4,8,5, 4,9,8, 2,9,3, 3,9,4, 1,7,9, 1,9,2, 9,7,8,
	])
	# A vertex normal is the average of all connected faces' normals
	#	ALL VERTICES MUST HAVE NORMALS or error 'Invalid format for surface'
	mesh_data[ArrayMesh.ARRAY_NORMAL] = PackedVector3Array([
		#get_normalized_average(PackedVector3Array([	#Vertex 0 and its faces
			#get_triangle_normal(0,1,2),
			#get_triangle_normal(0,2,3),
			#get_triangle_normal(0,3,4),
			#get_triangle_normal(0,4,6),
			#get_triangle_normal(0,6,1),
		#])),
		#get_normalized_average(PackedVector3Array([#Vertex 1 and its faces
			#get_triangle_normal(0,1,2),
			#get_triangle_normal(0,6,1),
			#get_triangle_normal(1,6,7),
			#get_triangle_normal(1,7,9),
			#get_triangle_normal(1,9,2),
		#])),
		get_vertex_normal(0),
		get_vertex_normal(1),
		get_vertex_normal(2),
		get_vertex_normal(3),
		get_vertex_normal(4),
		get_vertex_normal(5),
		get_vertex_normal(6),
		get_vertex_normal(7),
		get_vertex_normal(8),
		get_vertex_normal(9)
	])
	mesh = ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, mesh_data)
	for i in mesh_data[ArrayMesh.ARRAY_VERTEX].size():
		print("#", i, ": ")
		print("Vertex: ", mesh_data[ArrayMesh.ARRAY_VERTEX][i])
		print("Normal: ", mesh_data[ArrayMesh.ARRAY_NORMAL][i], "\n")

## Returns the normal from the mesh data for the given vertex
func get_vertex_normal(vertex:int):
	var face_normals = PackedVector3Array()
	var indices = mesh_data[ArrayMesh.ARRAY_INDEX]
	var vertices = mesh_data[ArrayMesh.ARRAY_VERTEX]
	
	#TODO: You fucked up again. Find out where, and fix.
	# Iterate through indices to find the provided vertex
	for i in indices.size():
		if indices[i] == vertex:
			# Find the index of the first vertex in its triangle (set of 3)
			var first_triangle_vert = i - i % 3
			# Append the normal of the triangle face
			face_normals.append(
					get_face_normal(
					vertices[indices[first_triangle_vert]],
					vertices[indices[first_triangle_vert+1]],
					vertices[indices[first_triangle_vert+2]])
					)
			# Jump to the first vertex in the next triangle
			if first_triangle_vert+3 < indices.size():
				i = first_triangle_vert+3
			else: break
	return get_normalized_average(face_normals)


##Takes three vectors and returns the facing direction of the resulting triangle
func get_face_normal(a:Vector3, b:Vector3, c:Vector3)->Vector3:
	var side1 = b - a
	var side2 = c - a
	var normal = side2.cross(side1) #Cross product is perpendicular to surface
	return normal.normalized()


func get_normalized_average(vectors:PackedVector3Array)->Vector3:
	var sum := Vector3.ZERO
	for vector in vectors:
		sum += vector
	return (sum / vectors.size())
