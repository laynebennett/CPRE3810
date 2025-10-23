
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity extender is

	generic(N : integer := 16);

	port 
	(
		i_in16	        : in std_logic_vector((N-1) downto 0);
		i_unsigned	: in std_logic; --1 for unsigned
		o_out32		: out std_logic_vector(((N*2)-1) downto 0)
	);

end extender;

architecture structure of extender is

    signal muxtoadd : std_logic_vector((N-1) downto 0);
    signal s_sign   : std_logic;
    signal upper    : std_logic_vector((N-1) downto 0);

    component halfbusmux2to1    
      port(
        i_S  : in std_logic;
        i_D0 : in std_logic_vector(15 downto 0);
        i_D1 : in std_logic_vector(15 downto 0);
        o_Q  : out std_logic_vector(15 downto 0)
      );
    end component;

begin

    s_sign <= i_in16(N-1);

    -- Pick sign bits for signed case
    busmux2to1_i : halfbusmux2to1
      port map(
        i_S  => s_sign,
        i_D0 => x"0000",
        i_D1 => x"FFFF",
        o_Q  => muxtoadd
      );

    -- Choose between signed and unsigned upper bits
    upper <= (others => '0') when (i_unsigned = '1') else muxtoadd;

    -- Combine high and low halves
    o_out32 <= upper & i_in16;

end structure;

