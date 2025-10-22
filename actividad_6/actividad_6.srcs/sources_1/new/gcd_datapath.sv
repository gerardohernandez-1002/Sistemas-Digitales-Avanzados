module gcd_datapath #(
    parameter int WIDTH = 8
)(
    input  logic             clk,
    input  logic             rst_n,
    input  logic             load_initial_values, // Cargar data_in_x/y
    input  logic             update_x,            // x = x - y
    input  logic             update_y,            // y = y - x
    input  logic [WIDTH-1:0] data_in_x,
    input  logic [WIDTH-1:0] data_in_y,
    output logic [WIDTH-1:0] gcd_out,
    output logic             x_lt_y,              // x < y
    output logic             x_eq_y               // x == y
);

    logic [WIDTH-1:0] x_reg, y_reg;
    logic [WIDTH-1:0] x_minus_y, y_minus_x;

    //Lógica combinacional 
    assign x_minus_y = x_reg - y_reg;
    assign y_minus_x = y_reg - x_reg;

    //Lógica secuencial 
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            x_reg <= '0;
            y_reg <= '0;
        end
        else begin
            if (load_initial_values) begin
                x_reg <= data_in_x;
                y_reg <= data_in_y;
            end
            else if (update_x) begin
                x_reg <= x_minus_y; // x = x - y
            end
            else if (update_y) begin
                y_reg <= y_minus_x; // y = y - x
            end
        end
    end

    //Asignación de salidas de estado y resultado
    assign x_lt_y = (x_reg < y_reg);
    assign x_eq_y = (x_reg == y_reg);
    assign gcd_out = x_reg; 

endmodule
