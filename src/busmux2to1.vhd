
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity busmux2to1 is
	
	port(i_S : in std_logic;
	     i_D0 : in std_logic_vector(31 downto 0);
	     i_D1 : in std_logic_vector(31 downto 0);
	     o_Q : out std_logic_vector(31 downto 0));

end busmux2to1;

architecture dataflow of busmux2to1 is

    begin

	o_Q <= i_D0 when i_S = '0' else i_D1;


end dataflow;