function [eig_vec,eig_val]=EVD(D)
%%==========================================
%% EigenValue Decomposition                
%% function [eig_vec,eig_val]=EVD(D)            
%% D is a d x n data matrix 
%% (d:dimensionality, n: number of samples)        
%% eig_vec: sorted eigenvectors          
%% eig_val: sorted eigenvalues          
%%=========================================
[d,n]=size(D);
if d < n
  C=D*D';
  matrank=rank(C);
  [tmp_vec,tmp_val] = eig(C);
  [value index]=sort(diag(tmp_val),'descend');
  eig_vec=tmp_vec(:,index(1:matrank));
  eig_val=value(1:matrank);
else
  C=D'*D;
  matrank=rank(C);
  [tmp_vec,tmp_val] = eig(C);
  [value index]=sort(diag(tmp_val),'descend');
  eig_vec=[];
  for i = 1 : matrank
    v=(D*tmp_vec(:,index(i)))./sqrt(value(i));
    eig_vec=[eig_vec,v];
  end
  eig_val=value(1:matrank);
end
