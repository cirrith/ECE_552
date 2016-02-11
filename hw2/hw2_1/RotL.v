module RotL(In, Amt, Out);

// Declare inputs and outputs
input [3:0] Amt;
input [15:0] In;
output [15:0] Out;

// Declare wires
wire [15:0] OutA, OutB, OutC, OutD;

////////////////////////////////////////////////////////////////////////////////
////////////////////		 	Do the thing!				////////////////////
////////////////////////////////////////////////////////////////////////////////


// Muxes to control how much to shift by

mux4x4_1 low(.A(In[15:0]), .B({In[14:0], In[15]}), .C({In[13:0], In[15:14]}), .D({In[12:0], In[15:13]}), .Sel(Amt[1:0]), .Out(OutA));

mux4x4_1 mid_low(.A({In[11:0], In[15:12]}), .B({In[10:0], In[15:11]}), .C({In[9:0], In[15:10]}), .D({In[8:0], In[15:9]}), .Sel(Amt[1:0]), .Out(OutB));

mux4x4_1 mid_high(.A({In[7:0], In[15:8]}), .B({In[6:0], In[15:7]}), .C({In[5:0], In[15:6]}), .D({In[4:0], In[15:5]}), .Sel(Amt[1:0]), .Out(OutC));

mux4x4_1 high(.A({In[3:0], In[15:4]}), .B({In[2:0], In[15:3]}), .C({In[1:0], In[15:2]}), .D({In[0], In[15:1]}), .Sel(Amt[1:0]), .Out(OutD));


// Mux to select the correct output

mux4x4_1 final_mux(.A(OutA), .B(OutB), .C(OutC), .D(OutD), .Sel(Amt[3:2]), .Out(Out));


endmodule