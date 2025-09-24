//Módulo para comparar secuencia de entrada y secuencia correcta
module code_comparator (
input  logic [7:0] sw,
output logic       is_correct
);
//Combinacional para verificar el código 2012
assign is_correct = (sw[7:6] == 2'b10) &&
                    (sw[5:4] == 2'b00) &&
                    (sw[3:2] == 2'b01) &&
                    (sw[1:0] == 2'b10);
endmodule
