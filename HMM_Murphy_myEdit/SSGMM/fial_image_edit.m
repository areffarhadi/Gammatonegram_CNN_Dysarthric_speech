% images = imageDatastore('D:\UA Speech\10wordDATA');
% images2 = imageDatastore('D:\UA Speech\10wordDATA');


PedDatasetPath = ('D:\UA Speech\Images'); 
 categories = {'D1', 'D2','D3','D4','D5','D6','D7','D8','D9','C1', 'C2','C3','C4','C5','C6','C7','C8','C9','C10','C11','C12','C13','C14','C15','C16','C17','C18','C19','LD','LA'};
% categories = {'D1', 'D2','D3','D4','D5','D6','D7','D8','D9'};

images = imageDatastore(fullfile(PedDatasetPath, categories), 'LabelSource', 'foldernames');
[w,~]=size(images.Files);
for ii=1:w
  ts  = imread(images.Files{ii,1});
    ts=imresize(ts,[224,224]);
%   ts1=rgb2gray(ts);
%   [m,n]=size(ts1);
% %   figure;imshow(ts);
%   for i=1:m
%       if ts1(i,300)~=255
%           L=i;
%           break
%       end
%   end
%   
%   for ij=m:-1:1
%     if ts1(ij,300)~=255
%           R=ij;
%           break
%     end
%   end  
%   
%    for j=1:n
%     if ts1(300,j)~=255
%           T=j;
%           break
%     end
%    end  
%   for ji=n:-1:1
%     if ts1(300,ji)~=255
%           D=ji;
%           break
%     end
%   end 
%   ts=ts(L:R,T:D,:);
% %   figure;imshow(ts)
imwrite(ts,images.Files{ii,1})
ii
end