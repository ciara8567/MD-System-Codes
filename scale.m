%Download Putty
%Send ? to scale 
%sc = serial()

port = 'cu.usbserial-FT1SKSR0';      %port name since it changes everydaaaaayyy
sc = serial(port,'BaudRate',2400,'DataBits',7);  %initialize scale
fopen(sc);
fprintf(sc,'*IDN?');
idn = fscanf(sc);



fclose(sc);  %close scale