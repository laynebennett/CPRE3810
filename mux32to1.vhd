
library IEEE;
use IEEE.std_logic_1164.all;
use work.mux_array_package.all;
use IEEE.numeric_std.all;

entity mux32to1 is
	
	port(i_S : in std_logic_vector(4 downto 0);
	     i_D : in vector_array;
	     o_Q : out std_logic_vector(31 downto 0));

end mux32to1;

architecture dataflow of mux32to1 is

    begin

	o_Q <=i_D(to_integer(unsigned(i_S)));


end dataflow;
