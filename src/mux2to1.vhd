

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mux2to1 is
	
	port(i_S : in std_logic;
	     i_D0 : in std_logic;
	     i_D1 : in std_logic;
	     o_Q : out std_logic);

end mux2to1;

architecture dataflow of mux2to1 is

    begin

	o_Q <= i_D0 when i_S = '0' else i_D1;


end dataflow;