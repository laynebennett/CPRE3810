
library IEEE;
use IEEE.std_logic_1164.all;
use work.mux_array_package.all;

entity tb_regfile is

  generic(gCLK_HPER   : time := 50 ns;
  N : integer := 32);

end tb_regfile;

architecture behavior of tb_regfile is

  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;

  component regfile
  port(i_CLK        : in std_logic;     -- Clock input
       i_WA        : in std_logic_vector(4 downto 0);     -- 5 bit Write Address input
       i_RA1        : in std_logic_vector(4 downto 0);     -- 5 bit Read Address input
       i_RA2        : in std_logic_vector(4 downto 0);     -- 5 bit Read Address input
       i_WE         : in std_logic;     -- Write enable input
       i_DATA   : in std_logic_vector(N-1 downto 0);  -- n-bit data input (32 bit)
       i_RST_ALL : in std_logic; --Clear all registers
       o_Q1   : out std_logic_vector(N-1 downto 0);  -- n-bit data output
       o_Q2   : out std_logic_vector(N-1 downto 0));  -- n-bit data output

  end component;


  -- Temporary signals to connect to the decoder component.
  signal s_CLK : std_logic;
  signal s_WA : std_logic_vector(4 downto 0);     -- 5 bit Write Address input
  signal s_RA1 : std_logic_vector(4 downto 0);     -- 5 bit Read Address input
  signal s_RA2 : std_logic_vector(4 downto 0);     -- 5 bit Read Address input
  signal s_WE : std_logic;     -- Write enable input
  signal s_DATA : std_logic_vector(N-1 downto 0);  -- n-bit data input (32 bit)
  signal s_RST_ALL : std_logic; --Clear all registers
  signal s_Q1 : std_logic_vector(N-1 downto 0);  -- n-bit data output
  signal s_Q2 : std_logic_vector(N-1 downto 0);  -- n-bit data output


begin

  DUT: regfile
  port map(i_CLK => s_CLK,
	   i_WA => s_WA,
	   i_RA1 => s_RA1,
	   i_RA2 => s_RA2,
	   i_WE => s_WE,
	   i_DATA => s_DATA,
	   i_RST_ALL => s_RST_ALL,
           o_Q1 => s_Q1,
	   o_Q2 => s_Q2);

--clock process
  P_CLK: process
  begin
    s_CLK <= '0';
    wait for gCLK_HPER;
    s_CLK <= '1';
    wait for gCLK_HPER;
  end process;

  -- Testbench process  
  P_TB: process
  begin

    --reset all regs
   	s_RST_ALL <= '1'; 
	s_RA1 <= "00000";
    wait for cCLK_PER;
	--EXPECTED: reg0-31 = 00000000

    --test for writing 0xFFFFFFFF to reg0
	s_RST_ALL <= '0';
	s_WE <= '1';
	s_WA <= "00000";
	s_DATA <= x"FFFFFFFF";
	s_RA1 <= "00000";	
    wait for cCLK_PER;
	--EXPECTED: reg0 = FFFFFFFF, s_Q = FFFFFFFF

    --test for write enable for reg0
	s_WE <= '0';
	s_WA <= "00000";
	s_DATA <= x"F0F0F0F0"; 
	s_RA1 <= "00000";
    wait for cCLK_PER;
	--EXPECTED: reg0 = FFFFFFFF, s_Q = FFFFFFFF

    --test for reading reg1
	s_RA1 <= "00001";
    wait for cCLK_PER;
	--EXPECTED: s_Q = 00000000

    --test for writing to reg1
	s_WE <= '1';
	s_WA <= "00001";
	s_DATA <= x"80085101"; 
	s_RA1 <= "00001";
    wait for cCLK_PER;
	--EXPECTED: reg1 = 80085101, s_Q = 80085101

    wait;
  end process;
  
end behavior;