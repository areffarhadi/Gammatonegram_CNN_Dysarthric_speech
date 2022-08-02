function [LL, prior1, transmat1, mu1, Sigma1, mixmat1] =train1(data,Q,M)
O = size(data{1},1);
T = size(data{1},2);
nex = size(data,2);

prior0 = zeros(Q,1);
prior0(1)=1;
transmat0 = zeros(Q,Q);
%transmat0 = mk_stochastic(rand(Q,Q));
for i =1:Q
    transmat0(i,i:min(i+2,Q))=1/min(3,Q-i+1);
 end

[mu0, Sigma0] = mixgauss_init(Q*M, reshape(data{1}, [O T]),'diag');
mu0 = reshape(mu0, [O Q M]);
Sigma0 = reshape(Sigma0, [O O Q M]);
mixmat0 = mk_stochastic(rand(Q,M));
[LL, prior1, transmat1, mu1, Sigma1, mixmat1] = mhmm_em(data, prior0, transmat0, mu0, Sigma0, mixmat0, 'max_iter', 5);