function [x1,y1,theta1] = odometry(x0,y0,theta0,t0, rotl0,rotr0,t1,rotl1,rotr1)
    D = 0.12;
    R = 0.028;
    vT = t1 - t0;
    
    if vT == 0 %Se devuelve lo mismo en caso de que no varie el tiempo
         x1 = x0;
         y1 = y0;
         theta1 = theta0;
    else %En caso de variar el tiempo se calcula
        %Convertimos angulos de grados a radianes
        radRotr = deg2rad(rotr1) - deg2rad(rotr0);
        radRotl = deg2rad(rotl1) - deg2rad(rotl0);  
   
        % valor Theta con variacion
        theta1 = double(theta0) + (((radRotr*R) - (radRotl*R))./D);
        % valor X con variacion
        x1 = x0 + (((radRotr.*R + radRotl.*R)./2).*cos(theta0)); 
        % valor Y con variacion
        y1 = y0 + (((radRotr.*R + radRotl.*R)./2).*sin(theta0));  
    end


end