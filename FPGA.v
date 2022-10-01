// Created by Mohammad Aamir Sohail (EE16BTECH11021) &
// Created by Piyush Rajan Udhan (EE16BTECH11028)
// EE5811 FPGA LAB

module CORDIC (input wire CLK_100MHZ,input signed wire[15:0] angle,output reg [7:0] Xout);
   
   parameter XY_SZ = 8;   // width of Output data
   
   localparam STG = 8; 
   
   //input  CLK_100MHZ;
   //input  signed  [15:0]   angle;
   //output signed   [7:0]    Xout; 
  
   //stage outputs
   reg signed [XY_SZ-1:0] X [0:STG-1];
   reg signed [XY_SZ-1:0] Y [0:STG-1];
   reg signed      [15:0] Z [0:STG-1]; // 16 bit

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

 always @(posedge CLK_100MHZ) // 75*CORDIC_Gain_Factor ~ 126: 8 bit signed (7+1 sign bit) max 2^7 - 1 = 127 min -2^7 = -128
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
	
        // CORDIC ITERATIONS
        
        //i=0

        X[1] = Z[0][15] ? X[0] + (Y[0] >>> 0)         : X[0] - (Y[0] >>> 0) ;   // x-coordinate
        Y[1] = Z[0][15] ? Y[0] - (X[0] >>> 0)         : Y[0] + (X[0] >>> 0) ;   // y-coordinate
        Z[1] = Z[0][15] ? Z[0] + atan_table[0] : Z[0] - atan_table[0];          // residual angle

        //i=1

        X[2] = Z[1][15] ? X[1] + (Y[1] >>> 1)         : X[1] - (Y[1] >>> 1) ;
        Y[2] = Z[1][15] ? Y[1] - (X[1] >>> 1)         : Y[1] + (X[1] >>> 1) ;
        Z[2] = Z[1][15] ? Z[1] + atan_table[1] : Z[1] - atan_table[1];

         //i=2

        X[3] = Z[2][15] ? X[2] + (Y[2] >>> 2)         : X[2] - (Y[2] >>> 2) ;
        Y[3] = Z[2][15] ? Y[2] - (X[2] >>> 2)         : Y[2] + (X[2] >>> 2) ;
        Z[3] = Z[2][15] ? Z[2] + atan_table[2] : Z[2] - atan_table[2];

         //i=3

        X[4] = Z[3][15] ? X[3] + (Y[3] >>> 3)         : X[3] - (Y[3] >>> 3) ;
        Y[4] = Z[3][15] ? Y[3] - (X[3] >>> 3)         : Y[3] + (X[3] >>> 3) ;
        Z[4] = Z[3][15] ? Z[3] + atan_table[3] : Z[3] - atan_table[3];

         //i=4

        X[5] = Z[4][15] ? X[4] + (Y[4] >>> 4)         : X[4] - (Y[4] >>> 4) ;
        Y[5] = Z[4][15] ? Y[4] - (X[4] >>> 4)         : Y[4] + (X[4] >>> 4) ;
        Z[5] = Z[4][15] ? Z[4] + atan_table[4] : Z[4] - atan_table[4];

        //i=5

        X[6] = Z[5][15] ? X[5] + (Y[5] >>> 5)         : X[5] - (Y[5] >>> 5) ;
        Y[6] = Z[5][15] ? Y[5] - (X[5] >>> 5)         : Y[5] + (X[5] >>> 5) ;
        Z[6] = Z[5][15] ? Z[5] + atan_table[5] : Z[5] - atan_table[5];

         //i=6

        X[7] = Z[6][15] ? X[6] + (Y[6] >>> 6)         : X[6] - (Y[6] >>> 6) ;
        Y[7] = Z[6][15] ? Y[6] - (X[6] >>> 6)         : Y[6] + (X[6] >>> 6) ;
        Z[7] = Z[6][15] ? Z[6] + atan_table[6] : Z[6] - atan_table[6];

	Xout <= Y[7]; // SINE
   end
	
   //------------------------------------------------------------------------------
   //                                 output
   //-----------------------------------------------------------------------------

	
endmodule
