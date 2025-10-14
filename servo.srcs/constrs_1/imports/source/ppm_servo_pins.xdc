## Reloj 100 MHz
set_property -dict { PACKAGE_PIN H16 IOSTANDARD LVCMOS33 } [get_ports { CLK100MHZ }]
create_clock -add -name CLK100MHZ -period 10.000 -waveform {0 5} [get_ports { CLK100MHZ }]

## Switches (M20, M19)
set_property -dict { PACKAGE_PIN M20 IOSTANDARD LVCMOS33 } [get_ports { SW[0] }]
set_property -dict { PACKAGE_PIN M19 IOSTANDARD LVCMOS33 } [get_ports { SW[1] }]

## Salida servo (Y19)
set_property -dict { PACKAGE_PIN Y19 IOSTANDARD LVCMOS33 } [get_ports { SERVO_OUT }]