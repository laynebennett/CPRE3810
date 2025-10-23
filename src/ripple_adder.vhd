library IEEE;
use IEEE.std_logic_1164.all;

entity ripple_adder is
    generic(N : integer := 32);
    port (
        i_A    : in  std_logic_vector(N-1 downto 0);
        i_B    : in  std_logic_vector(N-1 downto 0);
        i_Cin  : in  std_logic;
        o_Sum  : out std_logic_vector(N-1 downto 0);
        o_Cout : out std_logic
    );
end ripple_adder;

architecture structure of ripple_adder is

    component full_adder
        port (
            i_A    : in  std_logic;
            i_B    : in  std_logic;
            i_Cin  : in  std_logic;
            o_Sum  : out std_logic;
            o_Cout : out std_logic
        );
    end component;

    signal c : std_logic_vector(N downto 0); -- carry chain

begin

    c(0) <= i_Cin;

    adder_chain : for i in 0 to N-1 generate
        FA : full_adder
            port map(
                i_A    => i_A(i),
                i_B    => i_B(i),
                i_Cin  => c(i),
                o_Sum  => o_Sum(i),
                o_Cout => c(i+1)
            );
    end generate;

    o_Cout <= c(N);

end structure;
