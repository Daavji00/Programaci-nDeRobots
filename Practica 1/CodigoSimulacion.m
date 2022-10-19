%---------------------------------------------------
% AYUDA GENERAL: help Scorbot
% AYUDA FUNCIÓN CONCRETA: help Scorbot.nombrefunción
% GRABAR SÓLO LAS POSICIONES, NO EL OBJETO ROBOT
%---------------------------------------------------


clear;
close all;

s=Scorbot(Scorbot.MODEVREP)
s.home;

teach = 0;
if (~teach)
	load('PosicionesIniFin.mat');
  
    s.changeSpeed(20);
    s.move(posInicial,1);
    
    %%Aproximación a la primera pieza
    s.move(s.changePosXYZ(posInicial, [posInicial.xyz(1)+296 posInicial.xyz(2)-533 posInicial.xyz(3)-28]),1);
    %%Abrimos pinza
    s.changeGripper(1);
    %%Acercamos la pinza para coger mejor la pieza
    s.move(s.changePosXYZ(posInicial, [posInicial.xyz(1)+296 posInicial.xyz(2)-533 posInicial.xyz(3)-928]),1);
    %%Cerramos Pinza y movemos a posiciones anteriores
    s.changeGripper(0);
    s.move(s.changePosXYZ(posInicial, [posInicial.xyz(1)+296 posInicial.xyz(2)-533 posInicial.xyz(3)-28]),1);
    s.move(s.changePosXYZ(posInicial, [posInicial.xyz(1)+296 posInicial.xyz(2)-533 posInicial.xyz(3)-928]),1);
    s.move(posInicial,1);
    %Ahora llevamos la pieza uno a la posicion final
    s.move(posFinal,1);
    %Movemos a la posicion de la pieza y la soltamos
    s.move(s.changePosXYZ(posFinal, [posFinal.xyz(1)-407 posFinal.xyz(2)+2 posFinal.xyz(3)-926]),1);
    s.changeGripper(1);
    s.move(posFinal,1);
    s.changeGripper(0);
  
    
    
    %Aproximacion a la segunda pieza
    s.move(posInicial,1);
    %Nos posicionamos encima y abrimos la pinza
    s.move(s.changePosXYZ(s.changePosRoll(s.changePosPitch(posInicial,-400), 160),[posInicial.xyz(1)-2008 posInicial.xyz(2)+421 posInicial.xyz(3)-51]),1);
    %s.changePosXYZ()
    s.changeGripper(1);
    %Bajamos la pinza y cogemos la pieza
    s.move(s.changePosXYZ(s.changePosRoll(s.changePosPitch(posInicial,-400), 160),[posInicial.xyz(1)-2008 posInicial.xyz(2)+421 posInicial.xyz(3)-851]),1);
    s.changeGripper(0);
    
    %Llevamos a posicion inicial y despues final
    s.move(s.changePosXYZ(posInicial, [posInicial.xyz(1)+296 posInicial.xyz(2)-533 posInicial.xyz(3)-28]),1);
    s.move(posInicial,1);
    s.move(posFinal,1);
    
    %Vamos a posicion de aproximacion y despues a la posicion donde lo
    %soltaremos
    s.move(s.changePosXYZ(posFinal, [posFinal.xyz(1)+271 posFinal.xyz(2)+2 posFinal.xyz(3)]),1);
    s.move(s.changePosXYZ(posFinal, [posFinal.xyz(1)+271 posFinal.xyz(2)+2 posFinal.xyz(3)-1026]),1);
    s.changeGripper(1);
    %volvemos a posicion original
    s.move(s.changePosXYZ(posFinal, [posFinal.xyz(1)+271 posFinal.xyz(2)+2 posFinal.xyz(3)]),1);
    s.changeGripper(0);
    s.move(posFinal,1);
    s.move(posInicial,1);
    
   
    %Aproximacion a la tercera pieza
    s.move(posInicial,1);
    %Nos posicionamos encima y abrimos la pinza
    s.move(s.changePosXYZ(s.changePosRoll(s.changePosPitch(posInicial,-400),1040),[posInicial.xyz(1)-1093 posInicial.xyz(2)-728 posInicial.xyz(3)-816]),1);
    %s.changePosXYZ(s.changePosRoll(posInicial, 200)
    s.changeGripper(1);
    %Bajamos la pinza y cogemos la pieza
    s.move(s.changePosXYZ(s.changePosRoll(s.changePosPitch(posInicial,-400),1040),[posInicial.xyz(1)-1193 posInicial.xyz(2)-728 posInicial.xyz(3)-1116]),1);
    s.changeGripper(0);
   
   
    %Vamos a posicion de aproximacion y despues a la posicion donde lo
    %soltaremos
    s.move(s.changePosXYZ(posFinal, [posFinal.xyz(1)-100 posFinal.xyz(2)+2 posFinal.xyz(3)-426]),1);
    s.changeGripper(1);
    %volvemos a posicion original
    s.move(posFinal,1);
    s.changeGripper(0);
    
    s.home;
    
    
else
	fprintf('----> Teach the robot where is the location for picking items and press Enter to finish.\n\n');
    % Mover con pendant, y después pulsar Enter en la botonera para
    % almacenar la posición.
    % Tras guardar cada posición, salvar el fichero de posiciones
    % ¡Sólo las posiciones, no el objeto robot!
	posInicial = s.pendant();   % situar pieza para asegurarse de cogerla. Guardar x,y pieza
    posFinal = s.pendant();   % moverse en...
end

fprintf('Press any key to start picking-and-placing.\n');
pause;
