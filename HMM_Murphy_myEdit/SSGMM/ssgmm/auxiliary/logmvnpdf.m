function [logp, dlopg] = logmvnpdf(x,mu,Sigma)
% Log of multivariate normal pdf.
%
% Tamara Broderick
% David Duvenaud
%
% March 2013

dim = size(mu,2);
logdetcov = logdet(Sigma);
a = bsxfun(@minus, x, mu);
logp = (-dim/2)*log(2*pi) + (-.5)*logdetcov +...
    (-.5.*sum(bsxfun( @times, a / Sigma, a), 2));   % Evaluate for multiple inputs.

if nargout > 1
    % Compute Gradients w.r.t. x.
    % Output dimension will be N x D.
    dlopg = -( x - mu ) / Sigma;
end
end

function ld = logdet(K)
    % returns the log-determinant of posdef matrix K.
    
    % This is probably horribly slow.
    ld = NaN;
    try
        ld = 2*sum(log(diag(chol(K))));
    catch e
        e
    end
end