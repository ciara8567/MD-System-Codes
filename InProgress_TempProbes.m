clear
clc
%Script for automating MD System
%Created By: Ciara Avelina Lugo
%Modified By:
%-------------------------------------------------------------------------------------------------
%get initial weight of tank
%-------------------------------------------------------------------------------------------------
%DEBUG
%    inW = input('What is the initial weight of the tank in Liters(L)?   ');
    inW = 4.25;
%    m = input('How many minutes do you want between every data point?   ');
    m = 20;
    cSP = zeros(100000, 1);     hSP = zeros(100000, 1);
%    cSP = input('What is the cooler Set Point?');
    cSP(1,1) = 26;
%    cSP = input('What is the heater Set Point?');
    hSP(1,1) = 60;    
%-------------------------------------------------------------------------------------------------

%Initialize arduino:
%substitute '/dev/cu.usbmodem1411' with port your arduino is connected to
%Ensure 'ForceBuild' = true if making changes to header files (C++). Otherwise
%set to false for faster initialization.
j = input('is arduino connected?   ');
if j == 'Y'
%-------------------------------------------------------------------------------------------------
%DEBUG
    a = arduino('/dev/cu.usbmodem1411', 'Uno', 'Libraries', 'custom/MAX31865', 'TraceOn', true, 'ForceBuild', true);
%-------------------------------------------------------------------------------------------------
    %Leave "TraceOn" for debuging

%Create max31865 objects for each physical device.
%Figure out which pin is which and name them that

%-------------------------------------------------------------------------------------------------
%DEBUG
    max_1 = addon(a, 'custom/MAX31865');
    max_2 = addon(a, 'custom/MAX31865');
    max_3 = addon(a, 'custom/MAX31865');
    max_4 = addon(a, 'custom/MAX31865');
%-------------------------------------------------------------------------------------------------

%Chip Select pins for each device
CS1 = 9;
CS2 = 8;
CS3 = 7;
CS4 = 6;

% Use software SPI: CS, DI, DO, CLK
% Use hardware SPI: just pass in the CS pin
% Hardware pinout: MOSI-11 MISO-12 CLK-13

%-------------------------------------------------------------------------------------------------
%DEBUG
    max_1.Adafruit_MAX31865(CS1);
    max_2.Adafruit_MAX31865(CS2);
    max_3.Adafruit_MAX31865(CS3);
    max_4.Adafruit_MAX31865(CS4); 
%-------------------------------------------------------------------------------------------------

% The value of the Rref resistor. Use 430.0!
RREF = 430.0;

%Start devices. This takes care of CS pin settings and SPI. Don't have to
%handle any of that manually.

%-------------------------------------------------------------------------------------------------
%DEBUG
    max_1.begin(max_1.t_3WIRE); 
    max_2.begin(max_2.t_3WIRE);
    max_3.begin(max_3.t_3WIRE);
    max_4.begin(max_4.t_3WIRE);
%-------------------------------------------------------------------------------------------------
end
%Initialize email info
mail = 'hickenbottomlab@gmail.com'; %Your Yahoo email address
psswd = 'membraneDist2K18';  %Your Yahoo password
host = 'smtp.gmail.com';
port  = '465';
recps = ['ciara8567@email.arizona.edu' ];        %add Marisa, Cassandra, Marcos & Dr. Hickenbottom
setpref('Internet','SMTP_Server', host);
setpref( 'Internet','E_mail', mail );
setpref( 'Internet', 'SMTP_Server', host );
setpref( 'Internet', 'SMTP_Username', mail );
setpref( 'Internet', 'SMTP_Password', psswd );
props = java.lang.System.getProperties;
props.setProperty( 'mail.smtp.user', mail );
props.setProperty( 'mail.smtp.host', host );
props.setProperty( 'mail.smtp.port', port );
props.setProperty( 'mail.smtp.starttls.enable', 'true' );
props.setProperty( 'mail.smtp.debug', 'true' );
props.setProperty( 'mail.smtp.auth', 'true' );
props.setProperty( 'mail.smtp.socketFactory.port', port );
props.setProperty( 'mail.smtp.socketFactory.class', 'javax.net.ssl.SSLSocketFactory' );
props.setProperty( 'mail.smtp.socketFactory.fallback', 'false' );

%initialize temp arrays
t1a = zeros(100000, 1); t2a = zeros(100000, 1); t3a = zeros(100000, 1); t4a = zeros(100000, 1);
%tempTime = [0:minutes(1):hours(20)]';

i=1;
k = 0;
j = 0;
timeEh = zeros(100000, 1);  timeEm = zeros(100000, 1);

%-------------------------------------------------------------------------------------------------
%DEBUG
%Maxes of temp probes before email/message
%t1max = 80;   t2max = 35;   t3max = 80;   t4max = 35;
%Mins of temp probes before email/message
%t1min = 55;  t2min = 10;  t3min = 55;  t4min = 10;
t1max = 1000;   t2max = 1000;   t3max = 1000;   t4max = 1000;
%Mins of temp probes before email/message
t1min = 55;  t2min = 10;  t3min = 55;  t4min = 10;
%-------------------------------------------------------------------------------------------------


fprintf('Type "S" when you start the experiment, "P" if you changed the SetPoint, "D" if the experiment is done.\n');

start = input('', 's');
if start == "S"
    fprintf('DD-Mon-YYYY HH:MM:SS\tHot In\tHot Out\tCold In\tCold Out\tWater Flux\tRec %%\tElapsed Hrs.\t\n'); %Column labels
    fprintf('--------------------\t------\t-------\t-------\t--------\t----------\t------\t------------\t\n'); 
    tI = datetime('now');
    
   while true
      %if input('', 's') == 'D'
      %    break;
    %  elseif input('') == 'P'
     %     ty = input('Type "C" to change Cooler Set Point, "H" to change Heater Set Point', 's');
      %    if ty == 'C'
       %       cSP(i,1) = input('What would you like to change it to?   ');
        %  elseif ty == 'H'
        %      hSP(i,1) = input('What would you like to change it to?   ');
         % elseif (i ~= 1)
          %    cSP(i,1) = cSP(i-1, 1);
           %   hSP(i,1) = hSP(i-1, 1);
         % end
      %end
      
      if (rem(k, 60) == 0) 
          %Get time for each value
          tempTime(i,1) = datetime('now');  

          %Save temp values
         %------------------------------------------------------------------------------------------------- 
          %DEBUG
          %    t1a(i,1) = max_1.temperature(100, RREF);
          %    t2a(i,1) = max_2.temperature(100, RREF);
          %    t3a(i,1) = max_3.temperature(100, RREF);
          %    t4a(i,1) = max_4.temperature(100, RREF);
               t1a(i,1) = rand()*1000;
               t2a(i,1) = rand()*1000;
               t3a(i,1) = rand()*1000;
               t4a(i,1) = rand()*1000;
         %------------------------------------------------------------------------------------------------- 
          %Print temp values
          fprintf('%s\t', tempTime(i,1));
          fprintf('%.2f\t', t1a(i,1));
          fprintf('%.2f\t', t2a(i,1));
          fprintf('%.2f\t', t3a(i,1));
          fprintf('%.2f\t', t4a(i,1));
          fprintf('%d\t\t\t', double(((i-1)/60)));

           %------------------------------------------------------------------------------------------------- 
            %****Get weight from scale



           %------------------------------------------------------------------------------------------------- 

          %If values out of range, send email
          if (t1a(i,1) > t1max) || (t1a(i,1) < t1min)
              msg = sprintf('Hello!\n\n There is an issue with your T1 probe. It is currently %.2f.\n\nThank you!', t1a(i,1));
              sendmail(recps, 'T1 probe issue', msg); 
              fprintf('There is an issue with your T1 probe. It is currently, %.2f.\n', t1a(i,1));
          elseif (t2a(i,1) > t2max) || (t2a(i,1) < t2min)
              msg = sprintf('Hello!\n\n There is an issue with your T2 probe. It is currently %.2f.\n\nThank you!', t2a(i,1));
              sendmail(recps, 'T2 probe issue', msg);      %Send to Ciara
              fprintf('There is an issue with your T2 probe. It is currently, %.2f.\n', t2a(i,1));
          elseif (t3a(i,1) > t3max) || (t3a(i,1) < t3min)
              msg = sprintf('Hello!\n\n There is an issue with your T3 probe. It is currently %.2f.\n\nThank you!', t3a(i,1));
              sendmail(recps, 'T3 probe issue', msg);      %Send to Ciara
              fprintf('There is an issue with your T3 probe. It is currently, %.2f.\n', t3a(i,1));
          elseif (t4a(i,1) > t4max) || (t4a(i,1) < t4min)
              msg = sprintf('Hello!\n\n There is an issue with your T4 probe. It is currently %.2f.\n\nThank you!', t4a(i,1));
              sendmail(recps, 'T4 probe issue', msg);      %Send to Ciara
              fprintf('There is an issue with your T4 probe. It is currently, %.2f.\n', t4a(i,1));
          end 

          if (j == m) || (j==0)
              %Get elapsed time in hrs
              timeEh(i,1) = ((timeEh(i,1) + j)/60);
              %Get elapsed time in min
              timeEm(i,1) = (timeEh(i,1) + j);
              %Save weight 
              %Convert g to L
              %Calculate WaterFlux
              %Calculate Recovery Percent
              j = 0;
          end
                i = i + 1;
      end

      %**Write code that if current weight is < prior weight, add ones after to one less than current one***



      %keep the loop going
      k = k+1;
      j = (j + 1)/60;

      %wait 1 second for next iteration
      pause(1) %seconds
    end
end
%Get deltat in minutes and hours
dtMin = ones(i, 1)*m;
dtH = (ones(i,1)*(m/60));
%**Find way to get conductivity info

%Export to EXCEL

%**Graphs


                                                                               