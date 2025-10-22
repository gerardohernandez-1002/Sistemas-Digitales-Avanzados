module gcd_top_8bit (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        start,
    input  logic [7:0]  data_in_x,
    input  logic [7:0]  data_in_y,
    output logic [7:0]  gcd_out,
    output logic        done
);

    localparam int WIDTH = 8;
    
    //CU y DP
    logic w_load_initial, w_update_x, w_update_y, w_x_lt_y, w_x_eq_y;

    //Instanciación del Datapath
    gcd_datapath #(.WIDTH(WIDTH)) u_datapath (
        .clk(clk),
        .rst_n(rst_n),
        .load_initial_values(w_load_initial),
        .update_x(w_update_x),
        .update_y(w_update_y),
        .data_in_x(data_in_x),
        .data_in_y(data_in_y),
        .gcd_out(gcd_out),
        .x_lt_y(w_x_lt_y),
        .x_eq_y(w_x_eq_y)
    );

    //Instanciación de la Unidad de Control
    gcd_control u_control (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .done(done),
        .x_lt_y(w_x_lt_y),
        .x_eq_y(w_x_eq_y),
        .load_initial_values(w_load_initial),
        .update_x(w_update_x),
        .update_y(w_update_y)
    );

endmodule
