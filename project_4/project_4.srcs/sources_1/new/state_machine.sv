//Lógica de la máquina de estados.
module state_machine (
  input  logic clk,
  input  logic reset,
  input  logic check_trigger,  // Viene del botón
  input  logic code_is_correct, // Viene del comparador
  output logic unlocked_led,   // Salida para LED de éxito
  output logic failed_led     // Salida para LED de fallo
);
    //fsm state type 
    typedef enum logic [1:0] { S_IDLE, S_UNLOCKED, S_FAILED } state_type;

    //signal declaration 
    state_type state_reg, state_next;

    //state register 
    always_ff @(posedge clk, posedge reset) begin
        if (reset)
            state_reg <= S_IDLE;
        else
            state_reg <= state_next;
    end

    //next-state Logic 
    always_comb begin
        case (state_reg)
            S_IDLE: begin
                if (check_trigger && code_is_correct)
                    state_next = S_UNLOCKED;
                else if (check_trigger && !code_is_correct)
                    state_next = S_FAILED;
                else
                    state_next = S_IDLE;
            end
            S_UNLOCKED: state_next = S_UNLOCKED;
            S_FAILED:   state_next = S_FAILED;
            default:    state_next = S_IDLE;
        endcase
    end

    //Moore output Logic 
    assign unlocked_led = (state_reg == S_UNLOCKED);
    assign failed_led   = (state_reg == S_FAILED);
endmodule
