library IEEE;
use IEEE.std_logic_1164.all;
use work.mux_array_package.all;

entity tb_mux32to1 is

  generic(gCLK_HPER   : time := 50 ns);

end tb_mux32to1;

architecture behavior of tb_mux32to1 is

  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;

  component mux32to1
	port(i_S : in std_logic_vector(4 downto 0);
	     i_D : in vector_array;
	     o_Q : out std_logic_vector(31 downto 0));
  end component;


  -- Temporary signals to connect to the decoder component.
  signal s_S  : std_logic_vector(4 downto 0);
  signal s_D  : vector_array;
  signal s_Q  : std_logic_vector(31 downto 0);

begin

  DUT: mux32to1
  port map(i_S => s_S,
	   i_D => s_D,
           o_Q  => s_Q);
  
  -- Testbench process  
  P_TB: process
  begin

    --test for 0 
    s_D(0) <= x"FFFFFFFF";
    s_S <= "00000";
    wait for cCLK_PER;

    --test for 1 
    s_D(1) <= x"FFFFFFFF";
    s_S <= "00001";
    wait for cCLK_PER;

    --test for 31 
    s_D(31) <= x"FFFFFFFF";
    s_S <= "11111";
    wait for cCLK_PER;

    --test for input of all 0s 
    s_D(0) <= x"00000000";
    s_S <= "00000";
    wait for cCLK_PER;

    wait;
  end process;
  
end behavior;