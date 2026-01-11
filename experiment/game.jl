#=
Functions for handling a "real" game.

Author: Adrian Swande
Date: 2025-10-21
=#


include("permutations.jl")

GameBoard = Array{Element}

function generate_game_board(dimensions::Vector{Int})::GameBoard
	board = GameBoard(undef, dimensions...)
	for tile ∈ 1:length(board)
		board[tile] = tile
	end
	board
end

function permute_game_board(game_board::GameBoard, perm::Permutation)::GameBoard
	game_board=copy(game_board)
	if perm == IDENTITY
		return game_board
	end
	for elem ∈ get_perm_elements(perm)
		if !∈(elem, game_board)
			throw(ErrorException("Permutation contains elements which are not included in the game board"))
		end
	end
	for orbit ∈ perm
		last = game_board[orbit[end]]
		for i ∈ length(orbit)-1:-1:1
			game_board[orbit[i+1]] = game_board[orbit[i]]
		end
		game_board[orbit[1]] = last
	end
	game_board
end

function generate_set_of_random_permutations(board::GameBoard, include_all_elements::Bool, overlap::Float16, size::Float16)::SetOfPermutations

end

function scramble_game_board!(game_board::GameBoard, perms::SetOfPermutations, number_of_moves::Int)::GameBoard
	permute_game_board!(game_board, generate_scramble(perms, number_of_moves))
end
