module door_lock_top (
input  logic        clk,
input  logic        reset,
input  logic [7:0]  sw,
input  logic        btn_check,
output logic [1:0]  led
);
//Señal interna para conectar el comparador con la FSM
   logic correct_code_signal;

//Instancia del módulo comparador
     code_comparator u_comparator (
        .sw(sw),
        .is_correct(correct_code_signal)
    );

//Instancia del módulo de la máquina de estados
    state_machine u_fsm (
        .clk(clk),
        .reset(reset),
        .check_trigger(btn_check),
        .code_is_correct(correct_code_signal),
        .unlocked_led(led[0]),
        .failed_led(led[1])
    );

endmodule