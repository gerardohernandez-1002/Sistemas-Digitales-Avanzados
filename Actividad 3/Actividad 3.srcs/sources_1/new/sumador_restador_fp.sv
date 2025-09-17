// sumador_restador_fp.sv
module sumador_restador_fp (
  input  logic       signo_a,
  input  logic [7:0] mantisa_a,
  input  logic       signo_b,
  input  logic [7:0] mantisa_b,
  output logic       signo_salida,
//La salida es de 9 bits por si al sumar nos pasamos (acarreo)
  output logic [8:0] mantisa_resultado
);
  always_comb begin
//Si los signos son iguales, los sumamos
  if (signo_a == signo_b) begin
  mantisa_resultado = {1'b0, mantisa_a} + {1'b0, mantisa_b};
  signo_salida = signo_a; // El signo se queda igual
  end 
//Si no, los restamos
  else begin
//Restamos el más pequeño del más grande
  if (mantisa_a >= mantisa_b) begin
  mantisa_resultado = {1'b0, mantisa_a} - {1'b0, mantisa_b};
  signo_salida = signo_a; //El signo es el del número más grande
  end 
  else begin
  mantisa_resultado = {1'b0, mantisa_b} - {1'b0, mantisa_a};
  signo_salida = signo_b;
    end
    end
    end

endmodule