
library IEEE;
use IEEE.std_logic_1164.all;

entity busandg2 is

  port(i_A          : in std_logic_vector(15 downto 0);
       i_B          : in std_logic_vector(15 downto 0);
       o_F          : out std_logic_vector(15 downto 0));

end busandg2;

architecture dataflow of busandg2 is
begin

  o_F <= i_A and i_B;
  
end dataflow;