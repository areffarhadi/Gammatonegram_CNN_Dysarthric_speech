
ds = datastore('C:\Users\khorasani\Desktop\F02','FileExtensions','.wav') ;

a='C:\Users\khorasani\Desktop\F02\F02_B1_C2_M2_3.wav';
b=a(32:end-4);  %b=a(1:end-4);
im=strcat(b,'.jpg');
saveas(gcf,im);