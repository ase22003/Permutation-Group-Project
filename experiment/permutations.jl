#=
Functions for handling permutations.

Author: Adrian Swande
Date: 2025-10-21
=#

Element = Int64
Orbit = Vector{Element}
Permutation = Vector{Orbit}
SetOfPermutations = Vector{Permutation}

IDENTITY = Permutation([[]])

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
	if new_perm == []
		new_perm = IDENTITY
	end
	format_perm(new_perm)
end

function cleanup_perm(perm::Permutation)::Permutation
	disintegrated_perm = [[part] for part ∈ perm]
	return compose_perms(disintegrated_perm)
end

function get_perm_elements(perm::Permutation)::Vector{Element}
	if perm == IDENTITY
		return perm
	end
	elements = Orbit()
	for orbit ∈ perm
		for elem ∈ orbit
			if !∈(elem, elements)
				push!(elements, elem)
			end
		end
	end
	elements
end

function in_perm(perm::Permutation, elem::Element)::Bool
	elem ∈ get_perm_elements(perm)
end

function number_of_orbits(perm::Permutation)::Int
	return length(perm)
end

function generate_scramble(perms::SetOfPermutations, number_of_moves::Int64)::Tuple{Permutation, Vector{Int64}}
	sequence = [rand(1:length(perms)) for _ in 1:number_of_moves]
	perm = compose_perms(SetOfPermutations([perms[i] for i in sequence]))
	(perm, sequence)
end

function format_perm(perm::Permutation)
	if perm == IDENTITY
		return IDENTITY
	end
	
	elems = get_perm_elements(perm)
	new_perm = Permutation()
	
	#sort orbits
	sorted = sort(elems)
	for elem ∈ sorted
		for orbit ∈ perm
			if elem ∈ orbit && !∈(orbit, new_perm)
				push!(new_perm, copy(orbit))
			end
		end
	end

	#translate the elements in the orbits
	for orbit ∈ new_perm
		while minimum(orbit) != orbit[1]
			last = orbit[end]
			for i ∈ length(orbit)-1:-1:1
				orbit[i+1] = orbit[i]
			end
			orbit[1] = last
		end
	end

	new_perm
end

function potentiate_perm(perm::Permutation, exponent::Int64)::Permutation
	if perm == IDENTITY
		return IDENTITY
	end
	exponent = mod(exponent, order(perm))
	if exponent == 0
		return IDENTITY
	end
	positive::Bool = true
	if exponent < 0
		positive = false
		exponent = -exponent
	end
	composition = SetOfPermutations()
	for i ∈ 1:exponent
		push!(composition, perm)
	end
	if positive
		return compose_perms(composition)
	else
		return perm_inverse(compose_perms(composition))
	end
end

function order(perm::Permutation)::Int64
	lengths::Vector{Int64} = []
	for orbit ∈ cleanup_perm(perm)
		push!(lengths, length(orbit))
	end
	return lcm(lengths)
end

function inverse(perm::Permutation)::Permutation
	return potentiate_perm(perm, order(perm)-1)
end
