function Cep = ComputeFFTCepstrum(Frames, FilterBank, NumCoeffs, NFFT, keep_C0);
% function Cep = ComputeFFTCepstrum(Frames, FilterBank, NumCoeffs);

SmallNumber = 0.00000000001;
ESpec = abs(fft(Frames',NFFT)).^2;
ESpec = ESpec(1:NFFT/2+1, :);

if ~isempty(FilterBank)
    FBSpec = FilterBank * ESpec;
    LogSpec = log(FBSpec + SmallNumber);
    Cep = dct(LogSpec);
    %Cep = Cep(2:NumCoeffs+1, :)';
else % No filterbank
    LogSpec = log(ESpec + SmallNumber);
    Cep = dct(LogSpec);
    %Cep = Cep(2:NumCoeffs+1, :)';
end;

if keep_C0
    Cep = Cep(1:NumCoeffs, :)';
else
    Cep = Cep(2:NumCoeffs+1, :)';
end;

if nargout > 1
    LogSpec = LogSpec';
    FBSpec = FBSpec';
    ESpec = ESpec';
end;
