
3%%  Application de la SVD : compression d'images

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

%% vecteur pour stocker la différence entre l'image et l'image reconstruite
%inter = 1:40:(200+40);
%inter(end) = 200;
%differenceSVD = zeros(size(inter,2), 1);
%
%% images reconstruites en utilisant de 1 à 200 vecteurs (avec un pas de 40)
%ti = 0;
%td = 0;
%for k = inter
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
%end
%
%% Figure des différences entre image réelle et image reconstruite
%ti = ti+1;
%figure(ti)
%hold on
%plot(inter, differenceSVD, 'rx')
%ylabel('RMSE')
%xlabel('rank k')
%pause
%
%
% Plugger les différentes méthodes : eig, puissance itérée et les 4 versions de la "subspace iteration method"

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% QUELQUES VALEURS PAR DÉFAUT DE PARAMÈTRES,
% VALEURS QUE VOUS POUVEZ/DEVEZ FAIRE ÉVOLUER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

k = 100 % utiliser trace de M ici

% calcul des couples propres
M = I * I';
%[val_p, vect_p, ~, ~, ~] = eigen_2024(1,p,10,k,eps,maxit,percentage,puiss,0);
%[val_p, vect_p] = eig(M);
[val_p, vect_p, ~,~,~,~] = subspace_iter_v1( M, search_space, percentage, eps, maxit );

val_p=abs(val_p);
[val_p,indices] = sort(val_p,'descend');
vect_p = vect_p(indices);

% calcul des valeurs singulières
sigma = diag(sqrt(val_p(:, 1:k)));
u = vect_p(:, 1:k);

% calcul de l'autre ensemble de vecteurs
v = (I' * u)./sigma(1,:);


% calcul des meilleures approximations de rang faible



% vecteur pour stocker la différence entre l'image et l'image reconstruite
inter = 1:5:k;

difference = zeros(size(inter,2), 1);

% images reconstruites en utilisant de 1 à 200 vecteurs (avec un pas de 40)
ti = 0;
td = 0;
s= diag(sigma);
for i = inter

    % Calcul de l'image de rang k
%    Im_k = U(:, 1:k)*S(1:k, 1:k)*V(:, 1:k)';

    I_k = u(:, 1:i)* s(1:i, 1:i) * v(:, 1:i)';

    % Affichage de l'image reconstruite
    ti = ti+1;
    figure(ti)
    colormap('gray')
    imagesc(I_k), axis equal

    % Calcul de la différence entre les 2 images
    td = td + 1;
    difference(td) = sqrt(sum(sum((I-I_k).^2)))
    %pause
end

% Figure des différences entre image réelle et image reconstruite
ti = ti+1;
figure(ti)
hold on
plot(inter, difference, 'rx')
ylabel('2')
xlabel('2')
pause