module project1_tb;

   reg clk;
   reg rst;
   reg [1:0] choice;
   reg [15:0] paymentAmount;
   reg [15:0] ddamt;
   wire dis;
   wire successful;
   wire [15:0] paidamt;
   wire [15:0] totalcurrency;
   wire [15:0] storedExcessAmount;
   wire [15:0] storedInsufficientAmount;
   reg [3:0] currency;

   // Instantiate the DUT
   project1 dut (
      .clk(clk),
      .successful(successful),
      .paidamt(paidamt),
      .choice(choice),
      .paymentAmount(paymentAmount),
      .ddamt(ddamt),
      .totalcurrency(totalcurrency),
      .storedExcessAmount(storedExcessAmount),
      .storedInsufficientAmount(storedInsufficientAmount),
      .currency(currency),
      .rst(rst),
      .dis(dis)
   );

   // Clock generation
   always #5 clk = ~clk;

   initial begin
      clk = 0;
      rst = 0;
      choice = 2'b00;
      paymentAmount = 0;
      ddamt = 0;

      // Reset test
      #5 rst = 1;

      // Test scenario 1: DD_IN
      #5 rst = 0;
      #5 choice = 2'b01; // DD_IN
      #5   ddamt = 500;
      #20
		
       choice = 2'b01; // DD_IN
      #5   ddamt = 500;
      #20

      // Continuous monitoring
      $monitor($time,"[ dis=%b successful=%b paidamt=%b totalcurrency=%b storedExcessAmount=%b storedInsufficientAmount=%b",
                dis, successful, paidamt, totalcurrency, storedExcessAmount, storedInsufficientAmount);

   end

endmodule
