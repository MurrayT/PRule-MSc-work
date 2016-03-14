---
papersize: a4
documentclass: amsart
<!-- header-includes:
    -  -->
---
#Complete Classification of equivalence classes of a Length 2 Mesh pattern and a\
length 3 Classical pattern

\newcommand{\Av}[1]{\text{Av}(#1)}
\newcommand{\powset}[1]{\mathcal{P}(#1)}
\newcommand{\size}[1]{\left|#1\right|}
\newcommand{\addp}[2]{\mathtt{add\_point}(#1, #2)}
\newcommand{\addi}[2]{\mathtt{add\_increase}(#1, #2)}
\newcommand{\addd}[2]{\mathtt{add\_decrease}(#1, #2)}
\newcommand{\perm}[1]{\left[#1\right]}

It can easily be seen that in order to classify set equivalences one need only
consider coincidences within the family of mesh patterns with the same underlying
classical pattern, this is due to the fact that $[2\ 1]\in\Av{([1\ 2],R)}$
and $\perm{1\ 2}\in\Av{([2\ 1],R)}$ for all mesh-sets $R$. So
$\Av{([1\ 2],R)} \setminus \Av{([2\ 1],S)} \neq \emptyset\ \forall
R,S\in\powset{\{0,1,2\}\times\{0,1,2\}}$, and hence the sets are disjoint.
We know that there are a total of $512$ mesh-sets for each underlying classical
pattern. By use of the shading lemma, simultaneous shading lemma, and
one special case, we can reduce the number of equivalence classes to $220$.

For the length 3 pattern we need only consider the patterns $[2\ 3\ 1]$ and
$[3\ 2\ 1]$. In order to obtain the other 4 classical patterns of length 4 we
can take complements and reverses of the results obtained for $[2\ 3\ 1]$.
These patterns are chosen because they classify permutations which are stack
sortable and those which are queue sortable.

##Equivalence classes of $\Av{\{([3\ 2\ 1],\emptyset),([2\ 1],R)\}}$
Through experimentation we discover that there are 29 set equivalence classes.



\begin{definition}{***Definition 1:*** *First Dominating pattern rule.*}
Given two mesh patterns $m_1 = (\sigma,R_1)$ and $m_n = (\sigma,R_n)$, and
a dominating classical pattern $\pi = (\pi,\emptyset)$ such that $\size{\pi} \le \size{\sigma} + 1$, the
sets $\Av{\{\pi, m_1\}}$ and $\Av{\{\pi, m_n\}}$ are coincident if

1. There is a single box in one of $R_1,R_n$ that is not in the other.
2. Placing a point in this box would cause an occurrence of $\pi$.

<!--  -->

1. $R_1 \triangle R_n = \{(a,b)\}$
2. $\pi \preceq \addp{\sigma}{(a,b)}$

or there exists a chain $m_1,m_2,\dots,m_n$ where each successive pattern is
linked by these conditions.
\end{definition}

This rule completely explains the Equivalence classes of $\Av{\{([3\ 2\ 1],\emptyset),([2\ 1],R)\}}$.

##Equivalence classes of $\Av{\{([2\ 3\ 1],\emptyset),([2\ 1],R)\}}$
Through experimentation we discover that there are 39 set equivalence classes.
It would be hoped that all of these are explained by the First Dominating pattern
rule, however by applying the rule we obtain 43 classes. We therefore deduce that
we require a more powerful rule to fully explain the set coincidences.

***Definition 2:*** *Second Dominating pattern rule.* Given two mesh patterns $m_1 = (\sigma,R_1)$ and $m_n = (\sigma,R_n)$, and
a dominating classical pattern $\pi = (\pi,\emptyset)$ such that $\size{\pi} \le \size{\sigma} + 1$, the
sets $\Av{\{\pi, m_1\}}$ and $\Av{\{\pi, m_n\}}$ are coincident if

1. There is a single box in one of $R_1,R_n$ that is not in the other.
2. Placing an increase or decrease in this box would cause an occurrence of $\pi$.
3. A point can slide up, or down, the decrease, or increase in the box.
4. There is a box free for the remainder of the points to slide into.

<!--  -->

1. $R_1 \ominus R_n = \{(a,b)\}$
2. If $\pi \preceq \addi{\sigma}{(a,b)}$ then:
    - weird index chasing

    or $\pi \preceq \addd{\sigma}{(a,b)}$
    - more weird index chasing

or there exists a chain $m_1,m_2,\dots,m_n$ where each successive pattern is
linked by these conditions.

This rule along with the First Dominating Pattern rule completely explains the Equivalence classes of $\Av{\{([2\ 3\ 1],\emptyset),([2\ 1],R)\}}$.

##Equivalence classes of $\Av{\{([2\ 3\ 1],\emptyset),([1\ 2],R)\}}$

After application of both rules there are 3 unexplained coincidences. These all
follow a similar explanation as shown..
