TextOut(0,LCD_LINE1,'-- Ejemplo de uso --');
TextOut(0,LCD_LINE2,'Presione el boton central para');
TextOut(0,LCD_LINE3,'comenzar con la prueba');


while(~ButtonPressed(BTNCENTER))
    % Esperamos a que se pulse el boton central
end 
ClearScreen();

ResetRotationCount(OUT_A); % Establece a 0 los encoder de los dos motores
ResetRotationCount(OUT_C); % A izquierda, C derecha
t_ini = CurrentTick();  % Obtiene el tiempo de simulacion actual
tiempo = 5000; % Tiempo en milisegundos que debe durar el programa

while( (CurrentTick()-t_ini) <= tiempo)
    Off(OUT_AC); %Apagamos motores para que no tropiece una ordena de potencia anterior con una nueva y sea más exacto
    ra = MotorRotationCount(OUT_A); %lee el encoder del motor izq
    rc = MotorRotationCount(OUT_C); %idem para der
    %calcula la diferencia entre los grados a conseguir y los que lleva en ambos motores
    ruedaIzq = 860 - ra; 
    ruedaDer = 860 - rc; 
    
    %Ajusta la potencia de las ruedas entres -100 y 100
    if (ruedaIzq > 100 && ruedaDer > 100) 
        OnFwd(OUT_AC,100);
    elseif (ruedaIzq < -100 && ruedaDer < -100) 
        OnFwd(OUT_AC,-100);
    else
        OnFwd(OUT_A, ruedaIzq);
        OnFwd(OUT_C, ruedaDer);
    end  
end
Off(OUT_AC); %Apaga los motores
%Muestra los resultados
TextOut(1,LCD_LINE4,strcat('Deg A: ',num2str(ra))); 
TextOut(1,LCD_LINE5,strcat('Deg C: ',num2str(rc)));
TextOut(1,LCD_LINE7,'--The end--');
Wait(3000);

