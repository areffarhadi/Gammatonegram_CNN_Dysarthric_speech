AA={'D1','D2','D3','D4','D5','D6','D7','D8','D9','C1','C2','C3','C4','C5','C6','C7','C8','C9','C10','C11','C12','C13','C14','C15','C16','C17','C18','C19','LA','LD'};
adres='D:\UA Speech\Images';
adres2='D:\UA Speech\Images\TEST';
for i=1:30
mkdir(adres2,AA{1,i})
end
for i=1:1884
s=trainingImages.Files{i, 1};
s1=s(1:23);
s2=strcat(s1,'227',s(24:end));
trainingImages.Files{i, 1}=s2;
end
for i=1:807
s=validationImages.Files{i, 1};
s1=s(1:23);
s2=strcat(s1,'227',s(24:end));
validationImages.Files{i, 1}=s2;
end
