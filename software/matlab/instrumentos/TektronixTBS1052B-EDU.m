% Osciloscopio Tektronix TBS 1052B-EDU

% Adquiere los datos de los canales 1 y/o 2.
% Laboratorio 3, 1er Cuatrimestre 2017, DF, FCEN, UBA.
% Cesar Moreno

%% Establezco la comunicacion

if(exist('osc') == 1)
    % Si el canal de comunicacion ya esta abierto, NO LO ABRO NUEVAMENTE.
    disp('La comunicacion ya esta abierta')
else
    % Si el canal de comunicacion aun no esta abiero, lo DEFINO ahora. 
    % Uso un puerto USB de la PC y el protocolo denominado: 
    % Virtual Instrument Software Architecture (VISA). 
    osc = visa('ni','USB0::0x0699::0x0368::C017044::INSTR')
    
    % Se necesita incrementar el tama#o del buffer de comunicacion para 
    % poder recabar/adquirir señales extensas.
    set(osc,'InputBufferSize',20000)
    
    % Finalmente ABRO la comunicacion con el instrumento.
    fopen(osc);
end

%% Prueba de que la communicacion funciona correctamente
% Ahora le pido al osciloscopio algo elemental: que se identifique. 
% Si da error, la comunicacion no esta correctamente establecida y carece 
%   de sentido continuar ejecutando el resto del programa.
fprintf(osc,'*IDN?')    % Pregunta la identificacion.       
ID = fscanf(osc)        % Escribe la identificacion en la pantalla.


%% Ahora adquiero ambos canales. Uso la funcion AdqTek
[t, v1] = AdqTek(osc,1); % Lee CH1
[t, v2] = AdqTek(osc,2); % Lee CH2

%% Grafico
plot(t,v1,t,v2) % Grafica ambas señales
grid on         % Coloca grillas en ambos ejes
xlabel('t (seg)') % Coloca leyenda en el eje x
ylabel('V1, V2 (volt)') % Coloca leyenda en el eje y
title('V1 y V2 en funcion del tiempo') % Coloca titulo al grafico

%% Grabo el resultado en el HD
% Grabamos el resultado de la adquisicion en un archivo de texto llamado
% adq1.txt. No es necesario que tal archivo exista: si no existe, lo
% crea en el directorio de trabajo; si existe en dicho directorio, lo 
% sobreescribe.
save adq1.txt t v1 v2 -ASCII

%% Cierro la comunicacion con el osciloscopio
% fclose(osc); 
% clear osc
