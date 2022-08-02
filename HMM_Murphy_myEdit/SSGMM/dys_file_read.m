b=0;
for i=100:301
    filename=C1{i,1};
    filename = multimedia.internal.io.absolutePathForReading(...
    filename, ...
    'MATLAB:audiovideo:audioread:fileNotFound', ...
    'MATLAB:audiovideo:audioread:filePermissionDenied');

import multimedia.internal.audio.file.PluginManager;

try
    readPlugin = PluginManager.getInstance.getPluginForRead(filename);
    [d,sr]=audioread(C1{i,1});
    b=b+1;
    [D2,F2] = gammatonegram(d,sr,0.025,0.010,256,50,sr/2,0);
    imagesc(20*log10(D2)); axis xy
    a=imagesc(20*log10(D2)); axis xy
%     imwrite(ind2rgb(im2uint8(mat2gray(D2)),parula(256)),'aaaaa.jpg')
%imwrite(ind2rgb(im2uint8(mat2gray(D2)),parula(64)),'a6.jpg')
%     imwrite(outputImage,images2.Files{i,1});
end
end