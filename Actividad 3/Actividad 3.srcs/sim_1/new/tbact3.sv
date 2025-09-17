`timescale 1ns/1ps

module tb_sumador_consola;

//Señales
    logic [12:0] a_prueba;
    logic [12:0] b_prueba;
    wire [12:0] c_resultado;

//Instancia del Diseño
    sumador_fp mi_sumador (
        .entrada_a(a_prueba),
        .entrada_b(b_prueba),
        .salida_c(c_resultado)
    );

//Bloque de simulación
    initial begin
        a_prueba = 13'b0_10000_0100000; // 2.5
        b_prueba = 13'b0_01111_1000000; // 1.5
        #10;
        $display("%b + %b = %b", a_prueba, b_prueba, c_resultado);

         a_prueba = 13'b0_10001_0100000; // 5.0
        b_prueba = 13'b1_10000_1000000; // -3.0
        #10;
        $display("%b + %b = %b", a_prueba, b_prueba, c_resultado);

          a_prueba = 13'b0_10001_1000000; // 6.0
        b_prueba = 13'b0_10001_1000000; // 6.0
        #10;
        $display("%b + %b = %b", a_prueba, b_prueba, c_resultado);
        

        $finish;
    end

endmodule