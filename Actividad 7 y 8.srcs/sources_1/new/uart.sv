// Módulo de Transmisión (FPGA -> PC)
module uart_tx #(
    parameter CLKS_PER_BIT = 10417
)(
    input logic clk,
    input logic start,          // Pulso para iniciar transmisión
    input logic [7:0] data_in,  // Byte a enviar
    output logic tx_serial,     // Salida al pin RS232_TX
    output logic busy           // '1' mientras transmite
);
    typedef enum logic [1:0] {IDLE, START_BIT, DATA_BITS, STOP_BIT} state_t;
    state_t state = IDLE;
    
    integer clk_count = 0;
    integer bit_index = 0;
    logic [7:0] data_temp;

    always_ff @(posedge clk) begin
        case (state)
            IDLE: begin
                tx_serial <= 1'b1; // Línea en alto (idle)
                busy <= 1'b0;
                clk_count <= 0;
                bit_index <= 0;
                if (start) begin
                    data_temp <= data_in;
                    state <= START_BIT;
                    busy <= 1'b1;
                end
            end
            
            START_BIT: begin
                tx_serial <= 1'b0; // Bit de inicio (bajo)
                if (clk_count < CLKS_PER_BIT-1) begin
                    clk_count <= clk_count + 1;
                end else begin
                    clk_count <= 0;
                    state <= DATA_BITS;
                end
            end
            
            DATA_BITS: begin
                tx_serial <= data_temp[bit_index];
                if (clk_count < CLKS_PER_BIT-1) begin
                    clk_count <= clk_count + 1;
                end else begin
                    clk_count <= 0;
                    if (bit_index < 7) begin
                        bit_index <= bit_index + 1;
                    end else begin
                        bit_index <= 0;
                        state <= STOP_BIT;
                    end
                end
            end
            
            STOP_BIT: begin
                tx_serial <= 1'b1; // Bit de parada (alto)
                if (clk_count < CLKS_PER_BIT-1) begin
                    clk_count <= clk_count + 1;
                end else begin
                    state <= IDLE;
                end
            end
        endcase
    end
endmodule

// Módulo de Recepción (PC -> FPGA)
module uart_rx #(
    parameter CLKS_PER_BIT = 10417
)(
    input logic clk,
    input logic rx_serial,      // Entrada del pin RS232_RX
    output logic [7:0] data_out,// Byte recibido
    output logic data_valid     // Pulso cuando se recibe un byte completo
);
    typedef enum logic [1:0] {IDLE, START_BIT, DATA_BITS, STOP_BIT} state_t;
    state_t state = IDLE;
    
    integer clk_count = 0;
    integer bit_index = 0;
    logic [7:0] temp_data;

    always_ff @(posedge clk) begin
        data_valid <= 1'b0;
        
        case (state)
            IDLE: begin
                clk_count <= 0;
                bit_index <= 0;
                if (rx_serial == 1'b0) begin // Detectar Start Bit (bajada)
                    state <= START_BIT;
                end
            end
            
            START_BIT: begin
                // Esperar medio bit para muestrear en el centro
                if (clk_count < (CLKS_PER_BIT-1)/2) begin
                    clk_count <= clk_count + 1;
                end else begin
                    if (rx_serial == 1'b0) begin
                        clk_count <= 0;
                        state <= DATA_BITS;
                    end else begin
                        state <= IDLE; // Falsa alarma
                    end
                end
            end
            
            DATA_BITS: begin
                if (clk_count < CLKS_PER_BIT-1) begin
                    clk_count <= clk_count + 1;
                end else begin
                    clk_count <= 0;
                    temp_data[bit_index] <= rx_serial;
                    if (bit_index < 7) begin
                        bit_index <= bit_index + 1;
                    end else begin
                        bit_index <= 0;
                        state <= STOP_BIT;
                    end
                end
            end
            
            STOP_BIT: begin
                if (clk_count < CLKS_PER_BIT-1) begin
                    clk_count <= clk_count + 1;
                end else begin
                    data_valid <= 1'b1; // ¡Dato listo!
                    data_out <= temp_data;
                    state <= IDLE;
                end
            end
        endcase
    end
endmodule