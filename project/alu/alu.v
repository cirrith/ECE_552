// Processor Alu
// 16-bit
module alu(Rs, Rt, Rd, I, Op);

	// Declare inputs and outputs
	input [4:0] I, Op;
	input [15:0] Rs, Rt;

	output [15:0] Rd
	
	
	// Declare any wires that are needed
	wire ovf1;
	
	
	
	
	// Instanitate any required modules
	
	
	
	// Case statement for the main functions of the alu
	always@(clk) begin	
	case (Op[4:3])
		1: begin	// Operations that involve immediates (basic)
				// Code here
				case (Op[2:0]) begin
					0: begin
						// Modify the cla for efficiency (remove Si, Cin, )
						cla cla_mod (.A(Rs), .B({11*I[4], I[4:0]}), .Cin(0), .Si(sign), .Out(Add_out), .Ofl(ovfl));
					end
					1: begin
					end
					2: begin
					end
					3: begin
					end
				endcase
			end
		2: begin	// Operations that involve immediates (advanced)
				// Code here
				case (Op[2:0]) begin
				
				endcase
			end
		3: begin	// Operations that only involve registers
				// Code here
				case (Op[2:0]) begin
				
				endcase
			end
	endcase
	end
	
	// Things to handle:
		// Overflow
		// 
	
	