
TextOut(0,LCD_LINE1,'-- Ejemplo de uso --');
TextOut(0,LCD_LINE2,'Presione el boton central para');
TextOut(0,LCD_LINE3,'comenzar con la prueba');
while(~ButtonPressed(BTNCENTER))
    % Esperamos a que se pulse el boton central
end 
ClearScreen();

t_ini = CurrentTick();     % Obtiene el tiempo de simulacion actual
tiempo = 60000; % Tiempo en milisegundos que debe durar el programa

SetSensorLight(IN_1);      % Inicia el sensor de luz
ResetRotationCount(OUT_A); % Establece a 0 los encoder de los dos motores
ResetRotationCount(OUT_C); % A izquierda, C derecha

%Creamos manejador y cantida y el fichero
manejador=[];
cantidad=[];
CreateFile('Ejercicio2',50000,manejador);
 
 R=40; %Referencia sobre la banda gris
 U=5; %Banda de Histéresis
 P=50; %Potencia motores (5, 10, 30, 50)

while( (CurrentTick()-t_ini) <= tiempo)   
    Off(OUT_AC); %Apagamos motores para que no tropiece una ordena de potencia anterior con una nueva y sea más exacto
    t = CurrentTick()-t_ini; %Calculamos el tiempo que ha pasado
    l = Sensor(IN_1); % Lee el sensor de luz
    E=R-l; %Calculo del error
    
    %Escribimos en fichero
    WriteLnString(manejador,sprintf('%u\t%u',t,l),cantidad);
    
    %Damos potencia a los motores en función del error 
    if(E<-U)
        OnFwd(OUT_A,-P);
        OnFwd(OUT_C,P);
    elseif(E>U)
        OnFwd(OUT_C,-P);
        OnFwd(OUT_A,P);
    else
        OnFwd(OUT_A,P);   
        OnFwd(OUT_C,P);
    end
    
end

Off(OUT_AC); %Apagamos motores
CloseFile(manejador); %Cerramos el fichero
TextOut(1,LCD_LINE7,'--The end--');
Wait(3000);