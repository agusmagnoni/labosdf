# -*- coding: utf-8 -*-
"""
 Control de un osciloscopio Tektronix de la serie TBS1052B-EDU desde una 
 PC via puerto USB. Ejemplo basico.

 Para mas informacion consultar el manual: "TBS1000-EDU Programmer Manual" 
 que se encuentra en la pagina web de Tektronix y de la materia. 
"""
#import subprocess as sp
#tmp = sp.call('cls',shell=True)

import visa
import time

rm = visa.ResourceManager()
instrumentos = rm.list_resources()  

# Esto lista todos los dispositivos disponibles, uno de los cuales
# deberia ser "USB0::0x0699::0x0368::C017044::INSTR", donde los terminos
# indican "puerto::marca::modelo::nro_de_serie" del instrumento.

# Con ese nombre abro el vinculo con el osciloscopio
with rm.open_resource(instrumentos[0]) as osc:
       
    # Ahora le pido al osciloscopio algo elemental: que se identifique. 
    # Si da error, la comunicacion no esta correctamente establecida y carece 
    #   de sentido continuar ejecutando el resto del programa.
    print("IDN: " + osc.query('*IDN?'))    # Pregunta la identificacion y la escribe la identificacion en la pantalla.
    input(' Apretar cualquier tecla para continuar ')
    # EJEMPLOS DE COMUNICACION
    
    # 1) PREGUNTAMOS el modo en que esta acoplando el canal 1
    print("Acoplamiento: " + osc.query('CH1:COUPling?'))
    input(' Apretar cualquier tecla para continuar ')
    
    # 2) ESPECIFICAMOS que el acoplamiento del canal 2 (CH2) sea DC (CC en
    # castellano). 
    osc.write('CH2:COUPling DC')    # El canal queda acoplado en DC indepen-
                                    # dientemente del acoplamiento que tuviese
                                    # antes de ejecutar la instruccion. 
    input(' Apretar cualquier tecla para continuar ')
        
    # 3) PREGUNTAMOS cual es el valor numerico de la medicion 3.
    # print(osc.query('MEASU:MEAS3:VAL?'))
    # input(' Apretar cualquier tecla para continuar ')
    
#    # 4) ESPECIFICAMOS que la medicion 2 sea: valor pico a pico.
    osc.write('MEASU:MEAS2:TYPE PERIOD')    
    input(' Apretar cualquier tecla para continuar ')
    
    # 5) ESPECIFICAMOS que la fuente (SOURCE) de la medicion 4 sea el canal 2,
    # y que ademas, la medicion consista en el valor medio.
    osc.write("MEASU:CLEARSNAPSHOT")    
    osc.write('MEASU:MEAS2:SOURCE CH2')
    osc.write('MEASU:MEAS2:TYPE PK2pk')
#    osc.write('MEASU:MEAS4:TYPE PERIOD')
#    input(' Apretar cualquier tecla para continuar ')
#    
    # 6) PREGUNTAMOS cual es el valor numerico de la medicion 4.
    time.sleep(0.7)
    print("Valor: " + osc.query('MEASU:MEAS2:VAL?') )
    

del(osc)
