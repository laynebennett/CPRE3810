
library IEEE;
use IEEE.std_logic_1164.all;
use work.mux_array_package.all;

entity RISCVDATA is

  generic(N : integer := 32);

  port(i_CLK        : in std_logic;     -- Clock input
       i_WA        : in std_logic_vector(4 downto 0);     -- 5 bit Write Address input
       i_RA1        : in std_logic_vector(4 downto 0);     -- 5 bit Read Address input
       i_RA2        : in std_logic_vector(4 downto 0);     -- 5 bit Read Address input
       i_WE         : in std_logic;     -- Write enable input
       i_imm   : in std_logic_vector(N-1 downto 0);  -- n-bit data input (32 bit)
       i_RST_ALL : in std_logic; --Clear all registers
       i_addsub : in std_logic;
       i_ALUSrc : in std_logic;
       o_ALU   : out std_logic_vector(N-1 downto 0);  -- n-bit data output
       o_Cout : out std_logic);
       

end RISCVDATA;

architecture structure of RISCVDATA is

	signal s_RD1 : std_logic_vector(N-1 downto 0); --out1, ALU A in vector
	signal s_RD2: std_logic_vector(N-1 downto 0); --out2, mux in vector
	signal s_ALU: std_logic_vector(N-1 downto 0);

	-----REGISTER FILE

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

	-----ALU

    component addsubi
	port(
        i_A    : in  std_logic_vector(N-1 downto 0);
        i_B    : in  std_logic_vector(N-1 downto 0);
	i_imm  : in  std_logic_vector(N-1 downto 0);
	ALUSrc : in  std_logic;
        i_Sub  : in  std_logic; -- 0 = add, 1 = sub
        o_Sum  : out std_logic_vector(N-1 downto 0);
        o_Cout : out std_logic);
    end component;

begin

    regfile_i : regfile
	port map(
	i_CLK => i_CLK,
	i_WA => i_WA,
        i_RA1 => i_RA1,
        i_RA2 => i_RA2,
        i_WE => i_WE,
        i_DATA => s_ALU,
        i_RST_ALL => i_RST_ALL,
        o_Q1 => s_RD1,
        o_Q2 => s_RD2);
	
    addsubi_i : addsubi
	port map(
        i_A => s_RD1,
        i_B => s_RD2,
	i_imm => i_imm,
	ALUSrc => i_ALUSrc,
        i_Sub => i_addsub,
        o_Sum => s_ALU,
        o_Cout => o_Cout);

	
    o_ALU <= s_ALU;


end structure;