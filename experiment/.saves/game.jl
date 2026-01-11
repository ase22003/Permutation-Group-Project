include("permutations.jl")

GameBoard = Array{Element}

function generate_game_board(dimensions::Vector{Int})::GameBoard
	board = GameBoard(undef, dimensions...)
	for tile ∈ 1:length(board)
		board[tile] = tile
	end
	board
end

function permute_game_board!(game_board::GameBoard, perm::Permutation)::Nothing
	for orbit ∈ perm
		last = game_board[orbit[end]]
		for i ∈ length(orbit)-1:-1:1
			game_board[orbit[i+1]] = game_board[orbit[i]]
		end
		game_board[orbit[1]] = last
	end
end

function generate_set_of_random_permutations(board::GameBoard, include_all_elements::Bool, overlap::Float, size::Float)::SetOfPermutations

end

function scramble_game_board!(game_board::GameBoard, perms::SetOfPermutations, number_of_moves::Int)::GameBoard
	for _ in 1:number_of_moves
		perm = perms[rand(1:length(perms))]
	end
end
