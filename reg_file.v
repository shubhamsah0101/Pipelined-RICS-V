module reg_file(
    input wire clk,
    input wire rst,
    input wire write_en,
    input wire [4:0] write_addr,
    input wire [31:0] write_data,
    input wire [4:0] read_addr1,
    input wire [4:0] read_addr2,
    output reg [31:0] read_data1,
    output reg [31:0] read_data2
);

    reg [31:0] registers [0:31];
    integer i;
    
    initial begin
        for (i = 0; i < 32; i = i + 1)
            registers[i] = 32'd0;
    end
    
    always @(posedge clk) begin
        if (write_en && (write_addr != 5'd0))
            registers[write_addr] <= write_data;
    end
    
    always @(*) begin
        if (!rst) begin
            read_data1 = 32'd0;
            read_data2 = 32'd0;
        end else begin
            read_data1 = registers[read_addr1];
            read_data2 = registers[read_addr2];
        end
    end

endmodule