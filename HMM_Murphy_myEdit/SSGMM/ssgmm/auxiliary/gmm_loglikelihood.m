function L = gmm_loglikelihood( gmm, X)

MATLAB = isobject(gmm) || isfield(gmm, 'Sigma');

if MATLAB;
    K = length(gmm.PComponents);
else
    K = length(gmm.w);
end
[N, dim] = size(X);

if MATLAB
    s = size(gmm.Sigma);
else
    s = size(gmm.sigma);
end

% check this logic! todo: simplify!
if isobject(gmm) 
    if strcmp(gmm.CovType, 'full')
        DIAG = 0;
    elseif strcmp(gmm.CovType, 'diagonal')
        DIAG = 1;
    else
        error('Wrong cov type');
    end
else
    if numel(s)==3 && s(1)==1 && s(2)>1
        DIAG = 1;
    elseif numel(s)==2 && K>1
        DIAG = 1;
    else
        DIAG = 0;
    end
end




if ~MATLAB % TODO: fix this part: mu(:,k)' vs. mu(k,:)'

    L = zeros(N,K);
    for k = 1:K;
        if DIAG
            L(:,k) = log(gmm.w(k)+realmin) + logmvnpdf(X, gmm.mu(:,k)', diag(gmm.sigma(:,k)));
        else
            L(:,k) = log(gmm.w(k)+realmin) + logmvnpdf(X, gmm.mu(k,:)', gmm.sigma(:,:,k));
        end

    end
    
else

    L = zeros(N,K);
    for k = 1:K;
        
        if DIAG
            if gmm.SharedCov && isobject(gmm)
                Sigma = diag( gmm.Sigma);
            else
                Sigma = diag( gmm.Sigma(:,:,k));
            end
            L(:,k) = log(gmm.PComponents(k)+realmin) + logmvnpdf(X, gmm.mu(k,:), Sigma);
        else
            if gmm.SharedCov && isobject(gmm)
                Sigma = gmm.Sigma;
            else
                Sigma = gmm.Sigma(:,:,k);
            end
            L(:,k) = log(gmm.PComponents(k)+realmin) + logmvnpdf(X, gmm.mu(k,:), Sigma);
        end

    end
end

L = logsumexp(L,2);

end

