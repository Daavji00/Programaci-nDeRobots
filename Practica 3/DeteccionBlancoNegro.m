%%Este mini programa esta hecho para calibrar el robot detectando el nivel
% de intensidad de blanco y negro en la hoja usada en el progrma V-Rep 
TextOut(0,LCD_LINE1,'-- Deteccion blanco y negro --');
TextOut(0,LCD_LINE2,'Presione el boton central para');
TextOut(0,LCD_LINE3,'comenzar a detectar el color blanco');

while(~ButtonPressed(BTNCENTER))
    % Esperamos a que se pulse el boton central
end 
ClearScreen();

SetSensorLight(IN_1);      % Inicia el sensor de luz

while(ButtonPressed(BTNCENTER))
    l = Sensor(IN_1); 
    TextOut(1,LCD_LINE2,strcat('Light: ',num2str(l)));
    
end

TextOut(0,LCD_LINE1,'Cambie el robot a la linea negra');
TextOut(0,LCD_LINE2,'entonces vuelva a pulsar el boton');
TextOut(0,LCD_LINE3,'para detectar el negro');

while(~ButtonPressed(BTNCENTER))
    % Esperamos a que se pulse el boton central
end 
ClearScreen();


while(ButtonPressed(BTNCENTER))
    l = Sensor(IN_1); 
    TextOut(1,LCD_LINE2,strcat('Light: ',num2str(l)));
    
end

TextOut(1,LCD_LINE7,'--The end--');
Wait(3000);

