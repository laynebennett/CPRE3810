
library IEEE;
use IEEE.std_logic_1164.all;

entity tb_dec5to32 is

  generic(gCLK_HPER   : time := 50 ns);

end tb_dec5to32;

architecture behavior of tb_dec5to32 is

  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;

  component dec5to32
	port(i_S : in std_logic_vector(4 downto 0);
	     i_EN : std_logic;
	     o_Q : out std_logic_vector(31 downto 0));
  end component;


  -- Temporary signals to connect to the decoder component.
  signal s_S  : std_logic_vector(4 downto 0);
  signal s_Q  : std_logic_vector(31 downto 0);
  signal s_EN : std_logic;

begin

  DUT: dec5to32 
  port map(i_S => s_S,
           o_Q  => s_Q,
	   i_EN => s_EN);
  
  -- Testbench process  
  P_TB: process
  begin

    --test for 0 
    s_EN <= '1';
    s_S <= "00000";
    wait for cCLK_PER;

    --test for 1 
    s_S <= "00001";
    wait for cCLK_PER;

    --test for 31 
    s_S <= "11111";
    wait for cCLK_PER;

    --test for disable
    s_EN <= '0';
    wait for cCLK_PER;

    wait;
  end process;
  
end behavior;
