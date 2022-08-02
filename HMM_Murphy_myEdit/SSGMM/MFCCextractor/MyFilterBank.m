function [H, CenterFreq] = MyFilterBank(NumFilters, fs, FminHz, FmaxHz, NFFT, Warping, PlotResponse);
% function [H, CenterFreq] = MyFilterBank(NumFilters, fs, FminHz, FmaxHz, NFFT, Warping, PlotResponse);
%
% Note: no guarantees of implementation accuracy...

NumFilters = NumFilters + 1;
for m=2:NumFilters+1
    switch (Warping)
        case 'mel',
            CenterFreq(m-1) = Mel2Hz(Hz2Mel(FminHz) + m*((Hz2Mel(FmaxHz) - Hz2Mel(FminHz))/(NumFilters + 1)));
        case 'erb',
            CenterFreq(m-1) = ERB2Hz(Hz2ERB(FminHz) + m*((Hz2ERB(FmaxHz) - Hz2ERB(FminHz))/(NumFilters + 1)));
        case 'lin',
            CenterFreq(m-1) = FminHz + m*((FmaxHz - FminHz)/(NumFilters + 1));
        otherwise
            error('Wrong warping function. Kruts!');
    end;
    f(m) = floor((NFFT/fs) * CenterFreq(m-1));
end;
f(1) = floor((FminHz/fs)*NFFT)+1;
f(m+1) = ceil((FmaxHz/fs)*NFFT)-1;

H = zeros(NumFilters,NFFT/2+1);
for m=2:NumFilters
    for k=f(m-1):f(m)
        foo = f(m)-f(m-1);
        if (foo==0)
            foo = 1;
        end;
        H(m-1,k) = (k - f(m-1))/foo;
    end;
    for k = f(m):f(m+1)
        foo = f(m+1) - f(m);
        if (foo==0)
            foo = 1;
        end;
        if (f(m+1) - f(m) ~= 0)
            H(m-1,k) = (f(m+1) - k)/foo;
        end;
    end;
end;
H = H(1:NumFilters-1,:)';
CenterFreq = f(2:end); %CenterFreq(1:NumFilters-1);

if (PlotResponse)
    plot(((0:NFFT/2)./NFFT).*fs,H);
    xlabel('Frequency [Hz]');
    ylabel('Gain');
    grid on;
end;