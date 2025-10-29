
library IEEE;
use IEEE.std_logic_1164.all;library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_bshiftr is
  generic(
    gCLK_HPER : time := 50 ns;
    N         : integer := 32
  );
end tb_bshiftr;

architecture behavior of tb_bshiftr is

  constant cCLK_PER : time := gCLK_HPER * 2;

  component bshiftr
    port(
      i_d     : in  std_logic_vector(N-1 downto 0);
      i_shift : in  std_logic_vector(4 downto 0);
      i_arith : in  std_logic;
      i_dir   : in  std_logic;
      o_d     : out std_logic_vector(N-1 downto 0)
    );
  end component;

  -- signals
  signal s_d      : std_logic_vector(N-1 downto 0);
  signal s_shift  : std_logic_vector(4 downto 0);
  signal s_arith  : std_logic;
  signal s_dir    : std_logic;
  signal s_out    : std_logic_vector(N-1 downto 0);

begin

  DUT: bshiftr
    port map(
      i_d     => s_d,
      i_shift => s_shift,
      i_arith => s_arith,
      i_dir   => s_dir,
      o_d     => s_out
    );

  process
  begin
    ----------------------------------------------------------------
    -- Test 1: Logical shift left by 1
    ----------------------------------------------------------------
    s_d     <= x"0000000F";   -- 0000...1111
    s_shift <= "00001";       -- shift by 1
    s_arith <= '0';           -- logical
    s_dir   <= '0';           -- left
    wait for 100 ns;
    -- Expected: 0000...11110 = 0x0000001E

    ----------------------------------------------------------------
    -- Test 2: Logical shift right by 2
    ----------------------------------------------------------------
    s_d     <= x"000000F0";   -- 11110000
    s_shift <= "00010";       -- shift by 2
    s_arith <= '0';           -- logical
    s_dir   <= '1';           -- right
    wait for 100 ns;
    -- Expected: 00000011C0 (actually 0x0000003C)

    ----------------------------------------------------------------
    -- Test 3: Arithmetic shift right by 4 on positive number
    ----------------------------------------------------------------
    s_d     <= x"00000F00";   -- 0000...111100000000
    s_shift <= "00100";       -- shift by 4
    s_arith <= '1';           -- arithmetic
    s_dir   <= '1';           -- right
    wait for 100 ns;
    -- Expected: 0x000000F0 (fill with 0s since MSB=0)

    ----------------------------------------------------------------
    -- Test 4: Arithmetic shift right by 4 on negative number
    ----------------------------------------------------------------
    s_d     <= x"F0000000";   -- MSB = 1 (negative)
    s_shift <= "00100";       -- shift by 4
    s_arith <= '1';           -- arithmetic
    s_dir   <= '1';           -- right
    wait for 100 ns;
    -- Expected: 0xFF000000 (sign bits filled with 1s)

    ----------------------------------------------------------------
    -- Test 5: Logical shift right by 8
    ----------------------------------------------------------------
    s_d     <= x"00FF0000";
    s_shift <= "01000";       -- shift by 8
    s_arith <= '0';
    s_dir   <= '1';
    wait for 100 ns;
    -- Expected: 0x0000FF00

    ----------------------------------------------------------------
    -- Test 6: Logical shift left by 8
    ----------------------------------------------------------------
    s_d     <= x"000000FF";
    s_shift <= "01000";       -- shift by 8
    s_arith <= '0';
    s_dir   <= '0';
    wait for 100 ns;
    -- Expected: 0x0000FF00

    ----------------------------------------------------------------
    -- Test 7: Arithmetic right shift by 31
    ----------------------------------------------------------------
    s_d     <= x"80000000";   -- only MSB set
    s_shift <= "11111";       -- shift by 31
    s_arith <= '1';
    s_dir   <= '1';
    wait for 100 ns;
    -- Expected: 0xFFFFFFFF (all bits filled with 1s)

    ----------------------------------------------------------------
    -- Test 8: Logical right shift by 31
    ----------------------------------------------------------------
    s_d     <= x"80000000";
    s_shift <= "11111";
    s_arith <= '0';
    s_dir   <= '1';
    wait for 100 ns;
    -- Expected: 0x00000001

    ----------------------------------------------------------------
    -- Test 9: No shift (should output same value)
    ----------------------------------------------------------------
    s_d     <= x"12345678";
    s_shift <= "00000";
    s_arith <= '0';
    s_dir   <= '0';
    wait for 100 ns;
    -- Expected: 0x12345678

    wait;
  end process;

end behavior;
