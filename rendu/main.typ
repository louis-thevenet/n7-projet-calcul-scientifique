#import "./template.typ": *

#show: project.with(
  subject: "Calcul Scientifique",
  title: "Projet de Calcul Scientifique",
  authors: ("THEVENET Louis", "SABLAYROLLES Guillaume",),
  date: "Décembre 2023",
  subtitle: "Groupe EF06",
  toc:false
)

=
#figure(caption: "Execution time for "+ $n=200$)[
#table(columns: 2,
[Algorithm],[Execution time (s)],
[`power_v11`],[$0.1200$],
[`eig`],[1.480])
]
