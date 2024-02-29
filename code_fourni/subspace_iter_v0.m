% version basique de la méthode de l'espace invariant (v0)

% Données
% A          : matrice dont on cherche des couples propres
% m          : nombre de couples propres que l'on veut calculer
% eps        : seuil pour déterminer si les vecteurs de l'espace invariant
%              ont convergé
% maxit      : nombre maximum d'itérations de la méthode

% Résultats
% V : matrice des vecteurs propres
% D : matrice diagonale contenant les valeurs propres (ordre décroissant)
% it : nombre d'itérations de la méthode
% flag : indicateur sur la terminaison de l'algorithme
%  flag = 0  : on a convergé (on a calculé m valeurs propores)
%  flag = -3 : on n'a pas convergé en maxit itérations

function [ V, D, it, flag ] = subspace_iter_v0( A, m, eps, maxit )

    % calcul de la norme de A (pour le critère de convergence)
    normA = norm(A, 'fro');

    n = size(A,1);

    % indicateur de la convergence
    conv = 0;
    % numéro de l'itération courante
    k = 0;

    % on génère un ensemble initial de m vecteurs orthogonaux
    Q = mgs(A);

    V = Q(:, 1:m);

    % rappel : conv = invariance du sous-espace V : ||AV - VH||/||A|| <= eps
    while (~conv && k < maxit)

        k = k + 1;

        % calcul de Y = A.V
        Y = A*V;

        % calcul de H, le quotient de Rayleigh H = V^T.A.V
        H = V' * Y;

        % vérification de la convergence
        acc = norm(A*V - V*H) / norm(A);
        conv = acc <= eps;

        % orthonormalisation
        V = mgs(Y);

    end

    % décomposition spectrale de H, le quotient de Rayleigh
    [vec_pro, val_pro] = eig(H);
    val_pro = diag(val_pro);

    % on range les valeurs propres dans l'ordre décroissant
    [val_pro,indices] = sort(val_pro, "descend");

    % on permute les vecteurs propres en conséquence
    vec_pro = vec_pro(:, indices);


    % les m vecteurs propres dominants de A sont calculés à partir de ceux de H

    V = V * vec_pro;

    D = diag(val_pro);

    it = k;

    if (conv)
      flag = 0;
    else
      flag = -3;
    end

end
