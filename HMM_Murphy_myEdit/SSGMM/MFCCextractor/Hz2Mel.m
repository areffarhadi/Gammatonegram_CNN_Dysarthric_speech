function Mel = Hz2Mel(f_Hz);

Mel = (1000/log10(2)) * log10(1 + f_Hz/1000);