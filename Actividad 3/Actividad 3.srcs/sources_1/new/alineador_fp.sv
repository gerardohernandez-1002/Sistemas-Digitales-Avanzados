module alineador_fp (
 input  logic [4:0] exponente_a,
 input  logic [7:0] mantisa_a,
 input  logic [4:0] exponente_b,
 input  logic [7:0] mantisa_b,

 output logic [4:0] exponente_salida, //El exponente ya alineado (el más grande)
 output logic [7:0] mantisa_a_salida,
 output logic [7:0] mantisa_b_salida
);
//Para guardar la diferencia entre los exponentes
logic [4:0] diferencia_exp;

always_comb begin
//Vemos cuál exponente es el más grande
if (exponente_a >= exponente_b) 
begin
diferencia_exp = exponente_a - exponente_b;
exponente_salida = exponente_a; // El más grande se queda
mantisa_a_salida = mantisa_a;   // La mantisa del grande no cambia
mantisa_b_salida = mantisa_b >> diferencia_exp; // La chica se recorre
end 
else 
    begin
diferencia_exp = exponente_b - exponente_a;
exponente_salida = exponente_b;
mantisa_b_salida = mantisa_b;
mantisa_a_salida = mantisa_a >> diferencia_exp;
    end
end
endmodule