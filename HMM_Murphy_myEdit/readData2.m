function data= readData2(dir,fl,num)
dataStruct= struct('alld',[]);
data=repmat(dataStruct,length(fl),1);
FeatureStruct=struct('feature',[]);

    for i =1:length(fl)
        count=1;
        path= strcat(dir, fl{i});
        path=strcat(path,'\');
        currentData={};
        
        for j=1:num(i)
              path2= strcat(path,'1 (');
              path2= strcat(path2, num2str(j));
             path2= strcat(path2, ').wav');
            % m=MFCC(path2);
            wr=audioread(path2);  %AREF
            wr=wr(:,1);
%         [n,~]=size(wr;
        %%%%%% sohnVAD
%         VAD=my_vad(wr,16000,'a');
%         c=[];
%          for ii=1:n
%            if VAD(ii,1)~=0
%             c=cat(1,c,wr(ii,1));
%            end
%          end
%          wr=c;

         %%%%%%
%          VAD=my_vad(wr,16000,'a');
%          wr=wr.*VAD;
%          wr=nonzeros(wr);
         %%%%%
            m=melcepst(wr,16000,'E''d''D');   %AREF
            %if(size(m,2)==299)
                currentData{count}(:,:)=m';   
              count=count+1;
            % end
            i
            j
        end
        data(i).alld=(currentData);
    end
end
function l= normalize(l)
    for i=1:size(l,2)
        l(:,i)=(l(:,i)-mean(l(:,i)))/sqrt(var(l(:,i)));
    end
end