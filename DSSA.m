%
% This is the code for Discriminative Singular Spectrum Classifier (DSSC)
%
% paper: Discriminative Singular Spectrum Classifier with Applications on
% Bioacoustic Signal Recognition, Digital Signal Processing, 2022
%
% authors: BB Gatto, JG Colonna, EM Santos, AL Koerich & K Fukui
%
% Please contact us if you find any issues
% bernardo@icomp.ufam.edu.br or juancolonna@icomp.ufam.edu.br
%

clear all;
close all;

% Training and test subspaces dimension
d        = 28;
% Window size
L        = 45;
% number of canonical angles
n_angles = 5;
% residual subspace, possible noise subspace
residual = 5;
% difference subspace dimension ds
ds       = 11;
% dimension of the projected subspace
proj_d   = 20;

load('Beehive_Autocorrelation_Data_set_L_45.mat'); % load dataset
[n_samples, ~] = size(Matrices);

% Split the dataset into training and test datasets
n_test = 0;
n_trai = 0;

for ii=1:n_samples
    if mod(ii, 2) == 0
        test_matrices{n_test + 1}.A     = Matrices{ii};
        test_matrices{n_test + 1}.label = label{ii};
        n_test = n_test + 1;
    end
    if mod(ii, 2) ~= 0
        trai_matrices{n_trai + 1}.A     = Matrices{ii};
        trai_matrices{n_trai + 1}.label = label{ii};
        n_trai = n_trai + 1;
    end
end

% eigenvalue decomposition for each dataset
for ii = 1:n_test
  [U, eig_val] = EVD(test_matrices{ii}.A);
  test_matrices{ii}.U = U;
end

for ii = 1:n_trai
  [U, eig_val] = EVD(trai_matrices{ii}.A);
  trai_matrices{ii}.U = U;
end

% computing the sum of the projection matrices G
G = zeros(L, L);
for ii = 1:287
  A = trai_matrices{ii}.A;
  G = G + A;
end

% normalize G
G = G/n_trai;

% computing the sum subspace P
[P, svalue_P, ~] = svd(G);

% computing the difference subspace D
D = P(:, ds:end-residual);

% projecting U onto D to obtain V
for ii = 1:n_test
    U = test_matrices{ii}.U(:, 1:d);
    Y = D'*U;
    [Y, ~, ~] = svd(Y);
    test_matrices{ii}.V = Y;
end

for ii = 1:n_trai
    U = trai_matrices{ii}.U(:, 1:d);
    Y = D'*U;
    [Y, ~, ~] = svd(Y);
    trai_matrices{ii}.V = Y;
end

% linear MSM
prox_matrix = zeros(n_test, n_trai);

for ii_test = 1:n_test
    A = test_matrices{ii_test}.V(:, 1:proj_d);
    for ii_train = 1:n_trai
        B = trai_matrices{ii_train}.V(:, 1:proj_d);
        S = B'*A*A'*B;
        
        [~, eig_val] = eig(S);
        partial_sim(ii_train) = sim_avr(diag(eig_val), n_angles);
        prox_matrix(ii_test, ii_train) = sim_avr(diag(eig_val), n_angles);
    end
    
    [~, index] = max(partial_sim);
    test_matrices{ii_test}.predicted = trai_matrices{index}.label;
end

% print the proximity matrix
colormap('jet')
imagesc(real(prox_matrix));

% compute the accuracy
correct_pred = 0;

for ii = 1:n_test
  if strcmp(test_matrices{ii}.label, test_matrices{ii}.predicted)
      correct_pred = correct_pred + 1;
  end
end

accuracy = 100*correct_pred/n_test;
fprintf(2,'accuracy = %3.1f %%\n', accuracy);