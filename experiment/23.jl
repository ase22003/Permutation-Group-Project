function T2(x,y,R)
	return compose_perms([potentiate_perm(R,-x+1),S,potentiate_perm(R,x-y),S,potentiate_perm(R,-x+y),S,potentiate_perm(R,x-1)])
end
function T1(x,y)
	return compose_perms([potentiate_perm(L,-y+1),potentiate_perm(U,-x+1),S,potentiate_perm(L,y-1),potentiate_perm(U,x-1)])
end


function t2(x,y,R,S)
	conjugation(
		conjugation(potentiate_perm(R,-x+1),S),
		conjugation(potentiate_perm(R,-y+1),S)
	)
end
