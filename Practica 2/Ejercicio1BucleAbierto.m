
TextOut(0,LCD_LINE1,'-- Ejemplo de uso --');
TextOut(0,LCD_LINE2,'Presione el boton central para');
TextOut(0,LCD_LINE3,'comenzar con la prueba');
while(~ButtonPressed(BTNCENTER))
    % Esperamos a que se pulse el boton central
end 
ClearScreen();

ResetRotationCount(OUT_A); % Establece a 0 los encoder de los dos motores
ResetRotationCount(OUT_C); % A izquierda, C derecha

t_ini = CurrentTick();     % Obtiene el tiempo de simulacion actual
tiempo = 2000; % Tiempo en milisegundos que debe durar el programa

OnFwd(OUT_AC,43); % Arranca ambos motores con potencia = 43

while( (CurrentTick()-t_ini) <= tiempo)
    ra = MotorRotationCount(OUT_A); % Lee el encoder del motor izquierdo
    rc = MotorRotationCount(OUT_C); % Lee el encoder del motor derecho
    
end

Off(OUT_AC); % Apaga los 2 motores
TextOut(1,LCD_LINE4,strcat('Deg A: ',num2str(ra))); % Muestra el encoder del motor izq
TextOut(1,LCD_LINE5,strcat('Deg C: ',num2str(rc))); % Muestra el encoder del motor der
    
TextOut(1,LCD_LINE7,'--The end--');
Wait(3000);
