function [modelArray,tsPer,trEr,tsEr]=My_Test_HMM(st,ga)
%to run HMM code for any scenarios:
%put the test amd train data into UAdata_HMM_30 and into each folders for
%each class. edit fl, name of the folders or classes. edit tsnum trnum as
%number of test and train data in each filder respectively. in sert the
%number of classess into trEr, tsEr, and modelArray.
% for any help: areffarhadi@gmail.com
% 

%  st=3;
%  ga=4;


addpath netlab
addpath VOICEBOX
addpath KPMtools
addpath KPMstats
addpath HMM
addpath SSGMM


    trEr=zeros(30,30);
    tsEr=zeros(30,30);
    modelStruct= struct('LL',[], 'prior',[], 'transmat',[], 'mu', [],'Sigma', [],'mixmat',[]);
    modelArray=repmat(modelStruct,30);

    fl={'D1','D2','D3','D4','D5','D6','D7','D8','D9','C1','C2','C3','C4','C5','C6','C7','C8','C9','C10','C11','C12','C13','C14','C15','C16','C17','C18','C19','LA','LD'};


 tsdir='.\UA_HMM_30\test\';
    
    tsnum=200*ones(1,30); 
    tsdata=readData2(tsdir,fl,tsnum);    %readData3 for using SSGMMVAD
    
    
    trdir='.\UA_HMM_30\train\';    
    trnum=95*ones(1,30);  
    trdata=readData2(trdir,fl,trnum);    %readData3 for using SSGMMVAD
    
    
    for i=1: 30
        [modelArray(i).LL, modelArray(i).prior, modelArray(i).transmat, modelArray(i).mu, modelArray(i).Sigma, modelArray(i).mixmat]=train(trdata(i).alld,st,ga);
        disp(i)
    end
    for i=1:30
        disp(i)

        for j=1:length(tsdata(i).alld)
            m=predict(tsdata(i).alld{j}(:,:),modelArray);
            tsEr(i,m)=tsEr(i,m)+1;
        end
    end
        tsPer=(diag(tsEr)/161)*100;
end
function p =predict(d,modelArray)
        s=zeros(1,30);
        for i=1:30
            s(i)= mhmm_logprob(d, modelArray(i).prior, modelArray(i).transmat, modelArray(i).mu, modelArray(i).Sigma, modelArray(i).mixmat);
        end
        p=find(s==max(s));
end
