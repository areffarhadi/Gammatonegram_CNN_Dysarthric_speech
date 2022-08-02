function y=sgn(x)
[a,~]=size(x);
for i=1:a
   if(x(i)>=0)
       y(i)=1;
   else
       y(i)=-1;
   end
end
end