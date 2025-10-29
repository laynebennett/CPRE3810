

library IEEE;
use IEEE.std_logic_1164.all;

entity norg32 is

  port(i_A          : in std_logic_vector(31 downto 0);
       i_B          : in std_logic_vector(31 downto 0);
       o_F          : out std_logic_vector(31 downto 0)
  );

end norg32;

architecture dataflow of norg32 is
begin

  o_F <= i_A nor i_B;
  
end dataflow;