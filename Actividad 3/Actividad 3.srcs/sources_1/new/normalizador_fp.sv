module normalizador_fp (
 input  logic       signo_entrada,
 input  logic [4:0] exponente_entrada,
 input  logic [8:0] mantisa_entrada,
 output logic [12:0] salida_fp
);
 logic [4:0] exponente_final;
 logic [6:0] mantisa_final;
always_comb begin
//Checamos si hubo acarreo (si el bit 9 está prendido)
if (mantisa_entrada[8] == 1'b1) begin
//Si sí, el exponente crece en uno
exponente_final = exponente_entrada + 1;
//Y recorremos la mantisa para la derecha
mantisa_final = mantisa_entrada[7:1];
end 
//Si no hubo acarreo
else begin
//El exponente se queda como estaba
  exponente_final = exponente_entrada;
//Solo agarramos los 7 bits que necesitamos de la mantisa
  mantisa_final = mantisa_entrada[6:0];
  end
        
//Salida
salida_fp = {signo_entrada, exponente_final, mantisa_final};
  end
endmodule
