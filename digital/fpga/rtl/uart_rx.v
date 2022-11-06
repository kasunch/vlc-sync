//////////////////////////////////////////////////////////////////////
// File Downloaded from http://www.nandland.com
//////////////////////////////////////////////////////////////////////
// This file contains the UART Receiver.  This receiver is able to
// receive 8 bits of serial data, one start bit, one stop bit,
// and no parity bit.  When receive is complete o_rx_done will be
// driven high for one clock cycle.
// 
// Set Parameter CLKS_PER_BIT as follows:
// CLKS_PER_BIT = (Frequency of clk)/(Frequency of UART)
// Example: 10 MHz Clock, 115200 baud UART
// (10000000)/(115200) = 87

`define UART_RX_STATE_IDLE        3'h0
`define UART_RX_STATE_START_BIT   3'h1
`define UART_RX_STATE_DATA_BITS   3'h2
`define UART_RX_STATE_STOP_BIT    3'h3
`define UART_RX_STATE_CLEANUP     3'h4 

module uart_rx(clk, i_rx_line, o_rx_done, o_rx_byte);
  
    parameter CLKS_PER_BIT   = 87;

    input clk;
    input i_rx_line;
    output       o_rx_done;
    output [7:0] o_rx_byte;
      
    reg        r_rx_dara_r = 1'b1;
    reg        r_rx_dara   = 1'b1;
    reg [15:0] r_clk_cnt = 0;
    reg [2:0]  r_bit_idx = 0; //8 bits total
    reg [7:0]  r_rx_byte = 0;
    reg        r_rx_done = 0;
    reg [2:0]  r_rx_state = 0;
   
    // Purpose: Double-register the incoming data.
    // This allows it to be used in the UART RX Clock Domain.
    // (It removes problems caused by metastability)
    always @(posedge clk) begin
        r_rx_dara_r <= i_rx_line;
        r_rx_dara   <= r_rx_dara_r;
    end
   
    // Purpose: Control RX state machine
    always @(posedge clk) begin
        case (r_rx_state)
            `UART_RX_STATE_IDLE: begin
                r_rx_done <= 1'b0;
                r_clk_cnt <= 0;
                r_bit_idx <= 0;
                  
                if (r_rx_dara == 1'b0) // Start bit detected
                    r_rx_state <= `UART_RX_STATE_START_BIT;
                else
                    r_rx_state <= `UART_RX_STATE_IDLE;
            end
            
            // Check middle of start bit to make sure it's still low
            `UART_RX_STATE_START_BIT: begin
                if (r_clk_cnt == (CLKS_PER_BIT-1)/2) begin
                    if (r_rx_dara == 1'b0) begin
                        r_clk_cnt <= 0;  // reset counter, found the middle
                        r_rx_state <= `UART_RX_STATE_DATA_BITS;
                    end
                    else
                        r_rx_state <= `UART_RX_STATE_IDLE;
                end
                else begin
                    r_clk_cnt <= r_clk_cnt + 16'd1;
                    r_rx_state <= `UART_RX_STATE_START_BIT;
                end
            end 
            
            // Wait CLKS_PER_BIT-1 clock cycles to sample serial data
            `UART_RX_STATE_DATA_BITS: begin
                if (r_clk_cnt < CLKS_PER_BIT-1) begin
                    r_clk_cnt <= r_clk_cnt + 16'd1;
                    r_rx_state <= `UART_RX_STATE_DATA_BITS;
                end
                else begin
                    r_clk_cnt <= 0;
                    r_rx_byte[r_bit_idx] <= r_rx_dara;
                    // Check if we have received all bits
                    if (r_bit_idx < 7) begin
                        r_bit_idx <= r_bit_idx + 3'd1;
                        r_rx_state   <= `UART_RX_STATE_DATA_BITS;
                    end
                    else begin
                        r_bit_idx <= 0;
                        r_rx_state <= `UART_RX_STATE_STOP_BIT;
                    end
                  end
            end 

            // Receive Stop bit.  Stop bit = 1
            `UART_RX_STATE_STOP_BIT: begin
                // Wait CLKS_PER_BIT-1 clock cycles for Stop bit to finish
                if (r_clk_cnt < CLKS_PER_BIT-1) begin
                    r_clk_cnt <= r_clk_cnt + 16'd1;
                    r_rx_state <= `UART_RX_STATE_STOP_BIT;
                end
                else begin
                    r_rx_done <= 1'b1;
                    r_clk_cnt <= 0;
                    r_rx_state <= `UART_RX_STATE_CLEANUP;
                end
            end

            // Stay here 1 clock
            `UART_RX_STATE_CLEANUP: begin
                r_rx_state <= `UART_RX_STATE_IDLE;
                r_rx_done <= 1'b0;
            end
            
            default :
                r_rx_state <= `UART_RX_STATE_IDLE;
        endcase
    end   
   
    assign o_rx_done   = r_rx_done;
    assign o_rx_byte = r_rx_byte;
   
endmodule // uart_rx
