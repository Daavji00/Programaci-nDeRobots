TextOut(0,LCD_LINE1,'-- Practica 6 --');
TextOut(0,LCD_LINE2,'Presione el boton central para');
TextOut(0,LCD_LINE3,'comenzar con la prueba');


while(~ButtonPressed(BTNCENTER))
    % Esperamos a que se pulse el boton central
end 
ClearScreen();

ResetRotationCount(OUT_A); % Establece a 0 los encoder de los dos motores
ResetRotationCount(OUT_C); % A izquierda, C derecha
SetSensorLight(IN_1); %Inicia el sensor de luz
SetSensorUltrasonic(IN_2); %Inica el sonar
t_ini = CurrentTick();  % Obtiene el tiempo de simulacion actual
tiempo = 120000; % Tiempo en milisegundos que debe durar el programa
con_Tiempo=t_ini; %Contador de tiempo que se usará en el programa
N=0; %Contador usado en el programa
marca_sonar_antigua = 30; %Variable que guarda el ultimo valor registrado por el sonar
OnFwd(OUT_AC,10); %Potencia inicial a las ruedas
StatusLight(1,0); %Luz central de color naranja
Salto_Fuerte1 = 0;
Salto_Fuerte2 = 0;
Salto_Fuerte3 = 0;
    
%Bucle principal que termina a los 120 segundos
while( (CurrentTick()-t_ini) <= tiempo) 
    %Texto mostrad en la pantalla con los sensores y tiempo
    
    TextOut(1,LCD_LINE1,strcat('Tiempo: ',num2str(CurrentTick()-t_ini)));
    TextOut(1,LCD_LINE2,strcat('Luz: ',num2str(Sensor(IN_1))));
    TextOut(1,LCD_LINE3,strcat('Sonar: ',num2str(SensorUS(IN_2))));
    TextOut(1,LCD_LINE4,strcat('Botón: ',num2str(0)));
    
    
    
    %Control foraging
    %
    %Entra cuando detecta con el sensor de luz el blanco (70 marcado en el
    %sensor
    % Una vez retirado el papel y pulsado de nuevo el boton reanuda la
    % marcha
    while(Sensor(IN_1) >= 70 && (CurrentTick()-t_ini) <= tiempo) 
        %Cambia el centro del panel a verde parpadeante y para el robot
        StatusLight(0,1);
        Off(OUT_AC);
        
     
        while(~ButtonPressed(BTNCENTER) && (CurrentTick()-t_ini) <= tiempo)
            TextOut(1,LCD_LINE1,strcat('Tiempo: ',num2str(CurrentTick()-t_ini)));
            TextOut(1,LCD_LINE2,strcat('Luz: ',num2str(Sensor(IN_1))));
            TextOut(1,LCD_LINE3,strcat('Sonar: ',num2str(SensorUS(IN_2))));
        end 
        
    end
    
    %Cambia la luz a naranja
    StatusLight(1,0);
    
    
    %Control sonar
    %
    %Solo entra en caso de nos encontramos un posible obstaculo, es decir
    %el rango del sonar marca menos de 20.5 o devuelve 255. Además tiene en
    %cuenta si se detecta un papel y si termina el timepo, según la
    %jerarquía establecida
    while((SensorUS(IN_2) <= 20.5 || SensorUS(IN_2) == 255) ...
            && (CurrentTick()-t_ini) <= tiempo ...
            && Sensor(IN_1) < 70)
        
        %Guardamos el estado del sensor actual 
        if(SensorUS(IN_2) ~= 255)
            marca_sonar_antigua = SensorUS(IN_2);
        end
        
        %Mostramos los datos de sensores y tiempo
        TextOut(1,LCD_LINE1,strcat('Tiempo: ',num2str(CurrentTick()-t_ini)));
        TextOut(1,LCD_LINE2,strcat('Luz: ',num2str(Sensor(IN_1))));
        TextOut(1,LCD_LINE3,strcat('Sonar: ',num2str(SensorUS(IN_2))));
        TextOut(1,LCD_LINE4,strcat('Botón: ',num2str(0)));
        
        %Establecemos una potencia a la ruedas aleatoria
        giro_izq = (rand()*10);
        giro_der = (rand()*10);
        
        %Aplicamos una potencia fuerte a las rueda girando hacia atrás
        %cuando se quede atrancado el robot
        if(Salto_Fuerte1 == 5 || Salto_Fuerte2 == 5 || Salto_Fuerte3 == 5)
            if(rand() >= rand())
                OnFwd(OUT_A, -25);
                OnFwd(OUT_C, -5);
            else
                OnFwd(OUT_C, -25);
                OnFwd(OUT_A, -5);
            end
            Salto_Fuerte1 = 0;
            Salto_Fuerte2 = 0;
            Salto_Fuerte3 = 0;
            
        %Aplicamo potencia hacia atrás con mayor potencia si el robot está
        %muy cerca de la pared
        elseif (SensorUS(IN_2) <= 10)
            
           OnFwd(OUT_AC, -15);
           Salto_Fuerte1 = Salto_Fuerte1+1;
        %Si el robot se encuentra cerca de la pared se realizar una potencia 
        %moderada
        elseif (SensorUS(IN_2) <= 19)
            OnFwd(OUT_AC, -10);
            Salto_Fuerte2 = Salto_Fuerte2+1;
        %En caso de que el sonar devuelva 255 y la ultima marca registrada
        %por el sonar sea menor a 18 aplicamos una fuerza moderada a las
        %ruedas hacia atras
        elseif (SensorUS(IN_2) == 255 && marca_sonar_antigua < 18)
               marca_sonar_antigua = 30;
               Salto_Fuerte3 = Salto_Fuerte3+1;
               OnFwd(OUT_AC, -12);
        end     
        %Bucle que permite aplicar la nueva potencia hacia atrás a las
        %ruedas durante un tiempo
        contador_tiempo2 = CurrentTick() +600;
        while((CurrentTick()-t_ini) <= tiempo && (CurrentTick() <= contador_tiempo2) ...
            && Sensor(IN_1) < 70 )
        
            TextOut(1,LCD_LINE1,strcat('Tiempo: ',num2str(CurrentTick()-t_ini)));
            TextOut(1,LCD_LINE2,strcat('Luz: ',num2str(Sensor(IN_1))));
            TextOut(1,LCD_LINE3,strcat('Sonar: ',num2str(SensorUS(IN_2))));
            TextOut(1,LCD_LINE4,strcat('Botón: ',num2str(0)));
        end 
        
        %Segun el numero aleatorio sacado para cada rueda lo giraremos a la
        %izquiera o a la derecha
        if (giro_izq > giro_der) 
            
            OnFwd(OUT_A, giro_izq*3);
            OnFwd(OUT_C, -5);
        else
            
            OnFwd(OUT_C, giro_der*3);
            OnFwd(OUT_A, -5);
        end  
        
        %Bucle que permite aplicar la nueva potencia hacia atrás a las
        %ruedas durante un tiempo
        contador_tiempo2 = CurrentTick()+700;
        while((CurrentTick()-t_ini) <= tiempo && (CurrentTick() <= contador_tiempo2) ...
            && Sensor(IN_1) < 70 && (SensorUS(IN_2) ~= 255 || SensorUS(IN_2) > 10))
            TextOut(1,LCD_LINE1,strcat('Tiempo: ',num2str(CurrentTick()-t_ini)));
            TextOut(1,LCD_LINE2,strcat('Luz: ',num2str(Sensor(IN_1))));
            TextOut(1,LCD_LINE3,strcat('Sonar: ',num2str(SensorUS(IN_2))));
            TextOut(1,LCD_LINE4,strcat('Botón: ',num2str(0)));
        end
    end 
    
    %Funcion para deambular
    %
    %
    con_Tiempo = CurrentTick()+1200;
    while((CurrentTick()-t_ini) <= tiempo && ... 
        CurrentTick() <= con_Tiempo && Sensor(IN_1) < 70 ...
        && SensorUS(IN_2) >= 32 && SensorUS(IN_2) ~= 255)
        TextOut(1,LCD_LINE1,strcat('Tiempo: ',num2str(CurrentTick()-t_ini)));
        TextOut(1,LCD_LINE2,strcat('Luz: ',num2str(Sensor(IN_1))));
        TextOut(1,LCD_LINE3,strcat('Sonar: ',num2str(SensorUS(IN_2))));
        
        giro_izq = (rand()*10);
        giro_der = (rand()*10);
        
        if (N < 3)
            N=N+1;
            con_Tiempo2 = CurrentTick()+900;
            while((CurrentTick()-t_ini) <= tiempo && ... 
                CurrentTick() <= con_Tiempo2 && Sensor(IN_1) < 70 ...
                && SensorUS(IN_2) >= 30 && SensorUS(IN_2) ~= 255)
                TextOut(1,LCD_LINE1,strcat('Tiempo: ',num2str(CurrentTick()-t_ini)));
                TextOut(1,LCD_LINE2,strcat('Luz: ',num2str(Sensor(IN_1))));
                TextOut(1,LCD_LINE3,strcat('Sonar: ',num2str(SensorUS(IN_2))));
                
                OnFwd(OUT_A, 15);    
            end
        else
            
            
            if (giro_izq > giro_der) 
                OnFwd(OUT_A, giro_izq);
                OnFwd(OUT_C, giro_der/2);
            else
                OnFwd(OUT_A, giro_izq/2);
                OnFwd(OUT_C, giro_der);
            end
            
            N = 0;
            con_Tiempo2 = CurrentTick()+450;
            while((CurrentTick()-t_ini) <= tiempo && ... 
                CurrentTick() <= con_Tiempo2 && Sensor(IN_1) < 70 ...
                && SensorUS(IN_2) >= 30 && SensorUS(IN_2) ~= 255)
                
                TextOut(1,LCD_LINE1,strcat('Tiempo: ',num2str(CurrentTick()-t_ini)));
                TextOut(1,LCD_LINE2,strcat('Luz: ',num2str(Sensor(IN_1))));
                TextOut(1,LCD_LINE3,strcat('Sonar: ',num2str(SensorUS(IN_2))));
                
                
            end
        end
    end
    
    OnFwd(OUT_AC,10);
end
Off(OUT_AC); %Apaga los motores
%Muestra los resultados
TextOut(1,LCD_LINE7,'--The end--');
Wait(3000);

