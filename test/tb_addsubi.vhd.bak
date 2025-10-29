
library IEEE;
use IEEE.std_logic_1164.all;

entity tb_addsubi is

  generic(gCLK_HPER   : time := 50 ns;
  N : integer := 32);


end tb_addsubi;

architecture behavior of tb_addsubi is

  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;

  component addsubi
    port (
        i_A    : in  std_logic_vector(N-1 downto 0);
        i_B    : in  std_logic_vector(N-1 downto 0);
	i_imm  : in  std_logic_vector(N-1 downto 0);
	ALUSrc : in  std_logic;
        i_Sub  : in  std_logic; -- 0 = add, 1 = sub
        o_Sum  : out std_logic_vector(N-1 downto 0);
        o_Cout : out std_logic);
  end component;


  -- Temporary signals to connect to the ALU component.
        signal s_A    :   std_logic_vector(N-1 downto 0);
        signal s_B    :   std_logic_vector(N-1 downto 0);
	signal s_imm  :   std_logic_vector(N-1 downto 0);
	signal s_ALUSrc :   std_logic;
        signal s_Sub  :   std_logic; -- 0 = add, 1 = sub
        signal s_Sum  :  std_logic_vector(N-1 downto 0);
        signal s_Cout :  std_logic;

begin

  DUT: addsubi
    port map (
      i_A    => s_A,
      i_B    => s_B,
      i_imm  => s_imm,
      ALUSrc => s_ALUSrc,
      i_Sub  => s_Sub,
      o_Sum  => s_Sum,
      o_Cout => s_Cout
    );

  -- Testbench stimulus generation
  process
  begin
    -- Test 1: Addition without immediate value, i_Sub = 0
    s_A    <= x"0F0F0F0F";  -- A
    s_B    <= x"F0F0F0F0";  -- B 
    s_imm  <= x"00000000";  -- Not used in this case (ALUSrc = 0)
    s_ALUSrc <= '0';   -- Using B as input
    s_Sub  <= '0';     -- Addition
    wait for 100 ns;   -- Wait for result
    -- Expected: A + B = FFFFFFF, Carry-out = '0'
    -- o_Sum = "FFFFFFFF", o_Cout = '0'
    
    -- Test 2: Subtraction without immediate value, i_Sub = 1
    s_A    <= x"00000004";  -- A = 4
    s_B    <= x"00000002";  -- B = 2
    s_imm  <= x"00000000";  -- Not used
    s_ALUSrc <= '0';   -- Using B as input
    s_Sub  <= '1';     -- Subtraction
    wait for 100 ns;
    -- Expected: 4 - 2 = 2 (in binary: "0010"), Carry-out = '0'
    -- o_Sum = "0010", o_Cout = '1'

    -- Test 3: Addition using immediate value, i_Sub = 0, ALUSrc = 1
    s_A    <= x"00000002";  -- A = 2
    s_B    <= x"00000000";  -- Not used
    s_imm  <= x"00000003";  -- Immediate = 3
    s_ALUSrc <= '1';   -- Use immediate value
    s_Sub  <= '0';     -- Addition
    wait for 100 ns;
    -- Expected: 2 + 3 = 5 (in binary: "0101"), Carry-out = '0'
    -- o_Sum = "0101", o_Cout = '0'

    -- Test 4: Subtraction using immediate value, i_Sub = 1, ALUSrc = 1
    s_A    <= x"00000005";  -- A = 5
    s_B    <= x"00000000";  -- Not used
    s_imm  <= x"00000002";  -- Immediate = 2
    s_ALUSrc <= '1';   -- Use immediate value
    s_Sub  <= '1';     -- Subtraction
    wait for 100 ns;
    -- Expected: 5 - 2 = 3 (in binary: "0011"), Carry-out = '0'
    -- o_Sum = "0011", o_Cout = '1'

    -- Test 5: Adding two negative numbers (signed 2's complement)
    s_A    <= x"FFFFFFFE";  -- A = -2 (in 2's complement)
    s_B    <= x"FFFFFFFD";  -- B = -3 (in 2's complement)
    s_imm  <= x"00000000";  -- Not used
    s_ALUSrc <= '0';   -- Using B as input
    s_Sub  <= '0';     -- Addition
    wait for 100 ns;
    -- Expected: -2 + -3 = -5 (in 2's complement: "1011"), Carry-out = '0'
    -- o_Sum = "1011", o_Cout = '1'

    -- Test 6: Subtracting two negative numbers (signed 2's complement)
    s_A    <= x"FFFFFFFE";  -- A = -2 (in 2's complement)
    s_B    <= x"FFFFFFFD";  -- B = -3 (in 2's complement)
    s_imm  <= x"00000000";  -- Not used
    s_ALUSrc <= '0';   -- Using B as input
    s_Sub  <= '1';     -- Subtraction
    wait for 100 ns;
    -- Expected: -2 - (-3) = 1 (in binary: "0001"), Carry-out = '0'
    -- o_Sum = "0001", o_Cout = '1'

    -- Test 7: Addition with a zero operand
    s_A    <= x"00000000";  -- A = 0
    s_B    <= x"00000005";  -- B = 5
    s_imm  <= x"00000000";  -- Not used
    s_ALUSrc <= '0';   -- Using B as input
    s_Sub  <= '0';     -- Addition
    wait for 100 ns;
    -- Expected: 0 + 5 = 5 (in binary: "0101"), Carry-out = '0'
    -- o_Sum = "0101", o_Cout = '0'

    -- Test 8: Subtraction with a zero operand
    s_A    <= x"00000000";  -- A = 0
    s_B    <= x"00000005";  -- B = 5
    s_imm  <= x"00000000";  -- Not used
    s_ALUSrc <= '0';   -- Using B as input
    s_Sub  <= '1';     -- Subtraction
    wait for 100 ns;
    -- Expected: 0 - 5 = -5 (in 2's complement: "1011"), Carry-out = '1' (borrow)
    -- o_Sum = "1011", o_Cout = '0'

    -- End of tests
    wait;
  end process;

end behavior;