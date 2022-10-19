

A = importdata('muestras_p5.txt');
[filas,columnas] = size(A);
grid;
hold on;

x0 = 0;
y0 = 0;
theta0 = 0;
t0 = 0;
rotl0 = 0;
rotr0 = 0;

for i = 1:filas
    [x1, y1, theta1] = odometry(x0, y0,theta0, t0, rotl0, rotr0, A(i,1), ...
        A(i,2), A(i,3));
    
    plot (x1, y1, '*b')
    % Valor de orientacion en x
        ox = x1 + 0.01*cos(theta1); 
         % Valor de orientacion en y
        oy = y1 + 0.01*sin(theta1);  
        % Al poner r, la gráfica se dibuja en rojo
        plot([x1 ox], [y1 oy], '-r')     
        % Igualamos valores de las variables
        x0 = x1;
        y0 = y1;
        theta0 = theta1;   
        t0 = A(i,1);
        rotr0 = A(i,3);
        rotl0 = A(i,2);
end

hold off;