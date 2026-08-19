<style>
    p, ul, li {
        font-size: 26px;
        color: #000000;
    }
</style>

# On Grimories

By Adrian Swande

![bg right:40% 80%](frieren.png)

---

# Research Question

> "What is the process by which methods (for solving problems) are found?"

- *Problems* are solved by finding their *solutions*.
- *Solutions* are found by employing *methods*.
- *Methods* exist within *predictable universes*.
- *general methods* exist within *generalizable universes*.

So we need, firstly, a predictable world in which our problems can be represented.

---

# Preliminaries: Groups

A *group* is a set of elements $G$ and a binary operator $*$ where the following conditions hold:

- *Closure*: $\forall [a,b] \in G^2 \ (a*b\in G)$
- *Associativity*: $\forall [a,b,c] \in G^3 \ ((a*b)*c=a*(b*c))$
- *Existence of Identity*: $\exists \varepsilon \in G\ (a\in G \implies a*\varepsilon = \varepsilon*a= a)$
- *Existence of Inverse*: $a\in G\implies \exists a^{-1} \in G\ (a^{-1}*a=\varepsilon)$

---

So, now we have a world in which to conduct our experiments.

We still haven't defined the term "problem", though...

---

# Problems

I define a *problem* (within a predictable world) as a combination of two things:

- *Set of Actions*: A set $M$ of *actions*, that is, functions from one world state to another. So if $f\in M$, then $f(s)=s'$, where $s\in S$, and $S$ is the set of all states of the world.
- *Goal*: A *goal* is a desirable world state $s\in S$.

A *solution* is then an ordered list of actions $[f_1, f_2,\cdots, f_n]$ such that $f_1\circ f_2\circ\cdots\circ f_n = s_0 \mapsto s_g$, where $s_0$ is our starting point, and $s_g$ is our goal state.

---

![bg center:45% 45%](game0.png)

---

![bg center:45% 45%](game.png)

---

# Problems in Groups

What, then, is a *problem* in a group $G$, $*$?

- *States* are elements in $G$. So the *goal* is an elements $g\in G$.
- *Actions* are functions $x \mapsto a*x$, where $a\in G$.

Therefore a *solution* is a list 

$[x \mapsto a_1*x, x \mapsto a_2*x,\cdots, x \mapsto a_n*x]$

such that 

$(x \mapsto a_1*x)\circ( x \mapsto a_2*x)\circ\cdots\circ (x \mapsto a_n*x)=x\mapsto g$. 

So if we say that the set of actions $M$ is a subset of $G$ and that the initial state is $\varepsilon$, then we can reduce the notation to just 

$a_2*\cdots*a_n=g$.

---

# Free Exploration

How do we, then, find methods?

We start by *freely exploring* the group using our provided repertoire of actions:

Let $M=\{a,b\}$. Let's try a combination!

$a*b=c$.

And now we know $[a,b]$ is a solution to $d$. We can now add $c$ to our repertoire, since we now know how to go to $d$ using $M$. So we can try another combination

$c*b=d$

and get the solution for $d$, since we can just expand $c$ like this: $c*a=a*b*b=d$. So the solution for $d$ becomes $[a,b,b]$.

---

# Free Exploration (2)

What if we find the same elements in different ways?

Say that

$b*a=d$

Then we have *two* methods for $d$, namely $\{[a,b,b],[b,a]\}$. If we find that $b*c=a$, then we have an infinite set of solutions for $d$, since $a$ can be expanded from $[b,c]$ to $[b,a,b]$, which can be expanded to $[b,b,c,b]$ and $[b,b,a,b,b]$ and so on.

---

# Method as Grammar

---
