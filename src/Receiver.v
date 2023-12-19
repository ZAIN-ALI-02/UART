module Receiver (
    input wire clk,                // Clock input
    input wire reset,              // Reset input 
    input wire R_X,
    input wire Baud_Tick,
    output reg [7:0] data_out     // Data to be Received
);

 // Register Interface
reg [1:0] c_s , n_s ;
reg [7:0] shift_reg = 0;
reg  [4:0] rx_Baud_count_reg = 0;
integer i = 0;

// Define States
    localparam IDLE  = 2'b00;
    localparam START = 2'b01;
    localparam DATA  = 2'b10;
    localparam STOP  = 2'b11;

// sequential block
always @(posedge clk)
begin
    if (reset)  // Reset condition
    begin
    c_s <= IDLE;
    end
    else
    begin
        c_s <= n_s ;
         if (Baud_Tick)
        rx_Baud_count_reg <= rx_Baud_count_reg + 1'b1;
end
end 

// combinational block
 always @(*) begin
    case(c_s)
      IDLE : begin
         n_s = R_X ? IDLE : START ;
         end
      START : begin
         if (rx_Baud_count_reg == 8 && R_X == 0) begin
         n_s = DATA;
         rx_Baud_count_reg  = 1'b0;
         end
         else n_s = START;
         end
      DATA : begin
        if (rx_Baud_count_reg == 16)begin
        shift_reg[i] = R_X;
        rx_Baud_count_reg  = 1'b0;
        i = i + 1;
        end
              if (i == 8)begin
              i = 1'b0;
              n_s = STOP ;
              end
            end
         
    STOP : begin
         if (rx_Baud_count_reg == 16)begin
         n_s = IDLE;
         rx_Baud_count_reg  = 1'b0;
         end
         else n_s = STOP;
         end
     default : begin 
         n_s = IDLE ;
         end
    endcase
  end
  initial begin
  assign data_out = shift_reg;
  end
endmodule




