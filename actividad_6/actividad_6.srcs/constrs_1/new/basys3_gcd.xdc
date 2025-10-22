## Reloj 100MHz
set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} [get_ports clk]

## Switches
# data_in_x[7:0] -> SW[7:0]
set_property PACKAGE_PIN V17 [get_ports {data_in_x[0]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {data_in_x[0]}]
set_property PACKAGE_PIN V16 [get_ports {data_in_x[1]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {data_in_x[1]}]
set_property PACKAGE_PIN W16 [get_ports {data_in_x[2]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {data_in_x[2]}]
set_property PACKAGE_PIN W17 [get_ports {data_in_x[3]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {data_in_x[3]}]
set_property PACKAGE_PIN W15 [get_ports {data_in_x[4]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {data_in_x[4]}]
set_property PACKAGE_PIN V15 [get_ports {data_in_x[5]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {data_in_x[5]}]
set_property PACKAGE_PIN W14 [get_ports {data_in_x[6]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {data_in_x[6]}]
set_property PACKAGE_PIN W13 [get_ports {data_in_x[7]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {data_in_x[7]}]

# data_in_y[7:0] -> SW[14:8]
set_property PACKAGE_PIN V2 [get_ports {data_in_y[0]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {data_in_y[0]}]
set_property PACKAGE_PIN T3 [get_ports {data_in_y[1]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {data_in_y[1]}]
set_property PACKAGE_PIN T2 [get_ports {data_in_y[2]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {data_in_y[2]}]
set_property PACKAGE_PIN R3 [get_ports {data_in_y[3]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {data_in_y[3]}]
set_property PACKAGE_PIN W2 [get_ports {data_in_y[4]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {data_in_y[4]}]
set_property PACKAGE_PIN U1 [get_ports {data_in_y[5]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {data_in_y[5]}]
set_property PACKAGE_PIN T1 [get_ports {data_in_y[6]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {data_in_y[6]}]
set_property PACKAGE_PIN R2 [get_ports {data_in_y[7]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {data_in_y[7]}]

## SW15 (Switch 15) como Reset activo-bajo (rst_n)
set_property PACKAGE_PIN P1 [get_ports rst_n]
    set_property IOSTANDARD LVCMOS33 [get_ports rst_n]


## Botones
# BTNC -> start
set_property PACKAGE_PIN U18 [get_ports start]
    set_property IOSTANDARD LVCMOS33 [get_ports start]

# BTND -> show_result (botón abajo)
set_property PACKAGE_PIN T18 [get_ports show_result]
    set_property IOSTANDARD LVCMOS33 [get_ports show_result]


## LEDs
# LD0 -> done
set_property PACKAGE_PIN U16 [get_ports done]
    set_property IOSTANDARD LVCMOS33 [get_ports done]


## Display 7-Segmentos
# Anodos (seleccion de digito, activos-bajos)
set_property PACKAGE_PIN U13 [get_ports {an[0]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {an[0]}]
set_property PACKAGE_PIN K2 [get_ports {an[1]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {an[1]}]
set_property PACKAGE_PIN T14 [get_ports {an[2]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {an[2]}]
set_property PACKAGE_PIN P14 [get_ports {an[3]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {an[3]}]

# Segmentos (activos-bajos)
# sseg[6]=a, sseg[5]=b, sseg[4]=c, sseg[3]=d, sseg[2]=e, sseg[1]=f, sseg[0]=g
set_property PACKAGE_PIN W7 [get_ports {sseg[6]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {sseg[6]}]
set_property PACKAGE_PIN W6 [get_ports {sseg[5]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {sseg[5]}]
set_property PACKAGE_PIN U8 [get_ports {sseg[4]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {sseg[4]}]
set_property PACKAGE_PIN V8 [get_ports {sseg[3]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {sseg[3]}]
set_property PACKAGE_PIN U5 [get_ports {sseg[2]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {sseg[2]}]
set_property PACKAGE_PIN V5 [get_ports {sseg[1]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {sseg[1]}]
set_property PACKAGE_PIN U7 [get_ports {sseg[0]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {sseg[0]}]