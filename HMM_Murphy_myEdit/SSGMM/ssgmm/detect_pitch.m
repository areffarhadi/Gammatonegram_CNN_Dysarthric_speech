function [ pitch, pv01 ] = detect_pitch( s, fs, params, num_frames )


dp=getF0sDefaultparams;
dp.wind_dur = params.frame_len;
dp.frame_step = params.frame_shift;

[pitch, pv01] = getf0s(s, fs, dp);

pv01 = pv01';
pitch = pitch';

% padding
if nargin>3
    np = length(pv01);
    r = (num_frames - np)/2;
    
    pv01 = [ones(1, ceil(r))*pv01(1) pv01 ones(1, floor(r))*pv01(end)];
    pitch = [ones(1, ceil(r))*pitch(1) pitch ones(1, floor(r))*pitch(end)];
end


end

