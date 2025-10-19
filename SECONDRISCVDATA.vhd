

library IEEE;
use IEEE.std_logic_1164.all;
use work.mux_array_package.all;

entity SECONDRISCVDATA is

  generic(N : integer := 32);

  port(i_CLK        : in std_logic;     -- Clock input
       i_WA        : in std_logic_vector(4 downto 0);     -- 5 bit Write Address input
       i_RA1        : in std_logic_vector(4 downto 0);     -- 5 bit Read Address input
       i_RA2        : in std_logic_vector(4 downto 0);     -- 5 bit Read Address input
       i_WE         : in std_logic;     -- Write enable input
       i_imm   : in std_logic_vector(15 downto 0);  -- n-bit data input (16 bit)
       i_RST_ALL : in std_logic; --Clear all registers
       i_addsub : in std_logic;
       i_ALUSrc : in std_logic;
       i_MemWrite : in std_logic;
       i_MemtoReg : in std_logic;
       i_unsigned : in std_logic;
       o_Mem   : out std_logic_vector(N-1 downto 0);  -- n-bit data output
       o_Cout : out std_logic);
       

end SECONDRISCVDATA;

architecture structure of SECONDRISCVDATA is

	signal s_RD1 : std_logic_vector(N-1 downto 0); --out1, ALU A in vector
	signal s_RD2: std_logic_vector(N-1 downto 0); --out2, mux in vector/write_data in vector
	signal s_ALU: std_logic_vector(N-1 downto 0); --ALU out, Addr/MemtoReg mux i_B
	signal s_ALUlow10: std_logic_vector(9 downto 0);
	signal s_mem: std_logic_vector(N-1 downto 0); --Mem out, MemtoReg mux i_A
	signal s_out: std_logic_vector(N-1 downto 0); --MemtoReg out, reg data in
	signal s_ext: std_logic_vector(N-1 downto 0); --extender out

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

	-----EXTENDER

    component extender
	port (
	i_in16	        : in std_logic_vector((15) downto 0);
	i_unsigned	: in std_logic; --1 for unsigned
	o_out32		: out std_logic_vector((31) downto 0));
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

	-----MEM

    component mem
	generic (
	DATA_WIDTH : natural := 32;
	ADDR_WIDTH : natural := 10);

	port (
	clk		: in std_logic;
	addr	        : in std_logic_vector((ADDR_WIDTH-1) downto 0);
	data	        : in std_logic_vector((DATA_WIDTH-1) downto 0);
	we		: in std_logic := '1';
	q		: out std_logic_vector((DATA_WIDTH -1) downto 0));
    end component;

	-----busmux2to1

    component busmux2to1
	port(i_S : in std_logic;
	     i_D0 : in std_logic_vector(31 downto 0);
	     i_D1 : in std_logic_vector(31 downto 0);
	     o_Q : out std_logic_vector(31 downto 0));
    end component;

begin

    regfile_i : regfile
	port map(
	i_CLK => i_CLK,
	i_WA => i_WA,
        i_RA1 => i_RA1,
        i_RA2 => i_RA2,
        i_WE => i_WE,
        i_DATA => s_Out,
        i_RST_ALL => i_RST_ALL,
        o_Q1 => s_RD1,
        o_Q2 => s_RD2);
	
    addsubi_i : addsubi
	port map(
        i_A => s_RD1,
        i_B => s_RD2,
	i_imm => s_ext,
	ALUSrc => i_ALUSrc,
        i_Sub => i_addsub,
        o_Sum => s_ALU,
        o_Cout => o_Cout);

    extender_i : extender
	port map(
	i_in16 => i_imm,
	i_unsigned => i_unsigned,
	o_out32 => s_ext);	

    mem_i : mem
	generic map(	
	DATA_WIDTH => 32,
	ADDR_WIDTH => 10)
	port map(
	clk => i_CLK,
	addr => s_ALUlow10,
	data => s_RD2,
	we => i_MemWrite,
	q => s_mem);

    busmux_i : busmux2to1
	port map(
	i_S => i_MemtoReg,
	i_D0 => s_mem,
	i_D1 => s_ALU,
	o_Q => s_out);
	
    o_Mem <= s_out;

    s_ALUlow10 <= s_ALU(9 downto 0);


end structure;