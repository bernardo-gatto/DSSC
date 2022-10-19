%
% This is the code for Mutual Singular Spectrum Analysis (MSSA)
%
% paper: Mutual singular spectrum analysis for bioacoustics classification
% MLSP, 2017
%
% authors: BB Gatto, JG Colonna, EM Santos & EF Nakamura
%
% Please contact us if you find any issues
% bernardo@icomp.ufam.edu.br or juancolonna@icomp.ufam.edu.br
%

clear all;
close all;

% Training and test subspaces dimension
d        = 25;

% number of canonical angles
n_angles = 15;

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

% eigenvalue decomposition for training and test dataset
for ii = 1:n_test
  [U, eig_val] = EVD(test_matrices{ii}.A);
  test_matrices{ii}.U = U;
end

for ii = 1:n_trai
  [U, eig_val] = EVD(trai_matrices{ii}.A);
  trai_matrices{ii}.U = U;
end

% linear MSM
prox_matrix = zeros(n_test, 287);

for ii_test = 1:n_test
    A = test_matrices{ii_test}.U(:, 1:d);
    for ii_train = 1:n_trai
        B = trai_matrices{ii_train}.U(:, 1:d);
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
imagesc(prox_matrix);

% compute the accuracy
correct_pred = 0;

for ii = 1:n_test
  if strcmp(test_matrices{ii}.label, test_matrices{ii}.predicted)
      correct_pred = correct_pred + 1;
  end
end

accuracy = 100*correct_pred/n_test;
fprintf(2,'accuracy = %3.1f %%\n', accuracy);