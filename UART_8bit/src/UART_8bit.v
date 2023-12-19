// `include "Baud_Division.v"
// `include "Transmitter.v"
// `include "Receiver.v"

module uart (
    input wire clk,                // Clock input
    input wire reset,              // Reset input 
    input wire [1:0] address,      // Addresses of the registers
    input wire [7:0] w_data,      // Data to be sent
    output reg [7:0] r_data,      // Data to be received
    input wire write,             // write enable signal
    input wire read,              // read enable signal
    input wire R_X

);

 // Register Interface
reg [7:0] Baud_Division_reg = 0;
reg [7:0] tx_data_reg = 0;
wire [7:0] rx_data_reg = 0;
reg tx_enable_reg = 0;
wire  Baud_Tick ;
wire T_X;


 // define states
    localparam BD  = 2'b00;
    localparam TX_E = 2'b01;
    localparam TX_DATA  = 2'b10;
    localparam RX_DATA  = 2'b11;


// sequential block
always @(posedge clk)
begin
    if (reset)  // Reset condition
     begin
        Baud_Division_reg = 0;
        tx_data_reg = 0;
        tx_enable_reg = 0;
        r_data = 0;
    end
end

// combinational block
always @(*) begin
case(address)
      BD : begin
        if(write)begin
          Baud_Division_reg = w_data; 
            end         
         end
      TX_E : begin
        if(write)begin
          tx_enable_reg = w_data[0]; 
            end         
         end
      TX_DATA : begin
        if(write)begin
          tx_data_reg = w_data; 
            end         
         end
      RX_DATA : begin
 
        if(read)begin
          r_data = rx_data_reg; 
            end         
         end
endcase
end

// Baud Rate Interface
 Baud_Division dut_Baud_Division(
    .clk(clk),
    .reset(reset),
    .Baud_Tick (Baud_Tick),
    .Baud_Division(Baud_Division_reg)
 );

// Transmitter Interface
 Transmitter dut_Transmitter(
    .clk(clk),
    .reset(reset),
    .Baud_Tick (Baud_Tick),
    .enable(tx_enable_reg),
    .data_in(tx_data_reg),
    .T_X(T_X)
);

// Receiver Interface
 Receiver dut_Receiver(
    .clk(clk),
    .reset(reset),
    .Baud_Tick (Baud_Tick),
    .data_out(rx_data_reg),
    .R_X(T_X)
);
endmodule

