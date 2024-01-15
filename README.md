# Maquina-Expendedora
Trabajo final de tecnología de computadores
# 1. INTRODUCCIÓN
En este proyecto, se aborda el diseño del sistema de control destinado a una máquina expendedora de bebidas especializada en la venta de latas a un precio de 2€ aceptando monedas de 1€ y 2€, así como billetes de 5€. La implementación se realiza mediante una máquina de estados síncrona en el lenguaje de descripción de hardware VHDL, permitiendo una gestión eficiente y precisa de las transacciones y asegurando la devolución de cambio de manera adecuada.

# 2. DESCRIPCIÓN DEL TRABAJO
1. Primero dibujé un diagrama de estados para saber cuántos estados necesitaría para la máquina expendedora.
<p align="center">
<img width="654" alt="Diagrama1" src="https://github.com/Franguti4k/Maquina-Expendedora/blob/main/Imagenes/Captura%20de%20pantalla%20(854).png">
</p>

2. Después de dibujar el diagrama de estados, empecé a escribir el código de la máquina expendedora y a crear la lógica de la máquina de estados basándome en el diagrama que dibujé.
3. A continuación, escribí el Test Bench de la máquina expendedora para probar que todo funciona correctamente.
4. Por último, realicé la simulación de la máquina expendedora. Estuve haciendo pruebas para encontrar errores y solucionarlos hasta llegar al código final con la solución.

# 3. EXPLICACIÓN DE LOS CÓDIGOS VHDL
## Explicación del código de `MaquinaExpendedora.vhdl`:
### Entidad:
Se define la entidad `MaquinaExpendedora` con los siguientes puertos:
- CLOCK: Entrada para la señal de reloj.
- RESET: Entrada para la señal de reinicio.
- COIN_IN: Entrada de 3 bits que representa las monedas/billetes introducidos.
- COIN_OUT: Salida de 3 bits que representa las monedas devueltas.
- LATA: Salida que indica si la lata está siendo dispensada (1) o no (0).
### Arquitectura:
La arquitectura Behavioral implementa la lógica del comportamiento de la máquina expendedora.
- Estados y Señales:
  - Estado: Enumeración que define los estados posibles de la máquina (S0, S1, S2).
  - TipoMoneda: Enumeración que representa los tipos de moneda/billete (NADA, UNEURO, DOSEUROS, CINCOEUROS).
  - estado_actual y estado_siguiente: Señales que almacenan el estado actual y el próximo estado de la máquina.
  - moneda_introducida: Señal que almacena el tipo de moneda/billete introducido.
  - total_introducido, precio_lata: Variables enteras que almacenan información sobre el dinero total introducido y el precio de la lata.
- Proceso 1: Control de Estado y Reinicio:
  - Detecta el flanco de subida del reloj (`rising_edge(CLOCK)`) y actualiza el estado actual.
  - En caso de reinicio (`RESET = '1'`), se reinician algunas variables y se establece el estado inicial.
- Proceso 2: Lógica de la Máquina Expendedora:
  - Basado en el estado actual, se define un comportamiento específico para cada estado usando una estructura case.
  - En el estado S0 (Inicio), se procesan las monedas introducidas y se cambia al estado siguiente según la moneda introducida.
  - En el estado S1 (Cuando metes 1€), se procesan las monedas introducidas y se cambia al estado siguiente según la moneda introducida.
  - En el estado S2 (Expulsa la lata y cambio), se dispensa la lata si el dinero introducido es suficiente y se devuelve el cambio apropiado.
  - En el caso de otros estados, la máquina se reinicia al estado S0.

## Explicación del código de `Maquina_expendedora_tb.vhdl`:
### Entidad del Testbench:
Se define la entidad `Maquina_expendedora_tb` sin puertos, ya que los puertos que se están probando son los de la entidad `MaquinaExpendedora`.
### Arquitectura del Testbench:
- Señales de Entrada/Salida y Constantes:
  - CLOCK_TB, RESET_TB: Señales de reloj y reinicio para controlar el tiempo en la simulación.
  - COIN_IN_TB: Señal de entrada que simula las monedas/billetes introducidos.
  - COIN_OUT_TB, LATA_TB: Señales de salida que representan las monedas devueltas y el estado de dispensación de la lata.
  - CLOCK_PERIOD: Constante que define el período del reloj.
- Componente MaquinaExpendedora:
  - Se instancia la entidad `MaquinaExpendedora` como el Dispositivo Bajo Prueba (DUT).
  - Los puertos del DUT están conectados a las señales definidas en el testbench.
- Procesos de Simulación:
  - Generación de Reloj:
    - Se simula un reloj mediante un proceso que alterna entre '0' y '1' cada mitad del período definido por `CLOCK_PERIOD`.
  - Generación de RESET:
    - Se simula un pulso de reset: `RESET_TB` se establece a '0' durante dos períodos de reloj, luego se activa a '1' y luego se desactiva nuevamente a '0'. Después, se espera indefinidamente.
  - Pruebas de Monedas/Billetes Introducidos:
    - Se realizan varias pruebas de introducción de monedas/billetes en la máquina expendedora, con diferentes secuencias de entrada (`COIN_IN_TB`) y se simula el estado de la máquina.

# 4. TAREA OPCIONAL DE AMPLIACIÓN
Para hacer las modificaciones volví a dibujar el diagrama de estados añadiendo un nuevo estado S3 para cuando la máquina está vacía.

<p align="center">
<img width="654" alt="Diagrama2" src="https://github.com/Franguti4k/Maquina-Expendedora/blob/main/Imagenes/Captura%20de%20pantalla%20(855).png">
</p>

# 5. MODIFICACIONES Y AMPLIACIONES
Estas son las modificaciones que le hice al código para el conteo y para indicar que la máquina está vacía.

### Entidad:
He añadido la salida:
- EMPTY: Salida que indica si la máquina está vacía (1) o no (0).

### Arquitectura:
- Estados y Señales:
  - Estado: He añadido el estado S3 para cuando la máquina esté vacía.
  Además, he añadido:
  - `inventario_empty`: Señal que indica si el inventario de latas está vacío (1) o no (0).
  - `inventario_actual` e `inventario_restante`: Variables enteras que almacenan, una, el número de latas que hay en la máquina expendedora y la otra, resta 1 a `inventario_actual` cuando se compra una lata.

- Proceso 1: Control de Estado y Reinicio:
  - Resta el inventario restante del inventario actual.
  - En caso de reinicio (`RESET = '1'`), además de lo anterior, se reinicia `inventario_actual` con 5 latas (aunque sean 3 pero puse 5 para hacer más pruebas).

- Proceso 2: Lógica de la Máquina Expendedora:
  Además de los otros estados…
  - En el estado S3 (Máquina vacía), la máquina devuelve las monedas introducidas y se establece la señal `EMPTY`.

- Actualización de `inventario_empty`:
  - `inventario_empty` se actualiza según `inventario_actual`. Si el inventario es igual a cero, la máquina se considera vacía y pasaríamos al estado S3.

El sistema de conteo y la señal de `EMPTY` funciona de la siguiente forma:
Cuando la máquina de estados entra en el estado S2 y dispensa una lata se establece 1 a `inventario_restante` para que luego en el siguiente ciclo de reloj le reste uno a `inventario_actual`. Después, en el estado S0 se establece 1 a `inventario_restante`. Cuando ya no quedan latas (`inventario_actual = 0`), la señal `inventario_empty` se activa. Cuando la máquina de estados está en el estado S0 si `inventario_empty` está activo la máquina de estados entra en S3 y activa la salida `EMPTY` para indicar que la máquina expendedora está vacía. En el estado S3, la máquina expendedora devuelve las monedas que introduces ya que está vacía. Cuando se activa el RESET, la máquina vuelve a tener 5 latas (`inventario_actual = 5`) y se desactiva la señal `inventario_empty` y la salida `EMPTY`.

Y estas son las modificaciones que le hice al Test Bench:

### Arquitectura del Testbench:
- Señales de Entrada/Salida y Constantes:
  - EMPTY_TB: Señal de salida que representa si la máquina está vacía.

- Procesos de Simulación:
  - Pruebas de Devolución de Monedas:
    Después de que la máquina expendedora queda vacía, se simula la introducción de diferentes monedas/billetes (`COIN_IN_TB`) y se verifica que la máquina devuelva las monedas correctamente (`COIN_OUT`).

# 6. ESQUEMA DEL CIRCUITO DE LA MÁQUINA
<p align="center">
<img width="654" alt="Esquema Circuito" src="https://github.com/Franguti4k/Maquina-Expendedora/blob/main/Imagenes/IMG_20240105_121412.png">
</p>

# 7. SIMULACIÓN
<p align="center">
<img width="654" alt="Simulacion1" src="https://github.com/Franguti4k/Maquina-Expendedora/blob/main/Imagenes/IMG_20240103_120837.png">
</p>
<p align="center">
<img width="654" alt="Simulacion2" src="https://github.com/Franguti4k/Maquina-Expendedora/blob/main/Imagenes/IMG_20240103_120924.png">
</p>

# 8. CONCLUSIÓN
En mi opinión, el diseño del sistema de control para la máquina expendedora de bebidas ha sido una experiencia fascinante y desafiante. Abordar este proyecto me ha permitido aplicar de manera práctica los conceptos teóricos aprendidos en tecnología de computadores. El enfoque en una máquina de estados síncrona ha demostrado ser una metodología efectiva para comprender y organizar el funcionamiento del sistema de manera secuencial.

En definitiva, este proyecto no solo ha sido un ejercicio técnico, sino también una oportunidad para desarrollar habilidades prácticas y creativas.

