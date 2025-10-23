
library IEEE;
use IEEE.std_logic_1164.all;

entity addsubi is
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
end addsubi;

architecture structure of addsubi is

    component busmux2to1
	port(
	i_S : in std_logic;
	i_D0 : in std_logic_vector(31 downto 0);
	i_D1 : in std_logic_vector(31 downto 0);
	o_Q : out std_logic_vector(31 downto 0));
    end component;


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

    component xorg2
        port (
            i_A : in std_logic;
            i_B : in std_logic;
            o_F : out std_logic
        );
    end component;

    signal b_xor_sub : std_logic_vector(N-1 downto 0);
    signal muxtoxor : std_logic_vector(N-1 downto 0);

begin

    busmux_inst: busmux2to1
	port map(
	i_S => ALUSrc,
	i_D0 => i_B,
	i_D1 => i_imm,
	o_Q => muxtoxor
	);

    gen_xor: for i in 0 to N-1 generate
        bx: entity work.xorg2(dataflow)
            port map (
                i_A => muxtoxor(i),
                i_B => i_Sub,
                o_F => b_xor_sub(i)
            );
    end generate;

    adder_inst: ripple_adder
        generic map(N => N)
        port map(
            i_A    => i_A,
            i_B    => b_xor_sub,
            i_Cin  => i_Sub,
            o_Sum  => o_Sum,
            o_Cout => o_Cout
        );

end structure;