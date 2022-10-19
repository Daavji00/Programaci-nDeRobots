TextOut(0,LCD_LINE1,'-- Practica 5 --');
TextOut(0,LCD_LINE2,'Presione el boton central para');
TextOut(0,LCD_LINE3,'comenzar con la prueba');


while(~ButtonPressed(BTNCENTER))
    % Esperamos a que se pulse el boton central
end 
ClearScreen();

ResetRotationCount(OUT_A); % Establece a 0 los encoder de los dos motores
ResetRotationCount(OUT_C); % A izquierda, C derecha
t_ini = CurrentTick();  % Obtiene el tiempo de simulacion actual
tiempo = 10000; % Tiempo en milisegundos que debe durar el programa

manejador=[];
cantidad=[];
CreateFile('muestras_p5.txt', 10000, manejador);

while( (CurrentTick()-t_ini) <= tiempo)
     OnFwd(OUT_AC,50);
     
     
     WriteLnString(manejador, sprintf('%u\t%u\t%u', (CurrentTick()-t_ini) ...
         , MotorRotationCount(OUT_A), MotorRotationCount(OUT_C)),cantidad);
     while( ((CurrentTick()-t_ini) >= 2000 && (CurrentTick()-t_ini) <= 2650)) 
         OnFwd(OUT_C,0);
         WriteLnString(manejador, sprintf('%u\t%u\t%u', (CurrentTick()-t_ini) ...
         , MotorRotationCount(OUT_A), MotorRotationCount(OUT_C)),cantidad);
     end
     while( ((CurrentTick()-t_ini) >= 4300 && (CurrentTick()-t_ini) <= 5000)) 
         OnFwd(OUT_C,0);
        WriteLnString(manejador, sprintf('%u\t%u\t%u', (CurrentTick()-t_ini) ...
         , MotorRotationCount(OUT_A), MotorRotationCount(OUT_C)),cantidad);
     end
     while( ((CurrentTick()-t_ini) >= 6600 && (CurrentTick()-t_ini) <= 7300)) 
         OnFwd(OUT_C,0);
         WriteLnString(manejador, sprintf('%u\t%u\t%u', (CurrentTick()-t_ini) ...
         , MotorRotationCount(OUT_A), MotorRotationCount(OUT_C)),cantidad);
     end
     while( ((CurrentTick()-t_ini) >= 9000 && (CurrentTick()-t_ini) <= 9700)) 
         OnFwd(OUT_C,0);
         WriteLnString(manejador, sprintf('%u\t%u\t%u', (CurrentTick()-t_ini) ...
         , MotorRotationCount(OUT_A), MotorRotationCount(OUT_C)),cantidad);
     end
end
Off(OUT_AC); 
CloseFile(manejador);
TextOut(1,LCD_LINE7,'--The end--');
Wait(3000);

