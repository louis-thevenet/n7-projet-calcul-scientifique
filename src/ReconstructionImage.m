
%%  Application de la SVD : compression d'images

clear all
close all

% Lecture de l'image
I = imread('BD_Asterix_1.png');
I = rgb2gray(I);
I = double(I);

[q, p] = size(I)

% Décomposition par SVD
fprintf('Décomposition en valeurs singulières\n')
tic
[U, S, V] = svd(I);
toc

l = min(p,q);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% On choisit de ne considérer que 200 vecteurs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %vecteur pour stocker la différence entre l'image et l'image reconstruite
% inter = 1:40:(200+40);
% inter(end) = 200;
% differenceSVD = zeros(size(inter,2), 1);
%
% % images reconstruites en utilisant de 1 à 200 vecteurs (avec un pas de 40)
% ti = 0;
% td = 0;
% for k = inter
%
%    % Calcul de l'image de rang k
%    Im_k = U(:, 1:k)*S(1:k, 1:k)*V(:, 1:k)';
%
%    % Affichage de l'image reconstruite
%    ti = ti+1;
%    figure(ti)
%    colormap('gray')
%    imagesc(Im_k), axis equal
%
%    % Calcul de la différence entre les 2 images
%    td = td + 1;
%    differenceSVD(td) = sqrt(sum(sum((I-Im_k).^2)));
%    pause
% end
%
% % Figure des différences entre image réelle et image reconstruite
% ti = ti+1;
% figure(ti)
% hold on
% plot(inter, differenceSVD, 'rx')
% ylabel('RMSE')
% xlabel('rank k')
% pause
% close all


% Plugger les différentes méthodes : eig, puissance itérée et les 4 versions de la "subspace iteration method"

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% QUELQUES VALEURS PAR DÉFAUT DE PARAMÈTRES,
% VALEURS QUE VOUS POUVEZ/DEVEZ FAIRE ÉVOLUER
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% tolérance
eps = 1e-8;
% nombre d'itérations max pour atteindre la convergence
maxit = 10000;

% taille de l'espace de recherche (m)
search_space = 400;

% pourcentage que l'on se fixe
percentage = 0.995;

% p pour les versions 2 et 3 (attention p déjà utilisé comme taille)
puiss = 1;

%%%%%%%%%%%%%
% À COMPLÉTER
%%%%%%%%%%%%%

k = 100; % utiliser trace de M ici

to_test = [

    001,... %eig
    010,... %power_v12
    011,... %subspace_iter_v0
    100,... %subspace_iter_v1
    101,... %subspace_iter_v2

    ];
for method =1:length(to_test)

    % calcul des couples propres
    M = I' * I;
    nom_method = "";
    switch to_test(method)
        case 001
            [Vi, Val] = eig(M);
                        nom_method = "eig";


        case 010
            [ Vi, Val, n_ev, itv, flag ] = power_v11( M, search_space, percentage, eps, maxit );
            nom_method = "power";
            

            case 011
            [ Vi, Val, it, flag ] = subspace_iter_v0( M, search_space, eps, maxit );
            nom_method = "subspace_iter0";


            case 100
            [ Vi, Val, n_ev, it, itv, flag ] = subspace_iter_v1( M, search_space, percentage, eps, maxit );
                        nom_method = "subspace_iter1";

        case 101
            [Vi, Val, n_ev, it, itv, flag] = subspace_iter_v2(M, search_space, percentage, puiss ,eps, maxit);
                        nom_method = "subspace_iter2";
    end



    % calcul des valeurs singulières

    sing_val = sqrt(Val);

    % calcul de l'autre ensemble de vecteurs
    Ui = I * Vi / sing_val;



    % vecteur pour stocker la différence entre l'image et l'image reconstruite
    inter = 1:20:(100);
    difference = zeros(size(inter,2), 1);
    ti = 0;
    td = 0;


    % calcul des meilleures approximations de rang faible
    for i = inter

        % Calcul de l'image de rang k
        I_k = Ui(:, 1:i)*sing_val(1:i, 1:i)*Vi(:, 1:i)';

        % Affichage de l'image reconstruite
        ti = ti+1;
        % figure(ti)
        % colormap('gray')
        % imagesc(I_k), axis equal

        % Calcul de la différence entre les 2 images
        td = td + 1;
        difference(td) = sqrt(sum(sum((I-I_k).^2)));
        %pause
    end

    % Figure des différences entre image réelle et image reconstruite
    ti = ti+1;
    f = figure(method);
    
    plot(inter, difference, 'rx')
    ylabel('2')
    xlabel('2')
    plot2svg(nom_method + '_differences.svg', f)
    %pause
end

