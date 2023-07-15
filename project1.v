module project1(clk, successful, paidamt, choice, paymentAmount, ddamt, totalcurrency, storedExcessAmount, storedInsufficientAmount, currency, rst, dis);
   output reg dis;
   output reg successful;
   output reg [15:0] paidamt;
   input wire [3:0] currency;
   input wire clk, rst;
   input wire [1:0] choice;
   input wire [15:0] paymentAmount;
   input wire [15:0] ddamt;
   output reg [15:0] totalcurrency;
   output reg [15:0] storedExcessAmount;
   output reg [15:0] storedInsufficientAmount;
   reg [2:0] state;
   reg [2:0] next_state;
   reg [15:0] currentAmount;
   reg [15:0] excessAmount;
   reg [15:0] insufficientAmount;
   reg [15:0] amt;
   reg [15:0] due;

   parameter [2:0] IDLE = 3'b000;
   parameter [2:0] DD_IN = 3'b001;
   parameter [2:0] CURRENCY_IN = 3'b010;
   parameter [2:0] CALCULATIONS = 3'b011;
   parameter [2:0] SUCCESS = 3'b100;
   parameter [2:0] FAILED = 3'b101;

   always @(posedge clk)
   begin
      if (rst)
         state <= IDLE;
      else
         state <= next_state;
   end

   always @(*)
   begin
      case (state)
         IDLE:
         begin
            dis <= 1'b0;
            successful <= 1'b0;
            totalcurrency <= 16'd0;
            paidamt <= 16'd0;
            if (choice == 2'b01)
               next_state = DD_IN;
            else if (choice == 2'b10)
               next_state = CURRENCY_IN;
         end

         DD_IN:
         begin
            currentAmount <= ddamt;
            next_state = CALCULATIONS;
         end

         CURRENCY_IN:
         begin
            case (currency)
               4'b0001:
               begin
                  currentAmount <= currentAmount + 16'd5; // Currency 5
                  next_state = CURRENCY_IN;
               end
               4'b0010:
               begin
                  currentAmount <= currentAmount + 16'd10; // Currency 10
                  next_state = CURRENCY_IN;
               end
               4'b0011:
               begin
                  currentAmount <= currentAmount + 16'd20; // Currency 20
                  next_state = CURRENCY_IN;
               end
               4'b0100:
               begin
                  currentAmount <= currentAmount + 16'd50; // Currency 50
                  next_state = CURRENCY_IN;
               end
               4'b0101:
               begin
                  currentAmount <= currentAmount + 16'd100; // Currency 100
                  next_state = CURRENCY_IN;
               end
               4'b0110:
               begin
                  currentAmount <= currentAmount + 16'd500; // Currency 500
                  next_state = CURRENCY_IN;
               end
               4'b0111:
               begin
                  currentAmount <= currentAmount + 16'd1000; // Currency 1000
                  next_state = CURRENCY_IN;
               end
               4'b1000:
               begin
                  currentAmount <= currentAmount;
                  next_state = CALCULATIONS;
               end
               default:
               begin
                  currentAmount <= currentAmount; // Invalid currency
                  next_state = CURRENCY_IN;
               end
            endcase
         end

         CALCULATIONS:
         begin
            due <= paymentAmount + storedInsufficientAmount;
            amt <= currentAmount + storedExcessAmount;
            if (amt >= due)
            begin
               excessAmount <= amt - due;
               insufficientAmount <= 16'd0;
               storedExcessAmount <= storedExcessAmount + excessAmount;
               next_state = SUCCESS;
            end
            else if (amt < due)
            begin
               excessAmount <= 16'd0;
               insufficientAmount <= due - amt;
               storedInsufficientAmount <= storedInsufficientAmount + insufficientAmount;
               next_state = FAILED;
            end
         end

         SUCCESS:
         begin
            successful <= 1'b1;
            dis <= 1'b0;
            totalcurrency <= currentAmount;
            paidamt <= paymentAmount;
            next_state = IDLE;
         end

         FAILED:
         begin
            successful <= 1'b0;
            dis <= 1'b1;
            totalcurrency <= currentAmount;
            paidamt <= paymentAmount;
            next_state = IDLE;
         end

         default:
            next_state = IDLE;
      endcase
   end
endmodule
