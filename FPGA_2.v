// Created by Mohammad Aamir Sohail (EE16BTECH11021) &
// Created by Piyush Rajan Udhan (EE16BTECH11028)
// EE5811 FPGA LAB

module CORDIC (input wire CLK_100MHZ,input signed wire[15:0] angle,output reg [7:0] Xout);
   
   parameter XY_SZ = 8;   // width of output data
   
   localparam STG = 8;    // Iterations 
  
	//stage outputs
   reg signed [XY_SZ-1:0] X [0:STG-1];
   reg signed [XY_SZ-1:0] Y [0:STG-1];
   reg signed      [15:0] Z [0:STG-1]; // 16 bit

   integer i = 1;

   // CORDIC ANGLE (16-bit binary scaling system)
   
   wire signed [15:0] atan_table [0:13];
   
   assign atan_table[0]  =  16'b0010000000000000;
   assign atan_table[1]  =  16'b0001001011100100;
   assign atan_table[2]  =  16'b0000100111111011;
   assign atan_table[3]  =  16'b0000010100010001;
   assign atan_table[4]  =  16'b0000001010001011;
   assign atan_table[5]  =  16'b0000000101000101;
   assign atan_table[6]  =  16'b0000000010100010;
   assign atan_table[7]  =  16'b0000000001010001;
   assign atan_table[8]  =  16'b0000000000101000;
   assign atan_table[9]  =  16'b0000000000010100;
   //assign atan_table[10] =  16'b0000000000001010;
   //assign atan_table[11] =  16'b0000000000000101;
   //assign atan_table[12] =  16'b0000000000000010;
   //assign atan_table[13] =  16'b0000000000000001;

 always @(posedge CLK_100MHZ) // 75*Cordic_gain_factor ~ 126: 8-bit signed (min -128 max 127) 
   begin
	if (i < 0)
	begin
	case (angle[15:14])
         2'b00,
         2'b11:   // no pre-rotation needed for these quadrants
         begin    
	//$display("angle = %d ",angle);
            X[0] = 75;
            Y[0] = 0;
            Z[0] = angle;
         end
         
         2'b01:
         begin
	//$display("angle = %d ",angle);
            X[0] = -0;
            Y[0] = 75;
            Z[0] = {2'b00,angle[13:0]}; // subtract pi/2 from angle for this quadrant
         end
         
         2'b10:
         begin
	//	$display("angle = %d ",angle);
            X[0] = 0;
            Y[0] = -75;
            Z[0] = {2'b11,angle[13:0]}; // add pi/2 to angle for this quadrant
         end
	endcase
	i = 0;
	end
    if(i <STG-1)
       begin
       
      // CORDIC ITERATIONS

        X[i+1] = Z[i][15] ? X[i] + (Y[i] >>> i)         : X[i] - (Y[i] >>> i) ; // x-coordinate
        Y[i+1] = Z[i][15] ? Y[i] - (X[i] >>> i)         : Y[i] + (X[i] >>> i) ; // y-coordinate
        Z[i+1] = Z[i][15] ? Z[i] + atan_table[i] : Z[i] - atan_table[i];        // residual angle

	
   end
   
   assign Xout <= Y[STG-1] ;  // SINE
	
   //------------------------------------------------------------------------------
   //                                 output
   //-----------------------------------------------------------------------------

	
endmodule
