module datapath(
    input logic clk,
    input logic rst,
    input logic start,
    input logic [7:0] n_val,
    input logic algo_sel,           // 0: Moser, 1: Padovan
    output logic [31:0] result,
    output logic done
);

    // --- MOSER-DE BRUIJN ---
    logic [31:0] moser_res;
    always_comb begin
        moser_res = 32'b0;
        for(int i=0; i<8; i++) begin
            moser_res[2*i] = n_val[i];
        end
    end

    // --- PADOVAN ---
    // Inicialización solo en variables internas (permitido)
    logic [31:0] p1 = 1, p2 = 1, p3 = 1;
    logic [31:0] next_val;
    logic [7:0] count;
    logic active_padovan = 0; 

    // OJO: Eliminamos "initial result = 0" para que la simulación ABRA.
    // result iniciará en rojo (X) y se corregirá solo cuando empiece el cálculo.

    always_ff @(posedge clk) begin
        if (rst) begin
            result <= 0;
            done <= 0;
            active_padovan <= 0;
        end 
        else if (start) begin
            done <= 0;
            if (algo_sel == 0) begin
                result <= moser_res; // Aquí se pondrá verde
                done <= 1; 
                active_padovan <= 0;
            end 
            else begin
                if (n_val <= 2) begin
                    result <= 1;     // O aquí
                    done <= 1;
                    active_padovan <= 0;
                end else begin
                    p1 <= 1; p2 <= 1; p3 <= 1;
                    count <= 3;
                    active_padovan <= 1; 
                end
            end
        end 
        else if (active_padovan) begin
            if (count <= n_val) begin
                next_val = p2 + p3; 
                p3 <= p2;
                p2 <= p1;
                p1 <= next_val;
                count <= count + 1;
            end else begin
                result <= p1;
                done <= 1;
                active_padovan <= 0;
            end
        end 
        else begin
            done <= 0; 
        end
    end
endmodule