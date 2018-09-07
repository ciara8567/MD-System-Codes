clear a
a = arduino()

   writeDigitalPin(a, 'D11', 0);
   pause(2);
   writeDigitalPin(a, 'D11', 1);

      for i = 1:10
      writeDigitalPin(a, 'D11', 0);
      pause(0.5);
      writeDigitalPin(a, 'D11', 1);
      pause(0.5);
      end
   
    brightness_step = (1-0)/20;
   for i = 1:20
      writePWMDutyCycle(a, 'D11', i*brightness_step);
      pause(0.1);
   end

   for i = 1:20
      writePWMDutyCycle(a, 'D11', 1-i*brightness_step);
      pause(0.1);
   end
   
      brightness_step = (5-0)/20; 
   for i = 1:20
      writePWMVoltage(a, 'D11', i*brightness_step);
      pause(0.1);
   end
 
   for i = 1:20
      writePWMVoltage(a, 'D11', 5-i*brightness_step);
      pause(0.1);
   end