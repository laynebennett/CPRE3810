
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_RISCVDATA is

  generic(gCLK_HPER   : time := 50 ns);

end entity;

architecture behavior of tb_RISCVDATA is

    constant cCLK_PER  : time := gCLK_HPER * 2;
    constant N : integer := 32;

    -- Component Declaration
    component RISCVDATA
        generic(N : integer := 32);
        port(
            i_CLK      : in std_logic;
            i_WA       : in std_logic_vector(4 downto 0);
            i_RA1      : in std_logic_vector(4 downto 0);
            i_RA2      : in std_logic_vector(4 downto 0);
            i_WE       : in std_logic;
            i_imm      : in std_logic_vector(N-1 downto 0);
            i_RST_ALL  : in std_logic;
            i_addsub   : in std_logic;
            i_ALUSrc   : in std_logic;
            o_ALU      : out std_logic_vector(N-1 downto 0);
            o_Cout     : out std_logic
        );
    end component;

    -- Signals
    signal s_CLK     : std_logic := '0';
    signal s_WA      : std_logic_vector(4 downto 0);
    signal s_RA1     : std_logic_vector(4 downto 0);
    signal s_RA2     : std_logic_vector(4 downto 0);
    signal s_WE      : std_logic := '0';
    signal s_imm     : std_logic_vector(N-1 downto 0);
    signal s_RST_ALL : std_logic := '0';
    signal s_addsub  : std_logic := '0';
    signal s_ALUSrc  : std_logic := '0';
    signal s_ALU     : std_logic_vector(N-1 downto 0);
    signal s_Cout    : std_logic;

    -- Clock Generation
    constant clk_period : time := 10 ns;
    signal clk_counter  : integer := 0;

begin

    -- DUT Instantiation
    DUT: RISCVDATA
        generic map(N => N)
        port map(
            i_CLK      => s_CLK,
            i_WA       => s_WA,
            i_RA1      => s_RA1,
            i_RA2      => s_RA2,
            i_WE       => s_WE,
            i_imm      => s_imm,
            i_RST_ALL  => s_RST_ALL,
            i_addsub   => s_addsub,
            i_ALUSrc   => s_ALUSrc,
            o_ALU      => s_ALU,
            o_Cout     => s_Cout
        );

--clock process
  P_CLK: process
  begin
    s_CLK <= '0';
    wait for gCLK_HPER;
    s_CLK <= '1';
    wait for gCLK_HPER;
  end process;

    -- test process run 700
    stim_proc : process
    begin
        -- Reset all

	s_RA1 <= "00000";
	s_RA2 <= "00000";
	
	s_WE <= '0';
        s_RST_ALL <= '1';
        wait for cCLK_PER;
        s_RST_ALL <= '0';

---------------------------------------
	
        s_WA <= "00001";      -- Write to reg1
        s_ALUSrc <= '1';      -- Use immediate
        s_imm <= x"00000001"; --write 1
        s_addsub <= '0';      -- Add
	
	s_WE <= '1';
        wait for cCLK_PER;
        s_WE <= '0';

----------------------------------------
    
        s_WA <= "00010";      -- Write to reg2
        s_ALUSrc <= '1';      -- Use immediate
        s_imm <= x"00000002"; --write 2
        s_addsub <= '0';      -- Add

        s_WE <= '1';
        wait for cCLK_PER;
        s_WE <= '0';

----------------------------------------
    
        s_WA <= "00011";      -- Write to reg3
        s_ALUSrc <= '1';      -- Use immediate
        s_imm <= x"00000003"; --write 3
        s_addsub <= '0';      -- Add

        s_WE <= '1';
        wait for cCLK_PER;
        s_WE <= '0';

----------------------------------------
    
        s_WA <= "00100";      -- Write to reg4
        s_ALUSrc <= '1';      -- Use immediate
        s_imm <= x"00000004"; --write 4
        s_addsub <= '0';      -- Add

        s_WE <= '1';
        wait for cCLK_PER;
        s_WE <= '0';

----------------------------------------
    
        s_WA <= "00101";      -- Write to reg5
        s_ALUSrc <= '1';      -- Use immediate
        s_imm <= x"00000005"; --write 5
        s_addsub <= '0';      -- Add

        s_WE <= '1';
        wait for cCLK_PER;
        s_WE <= '0';

----------------------------------------
    
        s_WA <= "00110";      -- Write to reg6
        s_ALUSrc <= '1';      -- Use immediate
        s_imm <= x"00000006"; --write 6
        s_addsub <= '0';      -- Add

        s_WE <= '1';
        wait for cCLK_PER;
        s_WE <= '0';

----------------------------------------
    
        s_WA <= "00111";      -- Write to reg7
        s_ALUSrc <= '1';      -- Use immediate
        s_imm <= x"00000007"; --write 7
        s_addsub <= '0';      -- Add

        s_WE <= '1';
        wait for cCLK_PER;
        s_WE <= '0';

----------------------------------------
    
        s_WA <= "01000";      -- Write to reg8
        s_ALUSrc <= '1';      -- Use immediate
        s_imm <= x"00000008"; --write 8
        s_addsub <= '0';      -- Add

        s_WE <= '1';
        wait for cCLK_PER;
        s_WE <= '0';

----------------------------------------
    
        s_WA <= "01001";      -- Write to reg9
        s_ALUSrc <= '1';      -- Use immediate
        s_imm <= x"00000009"; --write 0
        s_addsub <= '0';      -- Add

        s_WE <= '1';
        wait for cCLK_PER;
        s_WE <= '0';

----------------------------------------
    
        s_WA <= "01010";      -- Write to reg10
        s_ALUSrc <= '1';      -- Use immediate
        s_imm <= x"0000000A"; --write 10
        s_addsub <= '0';      -- Add

        s_WE <= '1';
        wait for cCLK_PER;
        s_WE <= '0';

-----------------------------------------

        s_RA1 <= "00001";     -- reg1 = 1
        s_RA2 <= "00010";     -- reg2 = 2
        s_ALUSrc <= '0';      -- Use reg2
        s_addsub <= '0';      -- Add
      

	s_WA <= "01011";      -- write result to reg11
	s_WE <= '1';
	wait for cCLK_PER;
	s_WE <= '0';

-----------------------------------------

        s_RA1 <= "01011";     -- reg11 = 2
        s_RA2 <= "00011";     -- reg3 = 3
        s_ALUSrc <= '0';      -- Use reg2
        s_addsub <= '1';      -- Sub
      

	s_WA <= "01100";      -- write result to reg12
	s_WE <= '1';
	wait for cCLK_PER;
	s_WE <= '0';

-----------------------------------------

        -- add r13, r12, r4 => r13 = r12 + r4
        s_RA1 <= "01100";     -- r12
        s_RA2 <= "00100";     -- r4
        s_ALUSrc <= '0';      
        s_addsub <= '0';      

        s_WA <= "01101";      -- write result to r13
        s_WE <= '1';
        wait for cCLK_PER;
        s_WE <= '0';

-----------------------------------------
        -- sub r14, r13, r5 => r14 = r13 - r5
        s_RA1 <= "01101";     -- r13
        s_RA2 <= "00101";     -- r5
        s_ALUSrc <= '0';
        s_addsub <= '1';

        s_WA <= "01110";      -- write result to r14
        s_WE <= '1';
        wait for cCLK_PER;
        s_WE <= '0';

-----------------------------------------
        -- add r15, r14, r6 => r15 = r14 + r6
        s_RA1 <= "01110";     -- r14
        s_RA2 <= "00110";     -- r6
        s_ALUSrc <= '0';
        s_addsub <= '0';

        s_WA <= "01111";      -- write result to r15
        s_WE <= '1';
        wait for cCLK_PER;
        s_WE <= '0';

-----------------------------------------
        -- sub r16, r15, r7 => r16 = r15 - r7
        s_RA1 <= "01111";     -- r15
        s_RA2 <= "00111";     -- r7
        s_ALUSrc <= '0';
        s_addsub <= '1';

        s_WA <= "10000";      -- write result to r16
        s_WE <= '1';
        wait for cCLK_PER;
        s_WE <= '0';

-----------------------------------------
        -- add r17, r16, r8 => r17 = r16 + r8
        s_RA1 <= "10000";     -- r16
        s_RA2 <= "01000";     -- r8
        s_ALUSrc <= '0';
        s_addsub <= '0';

        s_WA <= "10001";      -- write result to r17
        s_WE <= '1';
        wait for cCLK_PER;
        s_WE <= '0';

-----------------------------------------
        -- sub r18, r17, r9 => r18 = r17 - r9
        s_RA1 <= "10001";     -- r17
        s_RA2 <= "01001";     -- r9
        s_ALUSrc <= '0';
        s_addsub <= '1';

        s_WA <= "10010";      -- write result to r18
        s_WE <= '1';
        wait for cCLK_PER;
        s_WE <= '0';

-----------------------------------------
        -- add r19, r18, r10 => r19 = r18 + r10
        s_RA1 <= "10010";     -- r18
        s_RA2 <= "01010";     -- r10
        s_ALUSrc <= '0';
        s_addsub <= '0';

        s_WA <= "10011";      -- write result to r19
        s_WE <= '1';
        wait for cCLK_PER;
        s_WE <= '0';

-----------------------------------------
        -- addi r20, zero, -35 => r20 = -35
        s_WA <= "10100";       -- r20
        s_ALUSrc <= '1';       
        s_imm <= std_logic_vector(to_signed(-35, N)); 
        s_addsub <= '0';       

        s_WE <= '1';
        wait for cCLK_PER;
        s_WE <= '0';

-----------------------------------------
        -- add r21, r19, r20 => r21 = r19 + r20
        s_RA1 <= "10011";     -- r19
        s_RA2 <= "10100";     -- r20
        s_ALUSrc <= '0';
        s_addsub <= '0';

        s_WA <= "10101";      -- write result to r21
        s_WE <= '1';
        wait for cCLK_PER;
        s_WE <= '0';

-----------------------------------------

        wait;
    end process;

end architecture;
