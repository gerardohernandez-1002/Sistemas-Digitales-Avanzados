`timescale 1ns / 1ps

module tb_top_processor;

    // --- SEÑALES ---
    logic clk;
    logic RsRx; // Entrada a la FPGA (PC -> FPGA)
    logic RsTx; // Salida de la FPGA (FPGA -> PC)
    logic [15:0] led;

    // --- PARÁMETROS ---
    // 9600 baudios -> 1 bit dura 104.16 us = 104160 ns
    localparam BIT_PERIOD = 104160; 

    // --- DUT (Device Under Test) ---
    top_processor uut (
        .clk(clk), 
        .RsRx(RsRx), 
        .RsTx(RsTx), 
        .led(led)
    );

    // --- RELOJ (100 MHz) ---
    always #5 clk = ~clk;

    // --- TAREA PARA ENVIAR BYTES (Simula el teclado PC) ---
    task send_byte(input logic [7:0] data);
        integer i;
        begin
            // Start Bit (Bajo)
            RsRx = 0;
            #(BIT_PERIOD);
            
            // Data Bits (LSB primero)
            for (i=0; i<8; i=i+1) begin
                RsRx = data[i];
                #(BIT_PERIOD);
            end
            
            // Stop Bit (Alto)
            RsRx = 1;
            #(BIT_PERIOD);
        end
    endtask

    // --- PROCESO DE PRUEBA ---
    initial begin
        // 1. Inicialización
        clk = 0;
        RsRx = 1; // Línea serial en reposo (Alto)
        
        $display("--- INICIO DE SIMULACIÓN ---");
        
        // 2. ESPERA CRÍTICA (El arreglo del problema)
        // El menú tiene 25 caracteres. A 9600 baudios, tarda ~25ms.
        // Esperamos 30ms para estar seguros de que la FPGA terminó de hablar.
        $display("Esperando a que la FPGA imprima el menú (30ms)...");
        #(30000000); 

        // 3. Enviar Comando 'p' (Padovan)
        $display("Enviando comando 'p'...");
        send_byte("p");
        
        // Pausa pequeña entre tecleos (como un humano)
        #(BIT_PERIOD * 10);

        // 4. Enviar Valor '4'
        $display("Enviando valor '4'...");
        send_byte("4");

        // 5. Esperar Resultado
        // La FPGA debe calcular y responder. Esperamos un poco para verlo.
        #(BIT_PERIOD * 20); 

        $display("--- FIN DE SIMULACIÓN ---");
        $display("Revisa la señal 'led' y 'RsTx' en la gráfica de ondas.");
        $stop;
    end

endmodule