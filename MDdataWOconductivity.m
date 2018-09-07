clear
clc
%Script for Water FLux from MD DI Water Experiment
%Created By: Ciara Avelina Lugo
%Modified By:

%Initializing varibles
inW = input('What is the initial weight of the feed tank in Liters?  '); %to get initial weight of tank
filename = input('What file would you like to import from EXCEL? Include ".xlsx"(macs) or ".xls"   ', 's');      %to get filename to inport
timeE = xlsread(filename, 'A2:A31');    %Import exact time from EXCEL, saves as decimal
disWg = xlsread(filename, 'B2:B31');    %Import distillate weight (g) from EXCEL
disWl = disWg/1000                     %Get distillate weight in liters
a = 0.039;                              %Area, in m^2
timeI = timeE(1,1);                     %Get initial time
%Pre-allocating arrays
dTm = zeros(length(disWg), 1);          
dTh = zeros(length(disWg), 1);  
timeH = zeros(length(disWg), 1);  
Jw = zeros(length(disWg), 1);  
rec = zeros(length(disWg), 1);  

for i = 1:length(disWg)                              %Initialize for loop.
        if i ~= 1
            
        %Get difference in time in minutes and hours
        g = timeE(i,1) - timeE(i-1,1);                  %Subtract time before it from current time
        g = datetime(g, 'ConvertFrom', 'excel');        %Convert to actual time, from decimal
        g = minute(g);                                  %Get minutes from time above
        dTm(i, 1) = g;                                  %Set array at that point to minutes between the two times
        dTh(i,1) = dTm(i,1)/60                        %Convert to hours
        
        %Get difference in time from initial time to current in hours
        h = timeE(i,1) - timeI;                     %Subtract initial time from current time
        h = datetime(h, 'ConvertFrom', 'excel');    %Convert to actual time, from decimal
        h = hour(h) + ((minute(h))/60);                       %Get hours from time above
        timeH(i, 1) = h;                            %Set array at that point to hours from intial start
        
        %Get water flux for each data point
           if dTh(i,1) == 0                         %If dTh is 0, flux is zero.
                Jw(i,1) = 0
           else                                     %If dTh isn't 0
                Jw(i,1) = ((disWl(i,1)-(disWl(i-1,1))))/(dTh(i,1)*a)       %subtract from one before it, bc it exists   
           end      %End if-else statement
           %End if-else statement
        end
    %Recovery % for each point
    rec(i,1) = 100*(1 - ((inW - disWl(i,1))/inW));    %Since nothing is being subtracted from something before it or a possible 0, it doesn't need to have a condition
end                 %End for loop

Time = datestr(datetime(timeE, 'ConvertFrom', 'excel'), 'HH:MM');   %Change time format from decimal to actual time
%I am changing the variable names so that when they show up in the table, they make sense
TimeElapsed_hrs = timeH;
DistillateWeight_g = disWg;
DistillateWeight_L = disWl;
deltat_min = dTm;
deltat_hrs = dTh;
WaterFlux = Jw;
RecoveryPercent = rec;

%Exporting data to txt file
filen = strcat(input('What txt file would you like to save this data to? DO NOT include ".txt"   ', 's'), '.txt');    %getting filename from user
fileID = fopen(filen,'w');              %open file
%Below is table that will be in txt file
T = table(Time, TimeElapsed_hrs, DistillateWeight_g, DistillateWeight_L, deltat_min, deltat_hrs, WaterFlux, RecoveryPercent);
writetable(T,filen, 'Delimiter', '\t');        %write table into txt file
fclose(fileID);             %close file
fprintf('Note: to export txt file into EXCEL, follow these steps: \n');
fprintf('1. Go to Data button on ribbon. \n')
fprintf('2. Selext "From Text" on left side of the screen. \n');
fprintf('3. Select txt fils that you just created. \n');
fprintf('4. Make sure "Delimited" is selected and choose the row you want to import on. Click Next. \n');
fprintf('5. Make sure "Tab" is selected. Click Next. \n');
fprintf('6. Adjust the data format anyway you please. Click Finish \n');

g = input('Do you want any graphs? Enter "Y" or "N"   ', 's');
if g == 'Y'
    %Code to change the colors of the axis 
    fig = figure;
    left_color = [0 0 0]; %makes color black
    right_color = [0 0 0];
    set(fig,'defaultAxesColorOrder',[left_color; right_color]);

    %plot flux vs. time and recovery vs. time on same graph
    subplot(2,5,[1 2]) %plot first graph of 7
    plot(timeH,Jw,'o', 'MarkerSize', 6, 'MarkerEdgeColor', 'blue', 'MarkerFaceColor', [0 0 1]) %plots Jw vs. time
    xlabel('Time (hrs.)')                          %x-axis label
    ylabel('Jw (L/m^2-hr)') %y axis label for graph on left
    hold on                 %enables us to add other plot
    axis([0 round(max(timeH)) 0 round(max(Jw))]) %range of x from 0 to the rounded up max hours and y axis from 0 to rounded max Jw
    yyaxis right            %creates seperate axis to the right
    ylabel('Recovery %')    %label right side of axis
    plot(timeH,rec,'square', 'MarkerSize', 6, 'MarkerEdgeColor', 'black', 'MarkerFaceColor', [1 0 0])   %plots rec % vs. time
    hold off                %doesn't wait to add more plots to this one
    title('Flux vs. Time and Recovery % vs. Time')  %title
    legend('Flux', 'Recovery %');                   %legend contants
    legend('Location','southeast')                  %location of legend
    axis([0 round(max(timeH)) 0 100]) %range of x from 0 to the rounded up max hours and y axis from 0 to 100
    grid on %adds grid to plot

    %plot Flux vs. Time
    subplot(2,5,6) %plot third graph of 7
    ylabel('Jw (L/m^2-hr)') %y axis label for graph on left
    plot(timeH,Jw,'o', 'MarkerSize', 6, 'MarkerEdgeColor', 'b', 'MarkerFaceColor', [0 0 1]) %plots Jw vs. time
    title('Flux vs. Time')  %title
    xlabel('Time (hrs.)')                          %x-axis label
    axis([0 round(max(timeH)) 0 round(max(Jw))]) %range of x from 0 to the rounded up max hours and y axis from 0 to rounded max Jw
    grid on %adds grid to plot

    %plot Flux vs. Recovery %
    subplot(2,5,7) %plot fourth graph of 7
    ylabel('Jw (L/m^2-hr)') %y axis label for graph on left
    plot(rec, Jw,'o', 'MarkerSize', 6, 'MarkerEdgeColor', 'b', 'MarkerFaceColor', [0 0 1]) %plots Jw vs. time
    title('Flux vs. Recovery %')  %title
    xlabel('Recovery %');   
    axis([0 100 0 round(max(Jw))]) %range of x from 0 to 100 and y axis from 0 to rounded max Jw
    grid on %adds grid to plot

    %plot Recovery % vs. Time
    subplot(2,5,8) %plot fifth graph of 7
    ylabel('Recovery %)') %y axis label for graph on left
    plot(timeH, rec,'o', 'MarkerSize', 6, 'MarkerEdgeColor', 'b', 'MarkerFaceColor', [0 0 1]) %plots Jw vs. time
    title('Recovery % vs. Time')  %title
    xlabel('Time (hrs.)');   
    axis([0 round(max(timeH)) 0 100]) %range of x from 0 to 100 and y axis from 0 to rounded max Jw
    grid on %adds grid to plot
else
    fprintf('Youre done. Have a nice day! \n');
end