f02 = fileDatastore('D:\UA Speech\f02','ReadFcn',@load,'FileExtensions','.wav');
f03 = fileDatastore('D:\UA Speech\f03','ReadFcn',@load,'FileExtensions','.wav');
f04 = fileDatastore('D:\UA Speech\f04','ReadFcn',@load,'FileExtensions','.wav');
f05 = fileDatastore('D:\UA Speech\f05','ReadFcn',@load,'FileExtensions','.wav');
m01 = fileDatastore('D:\UA Speech\M01','ReadFcn',@load,'FileExtensions','.wav');
m04 = fileDatastore('D:\UA Speech\M04','ReadFcn',@load,'FileExtensions','.wav');
m05 = fileDatastore('D:\UA Speech\M05','ReadFcn',@load,'FileExtensions','.wav');
m06 = fileDatastore('D:\UA Speech\M06','ReadFcn',@load,'FileExtensions','.wav');
m07 = fileDatastore('D:\UA Speech\M07','ReadFcn',@load,'FileExtensions','.wav');
m08 = fileDatastore('D:\UA Speech\M08','ReadFcn',@load,'FileExtensions','.wav');
m09 = fileDatastore('D:\UA Speech\M09','ReadFcn',@load,'FileExtensions','.wav');
m10 = fileDatastore('D:\UA Speech\M10','ReadFcn',@load,'FileExtensions','.wav');
m11 = fileDatastore('D:\UA Speech\M11','ReadFcn',@load,'FileExtensions','.wav');
m12 = fileDatastore('D:\UA Speech\M12','ReadFcn',@load,'FileExtensions','.wav');
m14 = fileDatastore('D:\UA Speech\m14','ReadFcn',@load,'FileExtensions','.wav');
m16 = fileDatastore('D:\UA Speech\M16','ReadFcn',@load,'FileExtensions','.wav');

allData=[f02.Files;f03.Files;f04.Files;f05.Files;m01.Files;m04.Files;m05.Files;m06.Files;m07.Files;m08.Files;m09.Files;m10.Files;m11.Files;m12.Files;m14.Files;m16.Files];
D1={};D2={};D3={};D4={};D5={};D6={};D7={};D8={};D9={};C1={};C2={};C3={};C4={};C5={};C6={};C7={};C8={};C9={};C10={};C11={};C12={};C13={};C14={};C15={};C16={};C17={};C18={};C19={};CW8={};LD={};LA={};
for i=1:75691
    a=allData{i, 1}(25:27);
%     if strcmp('D1_',a)
%         D1=cat(1,D1,allData{i,1});
%         
%     elseif strcmp('D2_',a)
%         D2=cat(1,D2,allData{i,1});
%         
%     elseif strcmp('D3_',a)
%         D3=cat(1,D3,allData{i,1});
%         
%     elseif strcmp('D4_',a)
%         D4=cat(1,D4,allData{i,1});
%         
%     elseif strcmp('D5_',a)
%         D5=cat(1,D5,allData{i,1});
%         
%     elseif strcmp('D6_',a)
%         D6=cat(1,D6,allData{i,1});
%         
%     elseif strcmp('D7_',a)
%         D7=cat(1,D7,allData{i,1});
%         
%     elseif strcmp('D8_',a)
%         D8=cat(1,D8,allData{i,1});
%         
%     elseif strcmp('D9_',a)
%         D9=cat(1,D9,allData{i,1});
%         
%     elseif strcmp('C1_',a)
%         C1=cat(1,C1,allData{i,1});
%         
%     elseif strcmp('C2_',a)
%         C2=cat(1,C2,allData{i,1});
%         
%     elseif strcmp('C3_',a)
%         C3=cat(1,C3,allData{i,1});
%         
%     elseif strcmp('C4_',a)
%         C4=cat(1,C4,allData{i,1});
%         
%     elseif strcmp('C5_',a)
%         C5=cat(1,C5,allData{i,1});
%         
%     elseif strcmp('C6_',a)
%         C6=cat(1,C6,allData{i,1});
%         
%     elseif strcmp('C7_',a)
%         C7=cat(1,C7,allData{i,1});
%         
%     elseif strcmp('C8_',a)
%         C8=cat(1,C8,allData{i,1});
%         
%     elseif strcmp('C9_',a)
%         C9=cat(1,C9,allData{i,1});
%         
%     elseif strcmp('C10',a)
%         C10=cat(1,C10,allData{i,1});
%         
%     elseif strcmp('C11',a)
%         C11=cat(1,C11,allData{i,1});
%         
%     elseif strcmp('C12',a)
%         C12=cat(1,C12,allData{i,1});
%         
%     elseif strcmp('C13',a)
%         C13=cat(1,C13,allData{i,1});
%         
%     elseif strcmp('C14',a)
%         C14=cat(1,C14,allData{i,1});
%         
%     elseif strcmp('C15',a)
%         C15=cat(1,C15,allData{i,1});
%         
%     elseif strcmp('C16',a)
%         C16=cat(1,C16,allData{i,1});
%         
%     elseif strcmp('C17',a)
%         C17=cat(1,C17,allData{i,1});
%         
%     elseif strcmp('C18',a)
%         C18=cat(1,C18,allData{i,1});
%         
%     elseif strcmp('C19',a)
%         C19=cat(1,C19,allData{i,1});
%         
%     elseif strcmp('CW8',a)
%         CW8=cat(1,CW8,allData{i,1});
     if strcmp('LD_',a)
        LD=cat(1,D1,allData{i,1});
        
    elseif strcmp('LA_',a)
        LA=cat(1,D2,allData{i,1});
    end
end

