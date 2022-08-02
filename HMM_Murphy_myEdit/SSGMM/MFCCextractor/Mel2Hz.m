function f_Hz = Mel2Hz(f_mel);

f_Hz = 1000 * (10^((log10(2) * f_mel)/1000) - 1);