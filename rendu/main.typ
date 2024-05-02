#import "./template.typ": *

#show: project.with(
  subject: "Calcul Scientifique",
  title: "Projet de Calcul Scientifique",
  authors: ("THEVENET Louis", "SABLAYROLLES Guillaume",),
  date: "Décembre 2023",
  subtitle: "Groupe EF06",
  toc: false,
)
=
==

#figure(caption: "Execution time for different sizes and types of matrices")[
#table(
  columns: 4,
  [Matrix dimension],
  [Matrix type],
  [Exec. time for `eig` (s)],
  [Exec. time for `power_v11`, (s)],
  [$200 times 200$],
  [Type 1],
  [9.000e-02],
  [1.510e+00],
  [$400 times 400$],
  [Type 1],
  [4.000e-02],
  [1.831e+01],
  [$600 times 600$],
  [Type 1],
  [6.000e-02],
  [6.021e+01],
  [$200 times 200$],
  [Type 2],
  [3.000e-02],
  [3.000e-02],
  [$400 times 400$],
  [Type 2],
  [4.000e-02],
  [4.000e-02],
  [$600 times 600$],
  [Type 2],
  [7.000e-02],
  [1.700e-01],
  [$200 times 200$],
  [Type 3],
  [1.000e-02],
  [5.000e-02],
  [$400 times 400$],
  [Type 3],
  [3.000e-02],
  [5.200e-01],
  [$600 times 600$],
  [Type 3],
  [7.000e-02],
  [1.270e+00],
  [$200 times 200$],
  [Type 4],
  [2.000e-02],
  [1.670e+00],
  [$400 times 400$],
  [Type 4],
  [3.000e-02],
  [2.094e+01],
  [$600 times 600$],
  [Type 4],
  [6.000e-02],
  [5.456e+01],
)
]

We can see that the `power_v11` algorithm is generally slower than the `eigen`
function especially for the type 2 and 4 matrices.

==

#figure(caption: "Inner loop of the new algorithm")[
#sourcecode()[
```matlab
nb_it = 1;
norme = norm(beta*v - z, 2)/norm(beta,2);

while(norme > eps && nb_it < maxit)
    beta_old = beta;
    v = z/norm(z, 2);
    z = A*v;
    beta = (v'*z)/(v'*v);
    norme = abs(beta-beta_old)/abs(beta_old);
    nb_it = nb_it + 1;
end
    ```
]

]

#table(
  columns: 4,
  [Matrix dimension],
  [Matrix type],
  [Exec. time for `power_v11`, (s)],
  [Exec. time for `power_v12`, (s)],
  [$200 times 200$],
  [Type 1],
  [1.960e+00],
  [3.200e-01],
  [$400 times 400$],
  [Type 1],
  [1.888e+01],
  [2.660e+00],
  [$600 times 600$],
  [Type 1],
  [5.031e+01],
  [7.070e+00],
  [$200 times 200$],
  [Type 2],
  [1.000e-02],
  [1.000e-02],
  [$400 times 400$],
  [Type 2],
  [7.000e-02],
  [1.000e-02],
  [$600 times 600$],
  [Type 2],
  [ 1.800e-01 ],
  [4.000e-02],
  [$200 times 200$],
  [Type 3],
  [3.000e-02],
  [1.000e-02],
  [$400 times 400$],
  [Type 3],
  [6.100e-01],
  [1.100e-01],
  [$600 times 600$],
  [Type 3],
  [1.270e+00],
  [2.600e-01],
  [$200 times 200$],
  [Type 4],
  [1.530e+00],
  [2.900e-01],
  [$400 times 400$],
  [Type 4],
  [2.113e+01],
  [3.060e+00],
  [$600 times 600$],
  [Type 4],
  [5.914+e01],
  [6.480e+00],
)

We can see that the `power_v12` algorithm is globally faster than the
`power_v11`.

==
The main drawback of the deflated power method is the numerous matrix-vector
products required to compute the eigenvectors as well as the fact that each
iteration compute only one eigenvalue which can be slow if a lot of eigenvalues
are desired.

==
If we apply Algorithm 1 to $m$ vectors, there is no reason for the columns of $V$ to
converge to a base. Each vector will converge toward a different projection of
the dominant eigenvalue.

==
In Algorithm 2, the matrix $H$ is a smaller matrix, with dimension $n times m$,
therefore, even for larger matrices $A$, computing the spectral decomposition of $H$ will
not be computionally expensive.

==

==

#{
  let var(name) = for n in name [#n]
  let ident(lines, level) = {
    for l in lines {
      if (l.len() == 1 and type(l.at(0)) != "array") {
        (h(level) + l.at(0),)
      } else if (l.len() == 2 and type(l.at(0)) != "array") {
        (h(level) + l.at(0), ..ident(l.at(1), level + 1em))
      } else {
        ident(l, level + 1em)
      }
    }
  }
  let stmt(statement) = {
    (statement,)
  }
  let fn(name, content) = {
    enum(
      numbering: "1:",
      strong[function ] + smallcaps[#name],
      ..ident(content, 1em),
    )
  }
  let assign(name, content) = {
    ($#name arrow.l$ + " " + content,)
  }
  let loop(loop_type, condition, content) = {
    (strong(loop_type) + " " + condition + " ", content,)
  }
  let cond(cond_type, condition, content) = {
    (strong(cond_type) + " " + condition + " " + strong("then"), content)
  }

  let anglelr(content) = {
    $lr(angle.l #content angle.r)$
  }

  let input(content) = {
    (strong("Input :") + " " + content,)
  }
  let output(content) = {
    (strong("Output :") + " " + content,)
  }

  let comment(content) = {
    (content,)
  }

  let line(n) = {
    text(stroke: red, weight: "light")[(line #n)]
  }

  fn(
    "Subspace iter v1 (Raleigh-Ritz projection)",
    (
      input($A in RR^(n times n), epsilon, "MaxIter", "PercentTrace"$),
      output(
        $n_"ev"$ + " dominant eigenvectors " + $V_"out"$ + " and the corresponding eigenvalues " + $Lambda_"out"$,
      ),
      comment(
        )[Generate an initial set of m orthonormal vectors $V in RR^(n times m)$; $k = 0$; $"PercentReached" = 0$],
      loop(
        "repeat until ",
        line(52) + $" PercentReached" > "PercentTrace" or n_"ev" = m or k > "MaxIter"$,
        (
          assign(var("k"), $k + 1$),
          stmt("Compute " + $Y$ + " such that " + $Y=A dot V$),
          assign("V", "orthonormalisation of the columns of " + $Y$),
          stmt(
            )[_Rayleigh-Ritz projection_ #line(60) applied on matrix $A$ and orthonormal
            vectors $V$],
          stmt(
            )[_Convergence analysis step_ #line(70) : save eigenpairs that converged and
            update _PercentReached_],
        ),
      ),
    ),
  )
}

==

There is $A in R^(n times n)$, a square matrix, for $A times A$ there are $OO(n³)$ Flops. Since repeating p times the operation, there are $OO(p times n³)$ Flops to compute $A^p$.
After, there is $V in R^(n times m)$ which leads to $OO(p times n³ times m)$ Flops to compute $A^p times V$.

==

==

#figure(caption: "After computing")[
#table(
  columns: 6,
  [Matrix dimension],
  [Matrix type],
  [Iterations for `subspace_iter0`],
  [Iterations for `subspace_iter1`],
  [Iterations for `subspace_iter2`],
  [p ($A^p$)],
  [$200 times 200$],
  [Type 1],
  [2309],
  [263],
  [132],
  [2],
  [$200 times 200$],
  [Type 1],
  [2309],
  [263],
  [88],
  [3],
  [$200 times 200$],
  [Type 1],
  [2309],
  [263],
  [53],
  [5],
  [$200 times 200$],
  [Type 1],
  [2309],
  [263],
  [27],
  [10],
)
]


#let flops(param) = $op("Iterations")(#param)$
#let iter2 = `iter2`

When increasing the value of p to compute $A^p$ in `subspace_iter2`, the number
of flops to compute the results is : Iterations(`iter2`) $tilde.eq #flops(iter2) /p$.
This is due to the eigenvalues of $A^p$ raised to the p power also. Increasing the conditionment of the matrix leading to a faster convergence.

==

The accuracy differs because eigenpairs are computed from the columns of new
matrix V. However, the firsts columns are recalculated at each step, that will
lead to have different approximate size for the new eigenpairs computed. By
recomputing them, the quality reduces and diverge from the approximate size of
the first one.

==

By freezing the converged columns, the algorithm will not have to recalculate
them everytime. Which means that the accuracy for the eigenpairs will be more
equal. The first and last will have the same approximate size.

=

==
$Sigma_k$ is of size $(k,k)$

$U_k$ is of size $(q,k)$

$V_k$ is of size $(p,k)$

==
#let methods = ("eig", "power", "subspace_iter0", "subspace_iter1", "subspace_iter2")
#let display-variations(eps, maxit, search-space, percentage, puiss) = table(
  columns: 2,
  [eps],
  [#eps],
  [maxit],
  [#maxit],
  [search_space],
  [#search-space],
  [percentage],
  [#percentage],
  [puiss],
  [#puiss],
)

#let variations = ("_differences1": display-variations($10^(-8)$, $10000$, $400$, $0.995$, $1$), "_differences3": display-variations($10^(-8)$, $3000$, $500$, $0.995$, $1$)
)

#for variation in variations.keys() {
  grid(columns: 2, gutter: 5pt, variations.at(variation), ..methods.map(m =>
  figure(caption: m + " method")[
    #image("./assets/" + m + variation + ".svg", width: 110%)
  ]))
}

We might had an issue when calculating the RMSE with the eig function.
Despite this error, we can see that using different method or changing the parameter do not affect the style of the curve.

In the first part when reconstructing the comic, we saw that the image definition looks like more and more of the original when reconstructing it for k increasing.

However, at a certain point, the RMSE tend to have little variation for some k values (less than $1/2 times 10⁴$ between $k = 60$ and $k = 80$). But what is impacted is the time for computation, taking more time when k improve.