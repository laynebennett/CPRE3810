
library IEEE;
use IEEE.std_logic_1164.all;
use work.mux_array_package.all;

entity regfile is

  generic(N : integer := 32);

  port(i_CLK        : in std_logic;     -- Clock input
       i_WA        : in std_logic_vector(4 downto 0);     -- 5 bit Write Address input
       i_RA1        : in std_logic_vector(4 downto 0);     -- 5 bit Read Address input
       i_RA2        : in std_logic_vector(4 downto 0);     -- 5 bit Read Address input
       i_WE         : in std_logic;     -- Write enable input
       i_DATA   : in std_logic_vector(N-1 downto 0);  -- n-bit data input (32 bit)
       i_RST_ALL : in std_logic; --Clear all registers
       o_Q1   : out std_logic_vector(N-1 downto 0);  -- n-bit data output
       o_Q2   : out std_logic_vector(N-1 downto 0));  -- n-bit data output
       

end regfile;

architecture structure of regfile is

	signal decout : std_logic_vector(N-1 downto 0); --decoder out, register in vector
	signal muxin : vector_array;

	-----REGISTER

    component reg
      port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_D          : in std_logic_vector(N-1 downto 0);     -- Data value input
       o_Q          : out std_logic_vector(N-1 downto 0));   -- Data value output
    end component;

	-----DECODER

    component dec5to32
	port(i_S : in std_logic_vector(4 downto 0);
	     i_EN : std_logic;
	     o_Q : out std_logic_vector(31 downto 0));
    end component;

	-----BUSMUX

    component mux32to1
	port(i_S : in std_logic_vector(4 downto 0);
	     i_D : in vector_array;
	     o_Q : out std_logic_vector(31 downto 0));
    end component;


begin

    decoder : dec5to32
	port map(
	i_S => i_WA,
	i_EN => i_WE,
	o_Q => decout);


    g_regs : for i in 0 to N-1 generate
	i_reg : reg
	  port map(i_CLK => i_CLK,
       		   i_WE => decout(i),       
		   i_D => i_DATA,           -- Data value input
		   i_RST => i_RST_ALL,
       		   o_Q => muxin(i));     -- Data value output    
    end generate g_regs;

    busmux1 : mux32to1
	port map(
	i_S => i_RA1,
	i_D => muxin,
	o_Q => o_Q1);
	

    busmux2 : mux32to1
	port map(
	i_S => i_RA2,
	i_D => muxin,
	o_Q => o_Q2);
	


end structure;
