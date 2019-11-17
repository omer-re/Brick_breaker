// (c) Technion IIT, Department of Electrical Engineering 2018 
// Written By Liat Schwartz August 2018 


// Implements mux 4=>1 with case statement
// combinatorial

module mux2 	
 ( 
   input logic bigbat,
	input logic smallbat,
	input logic select,
	input logic[7:0] BigBat_RGB,
	input logic[7:0] SmallBat_RGB,
	
	output logic outd,
	output logic[7:0] RGB_out
	);

	always_comb
        begin
            case (select)
                1'b0 : begin 
						outd = bigbat;
						RGB_out = BigBat_RGB;
						end
                1'b1 : begin
						outd = smallbat;
						RGB_out = SmallBat_RGB;
						end
             endcase
        end 

endmodule

