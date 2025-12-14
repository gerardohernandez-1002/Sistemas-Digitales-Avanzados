module top_processor(
    input logic clk,
    input logic RsRx,
    output logic RsTx,
    output logic [15:0] led
);

    // Señales
    logic [7:0] rx_data, tx_data;
    logic rx_ready, tx_start, tx_busy;
    logic [7:0] n_val_reg;
    logic algo_sel_reg;
    logic start_calc, calc_done;
    logic [31:0] calc_result;
    
    // Instancias
    uart_rx RX (.clk(clk), .rx_serial(RsRx), .data_out(rx_data), .data_valid(rx_ready));
    uart_tx TX (.clk(clk), .start(tx_start), .data_in(tx_data), .tx_serial(RsTx), .busy(tx_busy));
    
    datapath DP (
        .clk(clk), .rst(0), .start(start_calc), 
        .n_val(n_val_reg), .algo_sel(algo_sel_reg), 
        .result(calc_result), .done(calc_done)
    );
    
    assign led = calc_result[15:0];

    typedef enum logic [3:0] {
        INIT, PRINT_MENU, WAIT_SEL, WAIT_N, 
        CALCULATE, WAIT_CALC, 
        PRINT_RESULT_LABEL, PRINT_RESULT_VAL, NEW_LINE
    } state_t;
    
    state_t state = INIT;
    
    // --- CORRECCIÓN DEFINITIVA DE VARIABLES DE TEXTO ---
    // Nota que el [0:24] está ANTES del [7:0]. Esto es vital.
    
    bit [0:24][7:0] menu_str = "Seleccione (m)oser (p)ado"; 
    bit [0:5][7:0] result_str = " Res: ";
    
    integer str_index = 0;
    
    always_ff @(posedge clk) begin
        tx_start <= 0;
        start_calc <= 0; 
        
        case(state)
            INIT: begin
                str_index <= 0;
                state <= PRINT_MENU;
            end
            PRINT_MENU: begin
                if (!tx_busy) begin
                    tx_data <= menu_str[str_index];
                    tx_start <= 1;
                    if (str_index < 24) str_index <= str_index + 1;
                    else state <= WAIT_SEL;
                end
            end
            WAIT_SEL: begin
                if (rx_ready) begin
                    tx_data <= rx_data; 
                    tx_start <= 1; 
                    if (rx_data == "m" || rx_data == "M") begin
                        algo_sel_reg <= 0; state <= WAIT_N; 
                    end else if (rx_data == "p" || rx_data == "P") begin
                        algo_sel_reg <= 1; state <= WAIT_N;
                    end
                end
            end
            WAIT_N: begin
                if (rx_ready) begin
                    tx_data <= rx_data; 
                    tx_start <= 1;
                    if (rx_data >= "0" && rx_data <= "9") begin
                        n_val_reg <= rx_data - 8'h30; 
                        state <= CALCULATE;
                    end
                end
            end
            CALCULATE: begin
                start_calc <= 1;
                state <= WAIT_CALC;
            end
            WAIT_CALC: begin
                if (calc_done) begin
                    state <= PRINT_RESULT_LABEL;
                    str_index <= 0;
                end
            end
            PRINT_RESULT_LABEL: begin
                if (!tx_busy) begin
                    tx_data <= result_str[str_index];
                    tx_start <= 1;
                    if (str_index < 5) str_index <= str_index + 1;
                    else state <= PRINT_RESULT_VAL;
                end
            end
            PRINT_RESULT_VAL: begin
                if (!tx_busy) begin
                    tx_data <= (calc_result[7:0] < 10) ? (calc_result[7:0] + 8'h30) : "X"; 
                    tx_start <= 1;
                    state <= NEW_LINE;
                end
            end
            NEW_LINE: begin
                 if (!tx_busy) begin
                    tx_data <= 8'h0A; 
                    tx_start <= 1;
                    state <= INIT;
                 end
            end
        endcase
    end
endmodule