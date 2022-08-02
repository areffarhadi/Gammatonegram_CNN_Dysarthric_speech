function y = average(x)
x=1:30;
if ~isvector(x)
    error('Input must be a vector')
end
y = sum(x)/length(x); 
end