function D = VQ_distance(X, C)

D = pdist2(X, C, 'euclidean').^2;

end