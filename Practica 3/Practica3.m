
%DEFINICION DE CONSTANTES
Kp = 0.6;
Ki = 0.3;
Kd = 0.7;
BLANCO = 35;
NEGRO = 70;
WINDUP = 20;
Saturacion = 40;
%MAIN

%DECLARACION DE VARIABLES

error_acumulado = 0;
error_anterior = 0;
negro = 8;
blanco = 80;
tAnterior = 0;
pDer = 0;
pIzq = 0;
pBase = 5;
dt = 0;
tActual = 0;

TextOut(0,LCD_LINE1,'-- Practica 3 --');
TextOut(0,LCD_LINE2,'Presione el boton central para');
TextOut(0,LCD_LINE3,'comenzar con la prueba');
TextOut(0,LCD_LINE4,'Active Toggle real-time');
%ALGORITMO DE CONTROL 
while(~ButtonPressed(BTNCENTER))
    % Esperamos a que se pulse el boton central
end 
ClearScreen();


%CALIBRACIÓN DEL SENSOR DE LUZ



SetSensorLight(IN_1);      % Inicia el sensor de luz
ResetRotationCount(OUT_A); % Establece a 0 los encoder de los dos motores
ResetRotationCount(OUT_C); % A izquierda, C derecha
t_ini = CurrentTick();

%Activar el modo Togger-real time
while(1)
    % Lee el sensor de luz
    lectura = Sensor(IN_1); 
    
    %AJUSTE DE LECTURA
    lectura_recta = (lectura*(BLANCO-NEGRO) / (blanco-negro)) + ((-negro*(BLANCO-NEGRO)) + (NEGRO*(blanco-negro)))/(blanco-negro);
    
    %ACTUALIZACION DEL CONTROLADOR
    %Calculamos el error 
    error = (lectura_recta -(BLANCO+NEGRO)/2);
    %Calculamos la derivada del error
    tActual = CurrentTick()-t_ini;
    dt = double(tActual - tAnterior);
    derivada_error = (error - error_anterior)/dt;
    %Calculamos la integral del error
    integral_error = 1 / (error + error_acumulado)*dt;
    
    Gc_pid = Kp*error + Kd*derivada_error+Ki*integral_error;
    pDer = pBase - Gc_pid;
    pIzq = pBase + Gc_pid;
    
    error_anterior = error;
    error_acumulado = error_acumulado + error;
    tAnterior = tActual;
    %AJUSTE DE LA ACTUACION CON WIND-UP
    
    if(Gc_pid > WINDUP || Gc_pid < -WINDUP)
        Gc_pid = Gc_pid - (integral_error*Ki);
        error_acumulado = error_acumulado-error;
    end
    
    %AJUSTE DE POTENCIA DE LOS MOTORES CON SATURACION
    if(pIzq > Saturacion)
        pIzq = Saturacion;
    else
        if (pIzq < -Saturacion)
            pIzq = - Saturacion;
        end
    end    
    
    if(pDer > Saturacion)
        pDer = Saturacion;
    else
        if (pDer < -Saturacion)
            pDer = - Saturacion;
        end
    end    
    
    OnFwd(OUT_A,pIzq);   
    OnFwd(OUT_C,pDer);
    TextOut(1,LCD_LINE1,'Para detener el robot');
    TextOut(1,LCD_LINE2,'pulse stop simulation'); 
    TextOut(1,LCD_LINE3,'en v-rep');
    TextOut(1,LCD_LINE4,strcat('Luz: ',num2str(lectura)));
    TextOut(1,LCD_LINE5,strcat('pDer: ',num2str(pDer))); 
    TextOut(1,LCD_LINE6,strcat('pIzq: ',num2str(pIzq)));

    
end

Off(Out_AC); % Detiene los motores
TextOut(1,LCD_LINE7,'--The end--');
Wait(3000);
