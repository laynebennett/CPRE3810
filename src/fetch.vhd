

library IEEE;
use IEEE.std_logic_1164.all;

entity fetch is
    port (
	i_CLK : in std_logic;
        i_addimm    : in  std_logic_vector(31 downto 0);
	i_branch : in std_logic;
	i_zero : in std_logic;
	o_instruction : out std_logic_vector(31 downto 0)
    );
end fetch;

architecture structure of fetch is

    component reg
	port(
	i_CLK        : in std_logic;     -- Clock input
        i_RST        : in std_logic;     -- Reset input
        i_WE         : in std_logic;     -- Write enable input
        i_D   : in std_logic_vector(31 downto 0);  -- n-bit data input
        o_Q   : out std_logic_vector(31 downto 0)  -- n-bit data output
	);
    end component;

    component i_mem
	generic (
	DATA_WIDTH : natural := 32;
	ADDR_WIDTH : natural := 10
	);

	port(
	clk		: in std_logic;
	addr	        : in std_logic_vector((ADDR_WIDTH-1) downto 0);
	data	        : in std_logic_vector((DATA_WIDTH-1) downto 0);
	we		: in std_logic := '1';
	q		: out std_logic_vector((DATA_WIDTH -1) downto 0)
	);
    end component;

    component busmux2to1
	port(
	i_S : in std_logic;
	i_D0 : in std_logic_vector(31 downto 0);
	i_D1 : in std_logic_vector(31 downto 0);
	o_Q : out std_logic_vector(31 downto 0)
	);
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

    component andg2
  	port(
	i_A          : in std_logic;
        i_B          : in std_logic;
        o_F          : out std_logic
	);
    end component;

    signal branchmux : std_logic;
    signal PCplus4 : std_logic_vector(31 downto 0);
    signal PCplusimm : std_logic_vector(31 downto 0);
    signal muxtoPC : std_logic_vector(31 downto 0);
    signal PCout : std_logic_vector(31 downto 0);

begin

    and_inst: andg2
	port map(
	i_A => i_branch,
	i_B => i_zero,
	o_F => branchmux
	);

    busmux_inst: busmux2to1
	port map(
	i_S => branchmux,
	i_D0 => PCplus4,
	i_D1 => PCplusimm,
	o_Q => muxtoPC
	);

    PC: reg
	port map(
	i_CLK => i_CLK,
	i_RST => '0',
        i_WE => '1',
        i_D => muxtoPC,
        o_Q => PCout
	);

    i_mem_inst: i_mem
	generic map(	
	DATA_WIDTH => 32,
	ADDR_WIDTH => 10)
	port map(
	clk => i_CLK,
	addr => PCout(9 downto 0),
	data => x"00000000",
	we => '0',
	q => o_instruction
	);

    add4: ripple_adder
        generic map(
	N => 32)
        port map(
        i_A => PCout,
        i_B => x"00000004",
        i_Cin => '0',
        o_Sum => PCplus4,
        o_Cout => open
        );

    addimm: ripple_adder
        generic map(
	N => 32)
        port map(
        i_A => PCout,
        i_B => i_addimm,
        i_Cin => '0',
        o_Sum => PCplusimm,
        o_Cout => open
        );

end structure;