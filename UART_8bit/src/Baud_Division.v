module Baud_Division (
    input wire clk,                 // Clock input
    input wire reset,               // Reset input
    input [7:0] Baud_Division,      // Baud_Division = Frequency / (16*Baud_Rate) = 130
    output reg Baud_Tick            // output that count upto 130 
);

 // Register Interface
reg [7:0] count_reg = 0 ;

// sequential block
always @(posedge clk)
begin
    if (reset)  // reset condition
    begin
    Baud_Tick <= 0;
    count_reg <= 0;
    end
    else  
    begin
    if (Baud_Division)
    begin
    count_reg <= count_reg + 8'b1;
    Baud_Tick <= 1'b0;
   if (count_reg == Baud_Division)
    begin
        Baud_Tick <= 1'b1;
        count_reg <= 0;
    end
    end
end
end
endmodule