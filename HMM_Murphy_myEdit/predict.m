function p =predict(d,modelArray)
        s=zeros(1,16);
        for i=1:16
            s(i)= mhmm_logprob(d, modelArray(i).prior, modelArray(i).transmat, modelArray(i).mu, modelArray(i).Sigma, modelArray(i).mixmat);
        end
        p=find(s==max(s));
end