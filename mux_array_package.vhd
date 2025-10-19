library IEEE;
use IEEE.std_logic_1164.all;


package mux_array_package is
	type vector_array is array (0 to 31) of std_logic_vector(31 downto 0);
end package mux_array_package;