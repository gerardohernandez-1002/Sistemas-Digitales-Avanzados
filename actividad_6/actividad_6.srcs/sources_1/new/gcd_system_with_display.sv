module gcd_system_with_display (
    //Puertos Globales 
    input  logic        clk,
    input  logic        rst_n,       //Reset asíncrono activo-bajo
    
    //Puertos de Control de Entrada
    input  logic        start,       // Iniciar cálculo del GCD
    input  logic [7:0]  data_in_x,   // Entrada X (8 bits)
    input  logic [7:0]  data_in_y,   // Entrada Y (8 bits)
    input  logic        show_result, // Switch: 0=entradas, 1=salida
    
    //Puertos de Salida 
    output logic        done,        // Cálculo terminado
    output logic [3:0]  an,          // Ánodos del display
    output logic [6:0]  sseg         // Segmentos del display
);

    //Señales Internas 
    logic [7:0] w_gcd_out; // Salida de 8 bits del módulo GCD
    logic [3:0] w_hex3, w_hex2, w_hex1, w_hex0; // Entradas para el display
    logic       sync_reset_h; // Reset síncrono activo-alto para el display

    //Instanciación 
    gcd_top_8bit u_gcd_calc (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .data_in_x(data_in_x),
        .data_in_y(data_in_y),
        .gcd_out(w_gcd_out),
        .done(done)
    );
    
    //Sincronizador de Reset
    // Convierte rst_n (asíncrono, bajo) a sync_reset_h (síncrono, alto) para el módulo de display.
    logic rst_n_sync1, rst_n_sync2;
    always_ff @(posedge clk) begin
        rst_n_sync1 <= rst_n;
        rst_n_sync2 <= rst_n_sync1;
    end
    assign sync_reset_h = ~rst_n_sync2; //Invertido

    //Instanciación del Controlador de Display 
    display_controller u_display (
        .clk(clk),
        .reset(sync_reset_h),
        .hex3(w_hex3),
        .hex2(w_hex2),
        .hex1(w_hex1),
        .hex0(w_hex0),
        .an(an),
        .sseg(sseg)
    );

    //MUX para el Display 
    //Selecciona qué datos se envían a los displays
    always_comb begin
        if (show_result) begin
            //Mostrar Resultado "00GG" (GG = GCD)
            w_hex3 = 4'h0;
            w_hex2 = 4'h0;
            w_hex1 = w_gcd_out[7:4]; // Dígito alto del GCD
            w_hex0 = w_gcd_out[3:0]; // Dígito bajo del GCD
        end
        else begin
            //Mostrar Entradas "YYXX"
            w_hex3 = data_in_y[7:4]; // Dígito alto de Y
            w_hex2 = data_in_y[3:0]; // Dígito bajo de Y
            w_hex1 = data_in_x[7:4]; // Dígito alto de X
            w_hex0 = data_in_x[3:0]; // Dígito bajo de X
        end
    end

endmodule
