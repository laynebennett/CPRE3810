library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_SECONDRISCVDATA is
end tb_SECONDRISCVDATA;

architecture behavior of tb_SECONDRISCVDATA is

    component SECONDRISCVDATA
      generic(N : integer := 32);
      port(
        i_CLK        : in  std_logic;
        i_WA         : in  std_logic_vector(4 downto 0);
        i_RA1        : in  std_logic_vector(4 downto 0);
        i_RA2        : in  std_logic_vector(4 downto 0);
        i_WE         : in  std_logic;
        i_imm        : in  std_logic_vector(15 downto 0);
        i_RST_ALL    : in  std_logic;
        i_addsub     : in  std_logic;
        i_ALUSrc     : in  std_logic;
        i_MemWrite   : in  std_logic;
        i_MemtoReg   : in  std_logic;
        i_unsigned   : in  std_logic;
        o_Mem        : out std_logic_vector(31 downto 0);
        o_Cout       : out std_logic
      );
    end component;

        --  Signals
    signal s_CLK        : std_logic := '0';
    signal s_RST_ALL    : std_logic := '0';
    signal s_WA, s_RA1, s_RA2 : std_logic_vector(4 downto 0) := (others => '0');
    signal s_WE         : std_logic := '0';
    signal s_imm        : std_logic_vector(15 downto 0) := (others => '0');
    signal s_addsub     : std_logic := '0';
    signal s_ALUSrc     : std_logic := '0';
    signal s_MemWrite   : std_logic := '0';
    signal s_MemtoReg   : std_logic := '0';
    signal s_unsigned   : std_logic := '0';
    signal s_oMem       : std_logic_vector(31 downto 0);
    signal s_oCout      : std_logic;

	--clock
    constant cCLK_HPER : time := 50 ns;
    constant cCLK_PER  : time := 2 * cCLK_HPER;

begin

   DUT: SECONDRISCVDATA
      port map (
        i_CLK      => s_CLK,
        i_WA       => s_WA,
        i_RA1      => s_RA1,
        i_RA2      => s_RA2,
        i_WE       => s_WE,
        i_imm      => s_imm,
        i_RST_ALL  => s_RST_ALL,
        i_addsub   => s_addsub,
        i_ALUSrc   => s_ALUSrc,
        i_MemWrite => s_MemWrite,
        i_MemtoReg => s_MemtoReg,
        i_unsigned => s_unsigned,
        o_Mem      => s_oMem,
        o_Cout     => s_oCout
      );

	--clock process
    p_CLK : process
    begin
        s_CLK <= '0';
        wait for cCLK_HPER;
        s_CLK <= '1';
        wait for cCLK_HPER;
    end process p_CLK;

	--tests
    p_TESTS : process
    begin
        -- Reset
        s_RST_ALL <= '1';
        wait for cCLK_PER;
        s_RST_ALL <= '0';

--mem load -infile /home/layneben/Downloads/Lab2/dmem.hex -format hex /tb_secondriscvdata/DUT/mem_i/ram

-- addi x25, x0, 0        # x25 = &A (base address of array A)
s_unsigned <= '0'; s_WE <= '1'; s_WA <= "11001"; s_RA1 <= "00000"; s_ALUSrc <= '1'; s_imm <= x"0000"; s_MemtoReg <= '1'; s_addsub <= '0'; wait for cCLK_PER;

-- addi x26, x0, 256      # x26 = &B (base address of array B)
s_unsigned <= '0'; s_WE <= '1'; s_WA <= "11010"; s_RA1 <= "00000"; s_ALUSrc <= '1'; s_imm <= x"0100"; s_MemtoReg <= '1'; wait for cCLK_PER;

-- Sum A[0] + A[1], store result in B[0]
-- lw x1, 0(x25)
s_ALUSrc <= '1'; s_unsigned <= '1'; s_WE <= '1'; s_WA <= "00001"; s_RA1 <= "11001"; s_imm <= x"0000"; s_MemtoReg <= '0'; s_MemWrite <= '0'; wait for cCLK_PER;

-- lw x2, 4(x25)
s_WE <= '1'; s_ALUSrc <= '1'; s_unsigned <= '1'; s_WA <= "00010"; s_RA1 <= "11001"; s_imm <= x"0004"; s_MemtoReg <= '0'; wait for cCLK_PER;

-- add x1, x1, x2
s_WE <= '1'; s_WA <= "00001"; s_unsigned <= '0'; s_ALUSrc <= '0'; s_RA1 <= "00001"; s_RA2 <= "00010"; s_addsub <= '0'; s_MemtoReg <= '1'; wait for cCLK_PER;

-- sw x1, 0(x26)
s_ALUSrc <= '1'; s_unsigned <= '1'; s_MemWrite <= '1'; s_RA1 <= "11010"; s_RA2 <= "00001"; s_imm <= x"0000"; s_WE <= '0'; wait for cCLK_PER; s_MemWrite <= '0';

-- Sum A[2], accumulate, store in B[1]
-- lw x2, 8(x25)
s_WE <= '1'; s_ALUSrc <= '1'; s_unsigned <= '1'; s_WA <= "00010"; s_RA1 <= "11001"; s_imm <= x"0008"; s_MemtoReg <= '0'; wait for cCLK_PER;

-- add x1, x1, x2
s_WE <= '1'; s_unsigned <= '0'; s_WA <= "00001"; s_ALUSrc <= '0'; s_RA1 <= "00001"; s_RA2 <= "00010"; s_MemtoReg <= '1'; wait for cCLK_PER;

-- sw x1, 4(x26)
s_ALUSrc <= '1'; s_unsigned <= '1'; s_MemWrite <= '1'; s_RA1 <= "11010"; s_RA2 <= "00001"; s_imm <= x"0004"; s_WE <= '0'; wait for cCLK_PER; s_MemWrite <= '0';

-- Sum A[3], accumulate, store in B[2]
-- lw x2, 12(x25)
s_WE <= '1'; s_ALUSrc <= '1'; s_unsigned <= '1'; s_WA <= "00010"; s_RA1 <= "11001"; s_imm <= x"000C"; s_MemtoReg <= '0'; wait for cCLK_PER;

-- add x1, x1, x2
s_WE <= '1'; s_WA <= "00001"; s_unsigned <= '0'; s_ALUSrc <= '0'; s_RA1 <= "00001"; s_RA2 <= "00010"; s_MemtoReg <= '1'; wait for cCLK_PER;

-- sw x1, 8(x26)
s_ALUSrc <= '1'; s_unsigned <= '1'; s_MemWrite <= '1'; s_RA1 <= "11010"; s_RA2 <= "00001"; s_imm <= x"0008"; s_WE <= '0'; wait for cCLK_PER; s_MemWrite <= '0';

-- Sum A[4], accumulate, store in B[3]
-- lw x2, 16(x25)
s_WE <= '1'; s_ALUSrc <= '1'; s_unsigned <= '1'; s_WA <= "00010"; s_RA1 <= "11001"; s_imm <= x"0010"; s_MemtoReg <= '0'; wait for cCLK_PER;

-- add x1, x1, x2
s_WE <= '1'; s_WA <= "00001"; s_unsigned <= '0'; s_ALUSrc <= '0'; s_RA1 <= "00001"; s_RA2 <= "00010"; s_MemtoReg <= '1'; wait for cCLK_PER;

-- sw x1, 12(x26)
s_ALUSrc <= '1'; s_unsigned <= '1'; s_MemWrite <= '1'; s_RA1 <= "11010"; s_RA2 <= "00001"; s_imm <= x"000C"; s_WE <= '0'; wait for cCLK_PER; s_MemWrite <= '0';

-- Sum A[5], accumulate, store in B[4]
-- lw x2, 20(x25)
s_WE <= '1'; s_ALUSrc <= '1'; s_unsigned <= '1'; s_WA <= "00010"; s_RA1 <= "11001"; s_imm <= x"0014"; s_MemtoReg <= '0'; wait for cCLK_PER;

-- add x1, x1, x2
s_WE <= '1'; s_WA <= "00001"; s_unsigned <= '0'; s_ALUSrc <= '0'; s_RA1 <= "00001"; s_RA2 <= "00010"; s_MemtoReg <= '1'; wait for cCLK_PER;

-- sw x1, 16(x26)
s_ALUSrc <= '1'; s_unsigned <= '1'; s_MemWrite <= '1'; s_RA1 <= "11010"; s_RA2 <= "00001"; s_imm <= x"0010"; s_WE <= '0'; wait for cCLK_PER; s_MemWrite <= '0';

-- Sum A[6], accumulate
-- lw x2, 24(x25)
s_WE <= '1'; s_ALUSrc <= '1'; s_unsigned <= '1'; s_WA <= "00010"; s_RA1 <= "11001"; s_imm <= x"0018"; s_MemtoReg <= '0'; wait for cCLK_PER;

-- add x1, x1, x2
s_WE <= '1'; s_WA <= "00001"; s_unsigned <= '0'; s_ALUSrc <= '0'; s_RA1 <= "00001"; s_RA2 <= "00010"; s_MemtoReg <= '1'; wait for cCLK_PER;

-- Prepare to store into B[63]
-- addi x27, x0, 512
s_WE <= '1'; s_unsigned <= '0'; s_WE <= '1'; s_WA <= "11011"; s_RA1 <= "00000"; s_ALUSrc <= '1'; s_imm <= x"0200"; s_MemtoReg <= '1'; wait for cCLK_PER;

-- sw x1, -4(x27)
s_ALUSrc <= '1'; s_unsigned <= '1'; s_MemWrite <= '1'; s_RA1 <= "11011"; s_RA2 <= "00001"; s_imm <= x"FFFC"; s_WE <= '0'; wait for cCLK_PER; s_MemWrite <= '0';

-- sw x1, -4(x27) (same store repeated)
s_ALUSrc <= '1'; s_unsigned <= '1'; s_MemWrite <= '1'; s_RA1 <= "11011"; s_RA2 <= "00001"; s_imm <= x"FFFC"; s_WE <= '0'; wait for cCLK_PER; s_MemWrite <= '0';

        wait;
    end process p_TESTS;

end behavior;
