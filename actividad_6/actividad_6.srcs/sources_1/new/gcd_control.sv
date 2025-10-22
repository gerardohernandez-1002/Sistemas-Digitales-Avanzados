module gcd_control (
    input  logic             clk,
    input  logic             rst_n,
    input  logic             start, // Iniciar cálculo
    output logic             done,  // Cálculo terminado
    // Interfaz con Datapath
    input  logic             x_lt_y,
    input  logic             x_eq_y,
    output logic             load_initial_values,
    output logic             update_x,
    output logic             update_y
);

    typedef enum logic [1:0] { S_IDLE, S_CALC, S_DONE } state_t;
    state_t state_reg, state_next;
    logic done_reg, done_next;

    //Lógica combinacional (transición de estados y salidas)
    always_comb begin
        // Valores por defecto
        load_initial_values = 1'b0;
        update_x            = 1'b0;
        update_y            = 1'b0;
        done_next           = 1'b0;
        state_next          = state_reg;

        case (state_reg)
            S_IDLE: begin
                if (start) begin
                    load_initial_values = 1'b1;
                    state_next          = S_CALC;
                end
            end
            S_CALC: begin
                if (x_eq_y) begin
                    state_next = S_DONE;
                end
                else if (x_lt_y) begin // if (x < y)
                    update_y   = 1'b1;
                    state_next = S_CALC;
                end
                else begin // else (x > y)
                    update_x   = 1'b1;
                    state_next = S_CALC;
                end
            end
            S_DONE: begin
                done_next  = 1'b1;
                state_next = S_IDLE;
            end
            default: state_next = S_IDLE;
        endcase
    end

    // Lógica secuencial 
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state_reg <= S_IDLE;
            done_reg  <= 1'b0;
        end
        else begin
            state_reg <= state_next;
            done_reg  <= done_next;
        end
    end

    assign done = done_reg;

endmodule
