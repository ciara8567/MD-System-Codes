%This is to obtain the temperature probe information every 20 minutes, print it and saves it
%and exports to a text file
date = input('What is today''s date? Use the format MM.DD.YYYY   ','s');
things = input('How many hours do you plan to run this for?   ');
pts = things*3 +1;

a = arduino(port, 'Uno', 'Libraries', 'custom/MAX31865', 'TraceOn', true, 'ForceBuild', true);
fprintf('Arduino is set up, yo. \n');
max_1 = addon(a, 'custom/MAX31865');
max_2 = addon(a, 'custom/MAX31865');
max_3 = addon(a, 'custom/MAX31865');
max_4 = addon(a, 'custom/MAX31865');    
CS1 = 9;
CS2 = 8;
CS3 = 7;
CS4 = 6;
max_1.Adafruit_MAX31865(CS1);
max_2.Adafruit_MAX31865(CS2);
max_3.Adafruit_MAX31865(CS3);
max_4.Adafruit_MAX31865(CS4); 

% The value of the Rref resistor. Use 430.0!
RREF = 430.0;

max_1.begin(max_1.t_3WIRE); 
max_2.begin(max_2.t_3WIRE);
max_3.begin(max_3.t_3WIRE);
max_4.begin(max_4.t_3WIRE);

i = 1;
z = pts;
t1a = zeros(z, 1); t2a = zeros(z, 1); t3a = zeros(z, 1); t4a = zeros(z, 1); tempDaT = strings(z,1); tempTime = strings(z,1);
filen = strcat('MDTempData', date, '.txt');
fileID = fopen(filen,'w');              %open file

%tempTime= zeros(z,1);
fprintf('DD-Mon-YYYY HH:MM:SS\tHot In\tHot Out\tCold In\tCold Out\tElapsed Hrs.\tElapsed Min.\n'); %Column labels
fprintf('--------------------\t------\t-------\t-------\t--------\t------------\t------------\n'); 
tI = datetime('now');

while (i <= z)
    tempDaT(i,1) = string(datetime('now'));  
    t1a(i,1) = max_1.temperature(100, RREF);
    t2a(i,1) = max_2.temperature(100, RREF);
    t3a(i,1) = max_3.temperature(100, RREF);
    t4a(i,1) = max_4.temperature(100, RREF);
     fprintf('%s \t', tempDaT(i,1));
     fprintf(' %.2f\t', t1a(i,1));
     fprintf('  %.2f\t', t2a(i,1));
     fprintf('  %.2f\t', t3a(i,1));
     fprintf('  %.2f\t\t', t4a(i,1));
     fprintf('    %.2f\t', 20/60);
     fprintf('    %d\t\t\n', 20);
     
     tempTime(i,1) = datestr(datetime('now'), 'HH:MM');
     fprintf(fileID, '%s\t', tempTime(i,1));
     fprintf(fileID,'%.2f\t', t1a(i,1));
     fprintf(fileID,'%.2f\t', t2a(i,1));
     fprintf(fileID,'%.2f\t', t3a(i,1));
     fprintf(fileID,'%.2f\t', t4a(i,1));
     fprintf(fileID,'%.2f\t', 20/60);
     fprintf(fileID,'%d\t\n', 20);
    i = i +1;  
    pause(60*20);
end

fclose(fileID);
fprintf('\nNote: to export txt file into EXCEL, follow these steps: \n');
fprintf('1. Go to Data button on ribbon. \n')
fprintf('2. Select "From Text" on left side of the screen. \n');
fprintf('3. Select txt file that you just created. \n');
fprintf('4. Make sure "Delimited" is selected and choose the row you want to import on. Click Next. \n');
fprintf('5. Make sure "Tab" is selected. Click Next. \n');
fprintf('6. Adjust the data format anyway you please. Click Finish \n');
fprintf('You''re done. Have a nice day! \n');
