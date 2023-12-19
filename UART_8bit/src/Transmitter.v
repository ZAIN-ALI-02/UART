module Transmitter (
    input wire clk,                // Clock input
    input wire reset,              // Reset input 
    input wire enable,             // Enable to start operation
    input wire [7:0] data_in,      // Data to be sent
    input wire Baud_Tick,
    output reg T_X                
);

 // Register Interface
reg [1:0] c_s , n_s ;
reg [7:0] shift_reg = 0;
reg [7:0] receiver_reg = 0;
reg  [4:0] Baud_count_reg = 0;
integer i = 0;
     
    // Define States
    localparam IDLE  = 2'b00;
    localparam START = 2'b01;
    localparam DATA  = 2'b10;
    localparam STOP  = 2'b11;

// sequential block
always @(posedge clk)
begin
    if (reset) // Reset condition
    begin
    c_s <= IDLE;
    end
    else  
    begin
        c_s <= n_s;
        if (Baud_Tick)
        Baud_count_reg <= Baud_count_reg + 1'b1;
       else
      begin
      if (Baud_count_reg == 16)begin
         Baud_count_reg <= 0;
        end
        end
end
end

// combinational block
  always @(*) begin
    case(c_s)
      IDLE : begin
         n_s = enable ? START : IDLE ;
         T_X = 1'b1;
         shift_reg = data_in;
         end
      START : begin
         T_X = 1'b0;
         if (Baud_count_reg == 16)
         n_s = DATA;
         else n_s = START;
         end
      DATA : begin
         T_X = shift_reg[i];
         if (Baud_count_reg == 16)
            i = i + 1;
              if (i == 8)begin
              i = 1'b0;
              n_s = STOP ;
              end
         end
    STOP : begin
          T_X = 1'b1;
         if (Baud_count_reg == 16)
         n_s = IDLE;
         else n_s = STOP;
         end
     default : begin 
         n_s = IDLE ;
         T_X = 1'b1 ;
         end
    endcase
  end
endmodule

