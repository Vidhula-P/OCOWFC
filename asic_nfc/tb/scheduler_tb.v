`include "nfc_param.vh"

module scheduler_tb;
    reg                         clk;
    reg                         rst;
    reg                         o_cmd_ready;
    reg                         i_cmd_valid;
    reg [15:0]                  i_cmd;
    reg [15:0]                  i_cmd_id;
    reg [39 : 0]                i_addr;
    reg [23 : 0]                i_len;
    reg [63 : 0]                i_data;
    reg [ 7 : 0]                i_col_num;
    reg [63 : 0]                i_col_addr_len;
    reg                         i_res_valid;
    reg [63 : 0]             i_res_data;
    reg [15 : 0]             i_res_id;
    wire                     o_res_valid;
    wire [63 : 0]            o_res_data;
    wire [15 : 0]            o_res_id;
    wire [23 : 0]            i_wdata_avail;
    wire                     i_rpage_buf_ready;
    reg                      i_page_cmd_ready;
    wire                     o_page_cmd_valid;
    wire [15 : 0]            o_page_cmd;
    wire [15 : 0]            o_page_cmd_id;
    wire [39 : 0]            o_page_addr;
    wire [63 : 0]            o_page_data;
    wire [31 : 0]            o_page_cmd_param;
    wire                     o_page_rd_not_last;
    wire [ 1 : 0]            o_page_cmd_type;


    fcc_scheduler s1 (
    .clk(clk),   
    .rst(rst),
    .o_cmd_ready(o_cmd_ready),
    .i_cmd_valid(i_cmd_valid),
    .i_cmd(i_cmd),
    .i_cmd_id(i_cmd_id),
    .i_addr(i_addr),
    .i_len(i_len),
    .i_data(i_data),
    .i_col_num(i_col_num), // additional read column number
    .i_col_addr_len(i_col_addr_len), // additional read column address and length  
    .i_res_valid(i_res_valid),
    .i_res_data(i_res_data),
    .i_res_id(i_res_id),      
    .o_res_valid(o_res_valid),
    .o_res_data(o_res_data),
    .o_res_id(o_res_id),
    .i_wdata_avail(i_wdata_avail), // availiable (bufferred) data number
    .i_rpage_buf_ready(i_rpage_buf_ready), // has enough buffer space 
    .i_page_cmd_ready(i_page_cmd_ready),
    .o_page_cmd_valid(o_page_cmd_valid),
    .o_page_cmd(o_page_cmd),
    .o_page_cmd_id(o_page_cmd_id),
    .o_page_addr(o_page_addr),
    .o_page_data(o_page_data),
    .o_page_cmd_param(o_page_cmd_param),   
    .o_page_rd_not_last(o_page_rd_not_last), 
    .o_page_cmd_type(o_page_cmd_type)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        #2 rst = 1;
        repeat(5) @(posedge clk) rst = 0;
        // read operation
        i_page_cmd_ready = 1'b1;
        wait (o_cmd_ready); 
        i_cmd_valid = 1'b1;
        i_cmd = 16'h70;
        i_cmd_id = 16'h0;
        i_addr = 40'h0;
        wait (o_page_cmd_valid);
        $display("o_page_cmd: Expected = %h, Actual= %0h", i_cmd, o_page_cmd);
        $display("o_page_cmd_id: Expected = %h, Actual= %0h", i_cmd_id, o_page_cmd_id);
        $display("o_page_addr: Expected = %h, Actual= %0h", i_addr, o_page_addr);
        $display("o_page_data: Expected = %h, Actual= %0h", 64'h0, o_page_data);
        $display("o_page_cmd_param: Expected = %h, Actual= %0h", 32'h0, o_page_cmd_param);
        $display("o_page_cmd_type: Expected = %h, Actual= %0h", 2'h0, o_page_cmd_type);
        @(posedge clk);
        i_cmd_valid = 1'b0;
        @(posedge clk);
        repeat(5) @(posedge clk);
        $finish;
    end

endmodule