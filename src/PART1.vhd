

library IEEE;
use IEEE.std_logic_1164.all;
use work.mux_array_package.all;

entity PART1 is

  generic(N : integer := 32);

  port(i_CLK        : in std_logic;     -- Clock input
       i_RST_ALL : in std_logic; --Clear all registers
       i_instruction : in std_logic_vector(N-1 downto 0);
       o_out   : out std_logic_vector(N-1 downto 0));  -- n-bit data output

end PART1;

architecture structure of PART1 is

	-----CONTROL

    component control
	port(
	i_instruction : in std_logic_vector(6 downto 0);
	Branch : out std_logic;
	MemRead : out std_logic;
	MemtoReg : out std_logic;
	ALUOp : out std_logic_vector(1 downto 0);
	MemWrite : out std_logic;
	ALUSrc : out std_logic;
	RegWrite : out std_logic	
	);
    end component;

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

	-----ALU_control

    component ALU_control
        port (
        ALUOp    : in  std_logic_vector(1 downto 0);
        instruction    : in  std_logic_vector(3 downto 0); --instruction[30, 14-12]
	
	o_AltEn  : out std_logic; --enables shift and gates
	o_ShiftEn: out  std_logic; --selects between shift (1) or and/xor/or/nor gates (0)
	o_GateEn : out  std_logic_vector(1 downto 0); --00 = and, 01 = xor, 10 = or, 11 = nor
	o_BranchSel : out std_logic_vector(1 downto 0); --00 = BEQ, 01 = BGE, 10 = BLT, 11 = BNE 
	o_ShiftDir : out std_logic; --0 = left, 1 = right
	o_ShiftArith : out std_logic; 
        o_Sub  : out  std_logic); -- 0 = add, 1 = sub
    end component;	

	-----ALU

    component ALU
        port(
	i_A    : in  std_logic_vector(N-1 downto 0);
        i_B    : in  std_logic_vector(N-1 downto 0);
	i_imm  : in  std_logic_vector(N-1 downto 0);
	ALUSrc : in  std_logic; --1 = use imm, 0 = use B
	AltEn  : in std_logic; --enables shift and gates
	ShiftEn: in  std_logic; --selects between shift (1) or and/xor/or/nor gates (0)
	GateEn : in  std_logic_vector(1 downto 0); --00 = and, 01 = xor, 10 = or, 11 = nor
	BranchSel : in std_logic_vector(1 downto 0); --00 = BEQ, 01 = BGE, 10 = BLT, 11 = BNE 
	ShiftDir : in std_logic; --0 = left, 1 = right
	ShiftArith : in std_logic; 
        i_Sub  : in  std_logic; -- 0 = add, 1 = sub
        o_ALU  : out std_logic_vector(N-1 downto 0);
        o_Cout : out std_logic;
	o_zero : out std_logic);
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

	-----FETCH

    component fetch
	port (
	i_CLK : in std_logic;
        i_addimm    : in  std_logic_vector(31 downto 0);
	i_branch : in std_logic;
	i_zero : in std_logic;
	o_instruction : out std_logic_vector(31 downto 0));
    end component;

signal s_instruction : std_logic_vector(31 downto 0);

signal s_Branch :  std_logic;
signal s_MemRead :  std_logic;
signal s_MemtoReg :  std_logic;
signal s_ALUOp :  std_logic_vector(1 downto 0);
signal s_MemWrite :  std_logic;
signal s_ALUSrc :  std_logic;
signal s_RegWrite :  std_logic;	
signal s_regin : std_logic_vector(31 downto 0);
signal s_regout1 : std_logic_vector(31 downto 0);
signal s_regout2 : std_logic_vector(31 downto 0);
signal s_ext : std_logic_vector(31 downto 0);
--signal s_ALUOp    :  std_logic_vector(1 downto 0);
signal s_ALUinstruction    : std_logic_vector(3 downto 0); --instruction[30, 14-12]
	
signal s_AltEn  : std_logic; --enables shift and gates
signal s_ShiftEn: std_logic; --selects between shift (1) or and/xor/or/nor gates (0)
signal s_GateEn : std_logic_vector(1 downto 0); --00 = and, 01 = xor, 10 = or, 11 = nor
signal s_BranchSel : std_logic_vector(1 downto 0); --00 = BEQ, 01 = BGE, 10 = BLT, 11 = BNE 
signal s_ShiftDir : std_logic; --0 = left, 1 = right
signal s_ShiftArith : std_logic; 
signal s_Sub  :   std_logic; -- 0 = add, 1 = sub

signal s_ALUout : std_logic_vector(31 downto 0);
signal s_ALUzero : std_logic;
signal s_memout : std_logic_vector(31 downto 0);
signal s_out : std_logic_vector(31 downto 0);

begin

    fetch_i : fetch
	port map(
	i_CLK => i_CLK,
        i_addimm => s_ext,
	i_branch => s_Branch,
	i_zero => s_ALUzero,
	o_instruction => s_instruction);


    regfile_i : regfile
	port map(
	i_CLK => i_CLK,
	i_WA => s_instruction(11 downto 7),
        i_RA1 => s_instruction(24 downto 20),
        i_RA2 => s_instruction(19 downto 15),
        i_WE => s_RegWrite,
        i_DATA => s_regin,
        i_RST_ALL => i_RST_ALL,
        o_Q1 => s_regout1,
        o_Q2 => s_regout2);
	
    ALU_i : ALU
	port map(
	i_A => s_regout1,
        i_B => s_regout2,
	i_imm => s_ext,
	ALUSrc => s_ALUSrc,
	AltEn => s_AltEn,
	ShiftEn => s_ShiftEn,
	GateEn => s_GateEn,
	BranchSel => s_BranchSel,
	ShiftDir => s_ShiftDir,
	ShiftArith => s_ShiftArith,
        i_Sub  => s_Sub,
        o_ALU  => s_ALUout,
        o_Cout => open,
	o_zero => s_ALUzero);

    extender_i : extender
	port map(
	i_in16 => s_instruction(15 downto 0),--TODO
	i_unsigned => '1',--TODO
	o_out32 => s_ext);	

    mem_i : mem
	generic map(	
	DATA_WIDTH => 32,
	ADDR_WIDTH => 10)
	port map(
	clk => i_CLK,
	addr => s_ALUout(9 downto 0),
	data => s_regout2,
	we => s_MemWrite,
	q => s_memout);

    busmux_i : busmux2to1
	port map(
	i_S => s_MemtoReg,
	i_D0 => s_memout,
	i_D1 => s_ALUout,
	o_Q => s_out);

    control_i : control
	port map(
	i_instruction => s_instruction(6 downto 0),
	Branch => s_Branch,
	MemRead => s_MemRead,
	MemtoReg => s_MemtoReg,
	ALUOp => s_ALUOp,
	MemWrite => s_MemWrite,
	ALUSrc => s_ALUSrc,
	RegWrite => s_RegWrite); 
	
    o_out <= s_out;


end structure;