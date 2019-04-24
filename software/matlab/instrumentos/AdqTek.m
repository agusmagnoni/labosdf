function [t, V] = AdqTek(osc,CHx)
% Esta funcion entregara los siguientes vectores:
%   t (vector de tiempos, en seg)
%   V (vector de tensiones, en Volts)

% Le digo al Osc que voy a leer el canal "CHx". 
% La instruccion basica para leer el CH1, p. ej., es: 
% fprintf(osc, 'DATA:SOURCE CH1' )
fprintf( osc, ['DATA:SOURCE CH',num2str(CHx)] ); 

fprintf(osc,'DAT:ENC RPB');

fprintf(osc,'DATa:WIDth 1');

% Leo los datos del canal, y se los asigno a la variable Y.
fprintf(osc,'CURV?');
Y = binblockread(osc,'uint8'); 

% La variable Y toma valores enteros entre -127 y 128 (8 bits). Hay que 
% convertirlos a tensiones. 

% Para poder traducir Y a tensiones (V), necesito ciertas ctes de escala. 
% Tambien necesito ciertas ctes para construir el eje temporal (t). 
escalas = query(osc,'WFMPRE:XZE?;XIN?;YZE?;YMU?;YOFF?;');
esc = str2num(escalas);
XZEro = esc(1); % Me dice cual es el instante correspondiente al 1er dato.  
XINcr = esc(2); % Me dice cual es el paso de muestreo temporal. 
YZEro = esc(3); % Me dice cuanto debo adicionarle a Y para obtener V.
YMUlt = esc(4); % Me dice el factor de escala vertical (Amplificacion).
YOFFs = esc(5); % Me dice cuanto vale el corrimiento vertical (Offset).

% Para obtener V, modifico Y segun el Offset, Amplificacion y cte aditiva. 
V = (Y - YOFFs)*YMUlt + YZEro;

% Construyo el vector de tiempos
XEND = XZEro + XINcr*(length(V) - 1);
t = (XZEro : XINcr : XEND)';
end
