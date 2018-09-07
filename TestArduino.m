clear
clc
a = arduino();

lib = listArduinoLibraries()


%shield = addon(a, 'Adafruit/MotorShieldV2');
%include <Adafruit_MAX31865.h>
%include <SPI.h>
%include <Wire.h>
%include <RTClib.h>

CS1 = 9;
CS2 = 8;
CS3 = 7;
CS4 = 6;
 
% Use software SPI: CS, DI, DO, CLK
% use hardware SPI, just pass in the CS pin
Adafruit_MAX31865 max_1 = Adafruit_MAX31865(CS1);
Adafruit_MAX31865 max_2 = Adafruit_MAX31865(CS2);
Adafruit_MAX31865 max_3 = Adafruit_MAX31865(CS3);
Adafruit_MAX31865 max_4 = Adafruit_MAX31865(CS4);
RTC_PCF8523 rtc;

%char daysOfTheWeek[7][12] = {"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"};
%char Year, Month, Day, Hour, Minute, Second;
%int Temperature1, Temperature2, Temperature3, Temperature4; 
T1 = zeros(1500, 1);
T2 = zeros(1500, 1);
T3 = zeros(1500, 1);
T4 = zeros(1500, 1);

% The value of the Rref resistor. Use 430.0!
define RREF 430.0
%Initiating Table Labels
fprintf('Temperature1\tTemperature2\tTemperature3\tTemperature4\tYear,Month\tDay\tHour\tMinute\tSecond'); %Colulm labels


%Serial.println("Temperature1,Temperature2,Temperature3,Temperature4,Year,Month,Day,Hour,Minute,Second");
%max_1.begin(MAX31865_3WIRE); 
max_2.begin(MAX31865_3WIRE);
max_3.begin(MAX31865_3WIRE);
max_4.begin(MAX31865_3WIRE);
pinMode(CS1, OUTPUT);
pinMode(CS2, OUTPUT);
pinMode(CS3, OUTPUT);
pinMode(CS4, OUTPUT);
SPI.begin();
digitalWrite(CS1, HIGH); 
digitalWrite(CS2, HIGH); 
digitalWrite(CS3, HIGH); 
digitalWrite(CS4, HIGH);

%Wire.begin();
%while (!Serial) 
%delay(1);  
%end
%rtc.adjust(DateTime(F(__DATE__), F(__TIME__)));

i = 1; 
tI = datetime('now');

while true
    
now = datetime('now')
if(now.second()==0) 
  
  digitalWrite(CS1, LOW); 
  uint16_t rtd1 = max_1.readRTD();
  float ratio1 = rtd1;
  ratio1 /= 32768; 
  T1(i,1) = max_1.temperature(100, RREF);
  fprintf(1, '\t%4d', T1);      % Write Rows
  %Serial.print(max_1.temperature(100, RREF));
  %Serial.print(',');
  digitalWrite(CS1, HIGH);
 
  digitalWrite(CS2, LOW);
  uint16_t rtd2 = max_2.readRTD();
  float ratio2 = rtd2;
  ratio2 /= 32768;
  T2(i,1) = max_2.temperature(100, RREF);
  fprintf(1, '\t%4d', T2);
  %Serial.print(max_2.temperature(100, RREF));
  %Serial.print(',');
  digitalWrite(CS2, HIGH);

  digitalWrite(CS3, LOW);
  uint16_t rtd3 = max_3.readRTD();
  float ratio3 = rtd3;
  ratio2 /= 32768; 
  T3(i,1) = max_3.temperature(100, RREF);
  fprintf(1, '\t%4d', T3);
  %Serial.print(max_3.temperature(100, RREF));
  %Serial.print(',');
  digitalWrite(CS3, HIGH);

  digitalWrite(CS4, LOW);
  uint16_t rtd4 = max_4.readRTD();
  float ratio4 = rtd4;
  ratio2 /= 32768;
  T4(i,1) = max_4.temperature(100, RREF);
  %Serial.print(max_4.temperature(100, RREF));
  %Serial.print(',');
  fprintf(1, '\t%4d', T4);
  digitalWrite(CS4, HIGH);

    DateTime now = rtc.now(); %clock call
    %Serial.print(now.year(), DEC);
    %Serial.print(',');
    fprintf(1, '\t%4d', now.year(), DEC);
    %Serial.print(now.month(), DEC);
    %Serial.print(',');
    fprintf(1, '\t%2d', now.month(), DEC);
    %Serial.print(now.day(), DEC);
    %Serial.print(",");
    fprintf(1, '\t%2d', now.day(), DEC);
    %Serial.print(daysOfTheWeek(now.dayOfTheWeek()));
    %Serial.print(",");
    fprintf(1, '\t%2d', daysOfTheWeek(now.dayOfTheWeek()));
    %Serial.print(now.hour(), DEC);
    %Serial.print(',');
    fprintf(1, '\t%2d', now.hour(), DEC);
    %Serial.print(now.minute(), DEC);
    %Serial.print(',');
    fprintf(1, '\t%2d', now.minute(), DEC);
    %Serial.print(now.second(), DEC);
    %Serial.println(); 
    fprintf(1, '\t%2d', now.second(), DEC);
    delay(3000);
end
end

                                                                               