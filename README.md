# 🎯 Proyecto: Generación y Conversión de Señales PPM–PWM en FPGA Arty Z7-10

## 📘 Descripción General

Este proyecto implementa en **VHDL** un sistema digital capaz de **generar señales moduladas por posición de pulso (PPM)** y convertirlas posteriormente en **modulación por ancho de pulso (PWM)** para el **control de un servomotor SG90**.  
El desarrollo se realizó en la **FPGA Arty Z7-10 (Zynq-7000 SoC)** utilizando el entorno **Vivado Design Suite**.

La modulación PPM se utiliza para representar información mediante la **posición temporal de un pulso dentro de un marco fijo (frame)**, mientras que la modulación PWM varía el **ancho del pulso** manteniendo constante la frecuencia.  
El sistema demuestra la relación entre ambas modulaciones y su aplicación en el **control digital de actuadores**.

---

## ⚙️ Arquitectura del Sistema

El proyecto se compone de **dos bloques principales** implementados en VHDL:

### 1. Generador PPM (`ppm_generator.vhdl`)
- Genera una señal con **pulsos de 300 µs de ancho** y **frames de 20 ms**.
- La **posición del pulso dentro del frame** depende de la entrada de control (`SW`).
- Emplea **contadores sincronizados con el reloj de 100 MHz** para medir tiempos en microsegundos.
- Variables principales:
  - `clk_cnt`: genera ticks de 1 µs.
  - `us_cnt`: cuenta los microsegundos dentro de cada frame (hasta 20,000 µs).
  - `pos_us`: define la posición del pulso (ej. 1000 µs, 1500 µs, 2000 µs).
  - `ppm_out`: salida modulada.

### 2. Receptor y Conversor PPM–PWM (`ppm_receiver.vhdl`)
- Detecta los flancos de subida de la señal PPM.
- Mide el tiempo entre pulsos consecutivos para reconstruir el valor transmitido.
- Genera una señal PWM proporcional al tiempo medido:
  - 1 ms → posición mínima del servo (0°)
  - 1.5 ms → posición central (90°)
  - 2 ms → posición máxima (180°)

---

## 🧩 Funcionamiento del Sistema

1. El **bloque generador PPM** emite una secuencia de pulsos cuya posición varía según los interruptores (`SW0`, `SW1`).
2. El **bloque receptor PPM–PWM** mide la separación entre los pulsos.
3. La FPGA genera una señal PWM equivalente que **controla directamente un servomotor SG90**.
4. Se logra un **control de ángulo de 0° a 180°** sin intervención de un microcontrolador.

---

## 🎯 Objetivos del Proyecto

- **Diseñar e implementar** un generador de señal PPM y su respectivo decodificador en FPGA.  
- **Convertir** las señales PPM recibidas en señales PWM compatibles con servomotores.  
- **Validar experimentalmente** el funcionamiento del sistema mediante simulaciones y pruebas físicas en la FPGA Arty Z7-10.  
- **Demostrar** la capacidad de las FPGAs para generar y procesar señales de control de alta precisión temporal.

---

## 🧠 Fundamento Teórico

La **modulación PPM (Pulse Position Modulation)** consiste en variar la **posición temporal del pulso** dentro de un periodo fijo, manteniendo su amplitud y duración constantes.  
En cambio, la **modulación PWM (Pulse Width Modulation)** codifica la información mediante la **duración del pulso** (su ancho).  

Ambas técnicas son ampliamente utilizadas en:
- Sistemas de control remoto (RC).
- Comunicaciones ópticas y digitales.
- Control de motores y actuadores.

El FPGA permite realizar ambas modulaciones de forma precisa y completamente digital, sin depender de elementos analógicos ni microcontroladores.

---

## 🧪 Simulación y Verificación

Las simulaciones se realizaron en **Vivado Simulator**, verificando:
- Período total de **20 ms** por frame.
- Pulsos de **300 µs** de ancho.
- Posición variable (1000 µs, 1500 µs, 2000 µs) según `SW`.

Resultados esperados:
| Entrada (`SW`) | Pulso Medido (µs) | Estado del Servo |
|----------------|------------------:|------------------|
| `00`           | 1500              | Centro (90°)     |
| `01`           | 1000              | Mínimo (0°)      |
| `10`           | 2000              | Máximo (180°)    |
| `11`           | 1500              | Centro (90°)     |

---

## 🧰 Herramientas Utilizadas

- **Hardware:** FPGA Arty Z7-10 (Zynq-7000)  
- **Lenguaje:** VHDL (IEEE STD_LOGIC_1164, NUMERIC_STD)  
- **Software:** Vivado Design Suite  
- **Simulación:** Vivado Simulator  
- **Actuador:** Servomotor SG90  

---

## 🧾 Resultados

- Generación correcta de pulsos PPM con precisión de microsegundos.  
- Conversión estable PPM–PWM.  
- Control suave y estable del servomotor SG90.  
- Bajo uso de recursos lógicos y temporización correcta.

---

## 📈 Conclusión

El sistema demuestra la **viabilidad del control digital basado en modulación temporal** implementado completamente en FPGA.  
La conversión de PPM a PWM permite **integrar sistemas de comunicación y control en un solo dispositivo lógico programable**, sin necesidad de microcontroladores externos, ofreciendo **mayor precisión, velocidad y paralelismo**.

---

## 👨‍💻 Autor

**Doddy Castillo Caicedo**  
Proyecto académico – UBA /   
Implementado en **FPGA Arty Z7-10 | Vivado Design Suite**

---

