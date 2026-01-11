#=
Functions for handling permutations.

Author: Adrian Swande
Date: 2025-10-21
=#

Element = Int16
Orbit = Vector{Element}
Permutation = Vector{Orbit}
SetOfPermutations = Vector{Permutation}

function generate_game_board(dimensions::Vector{Int})::GameBoard
	board = GameBoard(undef, dimensions...)
	for tile ∈ 1:length(board)
		board[tile] = tile
	end
	board
end

function apply_perm!(game_board::GameBoard, perm::Permutation)
	for orbit ∈ perm
		last = game_board[orbit[end]]
		for i ∈ length(orbit)-1:-1:1
			game_board[orbit[i+1]] = game_board[orbit[i]]
		end
		game_board[orbit[1]] = last
	end
end

function next_element(perm::Permutation, elem::Element)::Element
	for orbit ∈ perm
		index = findfirst(==(elem), orbit)
		if typeof(index) == Nothing
			continue
		end
		if index == length(orbit)
			return orbit[1]
		end
		return orbit[index+1]
	end
	elem
	#throw(ErrorException("(next_element) Element is not included in given perm."))
end

function compose_perms(perms::SetOfPermutations)::Permutation
	new_perm = Permutation()
	for perm ∈ perms
		for orbit ∈ perm
			for elem ∈ orbit
				if !in_perm(new_perm, elem)
					new_orbit = Orbit([elem])
					new_elem = elem
					while true
						for _perm ∈ perms
							new_elem = next_element(_perm, new_elem)
						end
						if new_elem == elem
							break
						end
						push!(new_orbit, new_elem)
					end
					if length(new_orbit) > 1
						push!(new_perm, new_orbit)
					end
				end
			end
		end
	end
	new_perm
end

function cleanup_perm(perm::Permutation)::Permutation
	disintegrated_perm = [[part] for part ∈ perm]
	return compose_perms(disintegrated_perm)
end

function in_perm(perm::Permutation, elem::Element)::Bool
	if perm == []
		return false
	end
	for orbit ∈ perm
		if elem ∈ orbit
			return true
		end
	end
	false
end

function number_of_orbits(perm::Permutation)::Int
	return length(perm)
end

function generate_scramble(perms::SetOfPermutations, number_of_moves::Int64)::Tuple{Any}
	sequence = [rand(1:length(perms)) for _ in 1:number_of_moves]
	perm = compose_perms(SetOfPermutations([perms[i] for i in sequence]))
	(perm, sequence)
end

#=
game_board = generate_game_board([5,5])
display(game_board)
apply_perm!(game_board, Permutation( [[1,2,3],[10,20]] ) )
display(game_board)
=#
#=
a = Permutation([[1,2,3],[4,5,6]])
b = Permutation([[1,3,6],[2,5],[88,99,11]])

ab = compose_perms([a, b])
display(ab)
=#
