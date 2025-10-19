library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_extender is
end tb_extender;

architecture behavior of tb_extender is

    -- Timing constants
    constant gCLK_HPER : time := 50 ns;
    constant cCLK_PER  : time := 2 * gCLK_HPER;

    -- DUT generic
    constant N : integer := 16;

    -- DUT ports
    signal s_in16      : std_logic_vector((N-1) downto 0) := (others => '0');
    signal s_unsigned  : std_logic := '0';
    signal s_out32     : std_logic_vector(((N*2)-1) downto 0);

begin

    -- Instantiate DUT
    uut: entity work.extender
        generic map (N => N)
        port map (
            i_in16     => s_in16,
            i_unsigned => s_unsigned,
            o_out32    => s_out32
        );

    -- Stimulus process
    stim_proc : process
    begin
        -- Test 1: Signed positive
        -- Input: 0x1234, Signed -> Expect 0x00001234
        s_in16     <= x"1234";
        s_unsigned <= '0';
        wait for cCLK_PER;

        -- Test 2: Signed negative
        -- Input: 0xF234, Signed -> Expect 0xFFFFF234
        s_in16     <= x"F234";
        s_unsigned <= '0';
        wait for cCLK_PER;

        -- Test 3: Unsigned same input
        -- Input: 0xF234, Unsigned -> Expect 0x0000F234
        s_in16     <= x"F234";
        s_unsigned <= '1';
        wait for cCLK_PER;

        -- Test 4: Unsigned small value
        -- Input: 0x00AB, Unsigned -> Expect 0x000000AB
        s_in16     <= x"00AB";
        s_unsigned <= '1';
        wait for cCLK_PER;

        -- Test 5: Signed all ones
        -- Input: 0xFFFF, Signed -> Expect 0xFFFFFFFF
        s_in16     <= x"FFFF";
        s_unsigned <= '0';
        wait for cCLK_PER;

        -- Simulation complete
        wait;
    end process;

end behavior;

