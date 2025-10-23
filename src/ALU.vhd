
library IEEE;
use IEEE.std_logic_1164.all;

entity ALU is
    generic(N : integer := 32);
    port (
        i_A    : in  std_logic_vector(N-1 downto 0);
        i_B    : in  std_logic_vector(N-1 downto 0);
	i_imm  : in  std_logic_vector(N-1 downto 0);
	ALUSrc : in  std_logic;
	ShiftEn: in  std_logic;
	ShiftDir : in std_logic;
	ShiftArith : in std_logic;
        i_Sub  : in  std_logic; -- 0 = add, 1 = sub
        o_ALU  : out std_logic_vector(N-1 downto 0);
        o_Cout : out std_logic
    );
end ALU;

architecture structure of ALU is

    component busmux2to1
	port(
	i_S : in std_logic;
	i_D0 : in std_logic_vector(31 downto 0);
	i_D1 : in std_logic_vector(31 downto 0);
	o_Q : out std_logic_vector(31 downto 0)
	);
    end component;

    component bshiftr
	port(
        i_d     : in  std_logic_vector(31 downto 0);  -- input data
        i_shift : in  std_logic_vector(4 downto 0);   -- shift amount (uses lower 5 bits)
        i_arith : in  std_logic;                      -- ShiftArith, 0 = logical, 1 = arithmetic
	i_dir	: in  std_logic;		      -- ShiftDir, 0 = left, 1 = right
        o_d     : out std_logic_vector(31 downto 0)   -- shifted output
        );
    end component;

    component addsubi
        generic(N : integer := 32);
        port (
        i_A    : in  std_logic_vector(N-1 downto 0);
        i_B    : in  std_logic_vector(N-1 downto 0);
	i_imm  : in  std_logic_vector(N-1 downto 0);
	ALUSrc : in  std_logic;
        i_Sub  : in  std_logic; -- 0 = add, 1 = sub
        o_Sum  : out std_logic_vector(N-1 downto 0);
        o_Cout : out std_logic
    	);
    end component;

    signal shiftout : std_logic_vector(N-1 downto 0);
    signal addsubiout : std_logic_vector(N-1 downto 0);
    signal muxtoshift : std_logic_vector(N-1 downto 0);

begin

    busmux_inst: busmux2to1
	port map(
	i_S => ALUSrc,
	i_D0 => i_B,
	i_D1 => i_imm,
	o_Q => muxtoshift
	);

    bshiftr_inst: bshiftr
	port map(
	i_d => i_A,
	i_shift => muxtoshift,
	i_arith => ShiftArith,
	i_dir => ShiftDir,
	o_d => shiftout
	);

    addsubi_inst: addsubi
	port map(
	i_A => i_A,
        i_B => i_B,
	i_imm => i_imm,
	ALUSrc => ALUSrc,
        i_Sub => i_Sub,
        o_Sum => addsubiout,
        o_Cout => o_Cout
	);

    busmux_inst2: busmux2to1
	port map(
	i_S => ShiftEn,
	i_D0 => addsubiout,
	i_D1 => shiftout,
	o_Q => o_ALU
	);

end structure;