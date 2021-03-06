

//=======================================================
//  This code is generated by Terasic System Builder
//=======================================================



module fourInputBits(

	//////////// CLOCK //////////
	input 		         		FPGA_CLK1_50,

	//////////// KEY //////////
	input 		    [1:0]		KEY, // the push button key in the FPGA board

	//////////// LED //////////
	output		    [4:0]		LED,// the LED to display the outputs

	//////////// SW //////////
	input 		    [3:0]		SW // THe switch to give the ALU inputs to the board
);	//port declarations

	
	//internal variables

	parameter n	=	4; //bit lenght is 4 bits
	parameter N	=	3; //no.of numbers

	//Reg and Wire Declaration
	//------------------------

	wire 	clk;
	wire 	reset;	//for reset 
	reg 	[n-1:0] 	inp_reg;	//the inputs are temporarily stored in this
	reg	[n-1:0] 	reg_out;


	//assigning internal signal to the QSF mapped signals///////////
	//--------------------------------------

	assign reset 		= 	KEY[0];
	assign clk              =  	FPGA_CLK1_50;
	assign LED[3:0]         =  	reg_out;
	reg [n-1 : 0] myrows [0 : N-1];	
	integer i;
	//internal counter
	reg	[5:0]	counter; // no.of bits depend on N and so change this value accordingly
	reg		key;
	reg		key_delay;
	wire		pulses;
	wire		pulse_input;	
	assign pulses		=	key ^ key_delay;
	assign pulse_input 	=	pulses & key_delay;
	
	reg inputs_done; //to indicate that all the N inputs are given by the user

always @(posedge pulse_input) begin // push the inputs to queue by shifting
		if(counter<N) begin //counter not N-1 because of extra inp_reg
			myrows[0] <= inp_reg;
			//myrows[1] <= myrows[0];
			for (i=1; i<N ; i=i+1) begin
				myrows[i] <= myrows[i-1];
			end
		end // counter if ends here
end //always ended here

always @(posedge clk or negedge reset) begin
	if(!reset) begin
		inp_reg			<= 4'b0;
		counter[5:0]		<= 5'b0;
		reg_out[3:0]		<= 4'b0;		
	end // reset if ends here
	
	else begin
		key		<=	KEY[1];
		key_delay	<=	key;
		if(pulse_input) begin
					counter  <=	counter + 1'b1;		
					if(counter == N) // not N-1, we use the last one to set the sort mode
							counter	<=	4'b0;
					if(counter < N) begin
							inp_reg	<=	SW;
							reg_out <=	SW;
					end 
		end // pulse input if ends here	
	end // reset else ends here

end //always ended here



endmodule //Embeddedproj ends here

