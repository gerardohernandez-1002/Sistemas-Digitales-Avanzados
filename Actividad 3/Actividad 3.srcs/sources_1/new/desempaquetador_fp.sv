module desempaquetador_fp (
 input  logic [12:0] entrada_fp,
 output logic        salida_signo,
 output logic [4:0]  salida_exponente,
 output logic [7:0]  salida_mantisa_completa
);

// El bit 12 es el del signo
 assign salida_signo = entrada_fp[12];
    
// Los siguientes 5 bits son para el exponente
 assign salida_exponente  = entrada_fp[11:7];
    
// Le pegamos el 1 que viene implícito a los 7 bits de la mantisa
 assign salida_mantisa_completa = {1'b1, entrada_fp[6:0]};

endmodule