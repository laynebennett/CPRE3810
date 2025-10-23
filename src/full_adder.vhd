library IEEE;
use IEEE.std_logic_1164.all;

entity full_adder is
    port (
        i_A  : in  std_logic;
        i_B  : in  std_logic;
        i_Cin: in  std_logic;
        o_Sum: out std_logic;
        o_Cout: out std_logic
    );
end full_adder;

architecture structure of full_adder is

    component xorg2
        port (
            i_A : in std_logic;
            i_B : in std_logic;
            o_F : out std_logic
        );
    end component;

    component andg2
        port (
            i_A : in std_logic;
            i_B : in std_logic;
            o_F : out std_logic
        );
    end component;

    component org2
        port (
            i_A : in std_logic;
            i_B : in std_logic;
            o_F : out std_logic
        );
    end component;

    signal xor1_out : std_logic;
    signal xor2_out : std_logic;
    signal and1_out : std_logic;
    signal and2_out : std_logic;

begin

    part1: xorg2 port map(i_A => i_A, i_B => i_B, o_F => xor1_out);
    part2: xorg2 port map(i_A => xor1_out, i_B => i_Cin, o_F => o_Sum);

    part3: andg2 port map(i_A => i_A, i_B => i_B, o_F => and1_out);
    part4: andg2 port map(i_A => xor1_out, i_B => i_Cin, o_F => and2_out);

    part5: org2 port map(i_A => and1_out, i_B => and2_out, o_F => o_Cout);

end structure;
