
library IEEE;
use IEEE.std_logic_1164.all;

entity reg is

  generic(N : integer := 32);

  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_D   : in std_logic_vector(N-1 downto 0);  -- n-bit data input
       o_Q   : out std_logic_vector(N-1 downto 0));  -- n-bit data output

end reg;

architecture structure of reg is

    component dffg
      port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_D          : in std_logic;     -- Data value input
       o_Q          : out std_logic);   -- Data value output
    end component;

begin

    g_dffgs : for i in 0 to N-1 generate
	i_dffg : dffg
	  port map(i_CLK => i_CLK,     -- Clock input
     		   i_RST => i_RST,     -- Reset input
  	           i_WE => i_WE,     -- Write enable input
                   i_D => i_D(i),     -- Data value input
                   o_Q => o_Q(i));   -- Data value output
    end generate g_dffgs;



end structure;
