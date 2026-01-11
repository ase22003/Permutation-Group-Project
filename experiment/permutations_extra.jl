include("permutations.jl")

function conjugation(A::Permutation, B::Permutation) #a'ba
	return compose_perms([A, B, inverse(A)])
end

function commutation(A::Permutation, B::Permutation) #b'a'ba
	compose_perms([conjugation(A,B),inverse(B)])
end
