
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_ripple_adder is
end tb_ripple_adder;

architecture behavior of tb_ripple_adder is

    constant N : integer := 4;

    component ripple_adder
        generic(N : integer := 4);
        port (
            i_A    : in  std_logic_vector(N-1 downto 0);
            i_B    : in  std_logic_vector(N-1 downto 0);
            i_Cin  : in  std_logic;
            o_Sum  : out std_logic_vector(N-1 downto 0);
            o_Cout : out std_logic
        );
    end component;

    signal i_A    : std_logic_vector(N-1 downto 0) := (others => '0');
    signal i_B    : std_logic_vector(N-1 downto 0) := (others => '0');
    signal i_Cin  : std_logic := '0';
    signal o_Sum  : std_logic_vector(N-1 downto 0);
    signal o_Cout : std_logic;

begin

    uut: ripple_adder
        generic map(N => N)
        port map(
            i_A    => i_A,
            i_B    => i_B,
            i_Cin  => i_Cin,
            o_Sum  => o_Sum,
            o_Cout => o_Cout
        );

    stim_proc: process
    begin
        -- Case 1: 3 + 5 = 8
        i_A <= "0011"; i_B <= "0101"; i_Cin <= '0'; wait for 10 ns;

        -- Case 2: 9 + 6 + Cin = 16 => sum = 0000, carry = 1
        i_A <= "1001"; i_B <= "0110"; i_Cin <= '1'; wait for 10 ns;

        -- Case 3: 15 + 1 = 16 => sum = 0000, carry = 1
        i_A <= "1111"; i_B <= "0001"; i_Cin <= '0'; wait for 10 ns;

        wait;
    end process;

end behavior;
