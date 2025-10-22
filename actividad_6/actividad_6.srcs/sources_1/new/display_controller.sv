module display_controller (
    input  logic        clk,
    input  logic        reset,
    input  logic [3:0]  hex3,
    input  logic [3:0]  hex2,
    input  logic [3:0]  hex1,
    input  logic [3:0]  hex0,
    output logic [3:0]  an,
    output logic [6:0]  sseg
);
    
    localparam N = 18;
    
    logic [N-1:0] q_reg, q_next;
    logic [3:0]   hex_in;

    always_ff @(posedge clk, posedge reset)
        if (reset)
            q_reg <= 0;
        else 
            q_reg <= q_next;
            
    assign q_next = q_reg + 1;
    
    always_comb
        case (q_reg[N-1:N-2])
            2'b00: begin
                an = 4'b1110;
                hex_in = hex0;
            end
            2'b01: begin
                an = 4'b1101;
                hex_in = hex1;
            end
            2'b10: begin
                an = 4'b1011;
                hex_in = hex2;
            end
            default: begin
                an = 4'b0111;
                hex_in = hex3;
            end
        endcase
        
    always_comb
    begin
        case(hex_in)
            4'h0: sseg[6:0] = 7'b0000001;
            4'h1: sseg[6:0] = 7'b1001111;
            4'h2: sseg[6:0] = 7'b0010010;
            4'h3: sseg[6:0] = 7'b0000110;
            4'h4: sseg[6:0] = 7'b1001100;
            4'h5: sseg[6:0] = 7'b0100100;
            4'h6: sseg[6:0] = 7'b0100000;
            4'h7: sseg[6:0] = 7'b0001111;
            4'h8: sseg[6:0] = 7'b0000000;
            4'h9: sseg[6:0] = 7'b0000100;
            4'ha: sseg[6:0] = 7'b0001000;
            4'hb: sseg[6:0] = 7'b1100000;
            4'hc: sseg[6:0] = 7'b0110001;
            4'hd: sseg[6:0] = 7'b1000010;
            4'he: sseg[6:0] = 7'b0110000;
            default: sseg[6:0] = 7'b0111000;
        endcase
    end
    
endmodule