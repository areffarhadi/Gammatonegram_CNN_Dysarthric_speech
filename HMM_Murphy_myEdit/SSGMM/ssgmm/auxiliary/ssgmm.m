function [ IDX, LLR, gmm ] = ssgmm( X, labels, varargin )
% Input:
%    X - (num_cases, dimension) dataset 
%    labels: -1 - unused, 0 - unlabeled, 1,2,... - classes
%
% Output:
%    IDX - labels for unlabelled data 
%    LLR - log-likelihood ration for 2-class case
%    gmm - struct containing mixture parameters


[~, dim] = size(X);
numClasses = sum(unique(labels)>0);
nn = [];
for l = 1:numClasses
    nn(l) = sum(labels==l);
end


%% Process options

if (isstruct(varargin)) 
    args= prepareArgs(varargin{1});
else
    args= prepareArgs(varargin);
end
[initType,        ...
 initIter,        ...
 initGMM,         ...
 numIter,         ...
 covType,         ...
 sharedCov,       ...
 numComp,         ...
 keepInit        ...
 ] = process_options(args, ...
 'initType',     0       , ...
 'initIter',     1       , ...
 'initGMM' ,     {}      , ...
 'numIter' ,     20       , ...
 'covType' ,     'full'  , ...
 'sharedCov',    false   , ... 
 'numComp' ,     4*ones(1,numClasses), ...
 'keepInit',     false);

% check input args
if length(numComp) ~= numClasses
    error(message('Wrong number of classes'));
end


%% Training
regCoeff = 0.01/2; % covariance regularization 

% Random initialization
if initType == 0 
    for l = 1:numClasses
        Sig = diag(var(X(labels==l,:)));
        mu{l} = mvnrnd(mean(X(labels==l,:)), Sig, numComp(l));
        w{l} = ones(1,numComp(l))/numComp(l);
        covs{l} = repmat(Sig, [1 1 numComp(l)]);  
    end 
% Initialize by another GMM    
elseif initType == 1  
    for l = 1:numClasses
        
        shrd = initGMM{l}.SharedCov;
        ctype = initGMM{l}.CovType;
        nK = length(initGMM{l}.PComponents);
        
        covId = containers.Map({'full', 'diagonal', 'spherical'}, [1 2 3]);    
        
        if (numComp == nK) && (sharedCov == shrd) && (covId(covType) == covId(ctype))           
            mu{l} = initGMM{l}.mu;
            w{l} = initGMM{l}.PComponents;
            covs{l} = initGMM{l}.Sigma;             
        else
           error('[GMM]: GMM cannot be initialized! K: [%i<--%i], shared: [%i<--%i], covtype: [%s<--%s]',...
               numComp, nK, sharedCov, shrd, covType, ctype); 
        end
        
    end
end


% Uniform class prior
prior = ones(1,numClasses)/numClasses;

% Preallocate space
scanComp(1) = 0;
pp = zeros(1, sum(numComp));
for l = 1:numClasses
    scanComp(l+1) = sum(numComp(1:l));
    idx{l} = scanComp(l)+1:scanComp(l+1);
    
    pp(idx{l}) = prior(l);
end


% EM

kl2idx = @(k,l) idx{l}(k);            

for i = 1:numIter

    gamma = -inf(size(X,1), sum(numComp));
    if i<=initIter
        mask = labels>0;
    else        
        mask = labels>=0;
    end
    
    % Compute responsibilities
    for l = 1:numClasses  
        for k = 1:numComp(l)
            index = (labels==l | labels==0) & mask;    
            gamma(index, kl2idx(k,l)) = logmvnpdf(X(index,:), mu{l}(k,:), covs{l}(:,:,k));               
        end
    end

    gamma = bsxfun(@plus, gamma, log(pp .* cat(2,w{:})));    
    gamma = exp(bsxfun(@minus, gamma, logsumexp(gamma,2)));
    ww = mean(gamma(mask,:)); 
    
    % Update covariances
    if sharedCov % Shared within a class         
        for l = 1:numClasses    
            covar  = zeros(dim);
            for k = 1:numComp(l)
                x_centered = bsxfun(@minus, X(mask,:), mu{l}(k,:));
                x_centered = bsxfun(@times, x_centered, sqrt(gamma(mask,kl2idx(k,l)))); 
                covar = covar + x_centered'*x_centered;         
            end  
            
            for k = 1:numComp(l)
                covs{l}(:,:,k) =  covar/sum(sum(gamma(mask,idx{l}))) + regCoeff*eye(dim);    
            end             
        end                 
    else        
        for l = 1:numClasses   
            for k = 1:numComp(l)
                x_centered = bsxfun(@minus, X(mask,:), mu{l}(k,:));
                x_centered = bsxfun(@times, x_centered, sqrt(gamma(mask,kl2idx(k,l))));
                covs{l}(:,:,k) = x_centered'*x_centered/sum(gamma(mask,kl2idx(k,l))) + regCoeff*eye(dim);         
            end  
        end       
    end  
    if strcmp(covType, 'diagonal')
        for l = 1:numClasses
            for k = 1:numComp(l)
                covs{l}(:,:,k) = diag(diag(covs{l}(:,:,k))); 
            end
        end
    end
    if strcmp(covType, 'spherical')
        for l = 1:numClasses 
            for k = 1:numComp(l)
                covs{l}(:,:,k) = eye(dim)*mean(diag(covs{l}(:,:,k)));%
            end
        end
    end     

    % Update means
    for l = 1:numClasses            
        for k = 1:numComp(l)
            mu{l}(k,:) = gamma(mask,kl2idx(k,l))'*X(mask,:)/sum(gamma(mask,kl2idx(k,l)));
        end
    end
    
    % Update weights
    for l = 1:numClasses         
        w{l} = ww(idx{l})/sum(ww(idx{l}));
    end   
    
end

% Compute likelihood
L = zeros(size(X,1), numClasses);
for l = 1:numClasses
    gmm{l} = gmdistribution(mu{l}, covs{l}, w{l});    
    L(:,l) = gmm_loglikelihood(gmm{l}, X); 
end


if numClasses == 2
    LLR = L(:,2) - L(:,1); 
else
    LLR = [];
end

[~, IDX ] = max(L, [], 2);

if keepInit
    IDX = IDX(labels==0);
    if numClasses == 2
        LLR = LLR(labels==0);
    end
end

end

