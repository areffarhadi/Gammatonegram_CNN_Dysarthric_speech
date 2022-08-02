function [s,fs] = read_NIST_sph(fname)

tmp_file = sprintf('%s.wav', tempname);
sox_cmd = sprintf('sox %s -e signed-integer -t wav %s', fname, tmp_file); 
system(sox_cmd);
[s,fs] = audioread(tmp_file);
delete(tmp_file);