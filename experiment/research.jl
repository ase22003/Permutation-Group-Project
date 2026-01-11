include("permutations.jl")
include("game.jl")

using Graphs
using TikzGraphs

import TikzPictures

function generate_group_RECURSIVE(generators::SetOfPermutations)
	nodes = SetOfPermutations([IDENTITY])
	edges = Vector{Tuple{Int64, Int64}}()
	edge_gens = Vector{Tuple{Int64, Int64}}()
	i::UInt16 = 0
	function map(node::Permutation)::Nothing; i+=1
		###generators = copy(Set(union(generators, nodes)))
		###pop!(generators, IDENTITY)
		for generator ∈ generators
			new_node = compose_perms(SetOfPermutations([node, generator]))
			if !∈(new_node, nodes) #add node to set of nodes
				push!(nodes, new_node)
				map(new_node)
			end
			edge = (findfirst(==(node), nodes), findfirst(==(new_node), nodes))
			if !∈(edge, edges) #add edge to set of edges, with generator info
				push!(edges, edge)
				push!(edge_gens, (length(edges), findfirst(==(generator), generators)))
			end
		end
	end
	map(IDENTITY)
	println("Recursions: ", i)
	return nodes, edges, edge_gens
end
function generate_group_ITERATIVE(generators::SetOfPermutations) #GPT
	# Initiera grundmängder
	nodes = SetOfPermutations([IDENTITY])
	edges = Vector{Tuple{Int64, Int64}}()
	edge_gens = Vector{Tuple{Int64, Int64}}()
	
	# Arbetslista för utforskning
	worklist = [IDENTITY]
	recursion_counter::UInt64 = 0

	while !isempty(worklist)
		node = pop!(worklist) # motsvarar ett rekursivt återinträde
		recursion_counter += 1

		for generator ∈ generators
			new_node = compose_perms(SetOfPermutations([node, generator]))

			# Om ny nod ej tidigare påträffats, inför den
			if !(new_node ∈ nodes)
				push!(nodes, new_node)
				push!(worklist, new_node)
			end

			# Kanten mellan noderna
			edge = (findfirst(==(node), nodes), findfirst(==(new_node), nodes))

			if !(edge ∈ edges)
				push!(edges, edge)
				push!(edge_gens, (length(edges), findfirst(==(generator), generators)))
			end
		end
		if recursion_counter%100==0
			print(".")
		end
	end

	println("\nIterations: ", recursion_counter)

	return nodes, edges, edge_gens
end
#generate_group = generate_group_RECURSIVE
generate_group = generate_group_ITERATIVE

function get_state_space(group::SetOfPermutations, space::GameBoard)::Vector{GameBoard}
	state_space = Vector{GameBoard}([space])
	for perm ∈ group
		state = permute_game_board(space, perm)
		if !∈(state, state_space)
			push!(state_space, state)
		end
	end
	state_space
end

function inspect_group(generators::SetOfPermutations, dimensions::Vector{Int64})::Nothing
	board = generate_game_board(dimensions)
	println("Board: ")
	display(board)
	for i ∈ 1:length(generators)
		generators[i] = cleanup_perm(generators[i])
	end
	println("Generators: ")
	display(generators)

	print("Exploring group")
	map=generate_group(generators)
	println("Group size: ", length(map[1]))
	display(map[1])
	println("Number of edges: ", length(map[2]))
	#println("Exploring states...")
	#state_space = get_state_space(map[1], board)
	#println("Number of states: ", length(state_space))
	if length(map[1]) < factorial(length(board))
		println("Smaller than permutation set of elements: ",factorial(length(board)))
	end
end

function generate_graph(nodes, edges)::DiGraph
	g = DiGraph()
	add_vertices!(g,length(nodes))
	for edge ∈ edges
		add_edge!(g, edge...)
	end
	g
end

function color_graph(edges, edge_gens, colors, generators::SetOfPermutations, type)
	cds = type
	for geni ∈ 1:length(generators)
		for eg ∈ edge_gens
			if eg[2] == geni
				cds[edges[eg[1]]] = colors[geni]
			end
		end
	end
	cds
end

#{{{
#board = generate_game_board([4,2])

#map=generate_group([ [[1,2,3]],[[1,2]] ])
#map=generate_group([ [[1,2]], [[2,3]], [[1,2,3,4]], [[4,5]], [[4,6]] ])
#map=generate_group([[[1,2,3]], [[4,5,6]], [[7,8,9]],
#					[[1,4,7]], [[2,5,8]], [[3,6,9]]]) #time
#map=generate_group([[[1,2,3]], [[4,5,6]],
#					[[1,4]], [[2,5]], [[3,6]]])
#map=generate_group([[[1,2,3,4]], [[5,6,7,8]],
#					[[1,5]], [[2,6]], [[3,7], [4,8]]]) #time
#map=generate_group([[[1,2,3,4]], [[5,6,7,8]], [[1,5]]]) #time

#map=generate_group([[[1,2,3]], [[5,6,7]], [[1,5]], [[2,6]], [[3,7]]])

#display(map[1])
#display(map[2])
#display(map[3])

#state_space = get_state_space(map[1], board)
#display(state_space)

#println(length(state_space))
#}}}

#inspect_group([[[1,2,3]], [[4,5,6]], [[1,4]]],	[2,3])
#inspect_group([[[1,4,5,2]], [[5,8,6,9]]],	[3,3]) #time
#inspect_group([[[1,4,5,2]], [[5,8,6]]],	[3,3])
#inspect_group([[[1,2],[3,4]], [[2,4,5]]],	[5])

#inspect_group( [[[1,2,3]], [[4,5,6]], [[7,8,9]],
#				[[1,4,7]], [[2,5,8]], [[3,6,9]]], [3,3])#time


#=

#inspect_group([[[1,2,3],[4,5]],[[5,6,7],[1,2]]],	[8])

generators = SetOfPermutations([
	[[1,2,3]],
	[[4,5,6]],
	[[1,4]]
])
inspect_group(generators,[3,2])
exit()

group, edges, edge_gens = generate_group(generators)
println(length(group))
##generators = group[2:end]
##group, edges, edge_gens = generate_group(generators)
#display(group)
graph = generate_graph(group, edges)
#println(graph)
s = [replace(replace(sr[2:end-1], "[" => "(", "]" => ")", "Int64" => "", " " => "", "," => " "), ") ("=>")(") for sr ∈ string.(group)]
colors = color_graph(edges, edge_gens, ["blue","red","green","yellow","purple","cyan","black","gray","lime","pink","lightgray","orange","brown","teal"],generators, Dict())
println(edge_gens)
println(edges)

TikzPictures.save(TikzPictures.PDF("gr"),TikzGraphs.plot(graph,
	#Layouts.SimpleNecklace(),
	s, edge_style="thick",
	edge_styles=colors,
	node_style="draw, rounded corners, fill=green!10")
)

run(`xreader gr.pdf`)

using GLMakie, GraphMakie
using GraphMakie.NetworkLayout

edgecolors = [:black for i in 1:length(edge_gens)]
c = [:blue,:red,:green,:yellow,:cyan,:gray,:lime]
for eg ∈ edge_gens
	edgecolors[eg[1]] = c[eg[2]]
end

#edgecolors = color_graph(edges, edge_gens, [:blue,:red,:green,:yellow], generators, Vector{Any}(undef, length(edges)))

els = ([replace(replace(sr[2:end-1], "[" => "(", "]" => ")", "Int64" => "", " " => "", "," => " "), ") ("=>")(") for sr in [string.(generators)[eg[2]] for eg in edge_gens]])

f, ax, p = graphplot(graph;
	curve_distance=.1,
	curve_distance_usage=true,
	arrow_show=true,
	arrow_shift=0.3,
	arrow_size=30,
	elabels=els,
	#elabels="Edge ".*repr.(1:ne(graph)),
	elabels_distance=20,
	ilabels=s,
	edge_color=edgecolors,
	layout=Stress(; dim=3),
)

=#


#TODO:
#
# - Identify loops from elements and generators (these "generators" can be other permutations in the group, made up by the "user" specified ones (and thus also be the "canonical" generators))
#   draw these loops such that one can compare and such
