
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

--mem load -infile /home/layneben/Downloads/Lab2/dmem.hex -format hex /tb_mem/DUT/ram

entity tb_mem is

  generic(gCLK_HPER   : time := 50 ns;
		DATA_WIDTH : natural := 32;
		ADDR_WIDTH : natural := 10
	);

end entity;

architecture behavior of tb_mem is

    constant cCLK_PER  : time := gCLK_HPER * 2;
    constant N : integer := 32;

	component mem
	generic 
	(
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

	signal s_clk		: std_logic;
	signal s_addr	        : std_logic_vector((ADDR_WIDTH-1) downto 0);
	signal s_data	        : std_logic_vector((DATA_WIDTH-1) downto 0);
	signal s_we		: std_logic := '1';
	signal s_q		: std_logic_vector((DATA_WIDTH -1) downto 0);

	-- Build a 2-D array type for the RAM
	subtype word_t is std_logic_vector((DATA_WIDTH-1) downto 0);
	type memory_t is array(2**ADDR_WIDTH-1 downto 0) of word_t;

	-- Declare the RAM signal and specify a default value.	Quartus Prime
	-- will load the provided memory initialization file (.mif).
	signal ram : memory_t;


    -- Clock Generation
    constant clk_period : time := 10 ns;
    signal clk_counter  : integer := 0;

begin

    -- DUT Instantiation
    DUT: mem
        generic map(
		DATA_WIDTH => DATA_WIDTH,
		ADDR_WIDTH => ADDR_WIDTH)
        port map(
            clk     => s_clk,
            addr    => s_addr,
            data    => s_data,
            we      => s_we,
            q       => s_q
        );

--clock process
  P_CLK: process
  begin
    s_clk <= '0';
    wait for gCLK_HPER;
    s_clk <= '1';
    wait for gCLK_HPER;
  end process;

  tb: process
  begin

	s_we <= '0';
	for i in 0 to 9 loop --read mem
	s_addr <= std_logic_vector(to_unsigned(i, ADDR_WIDTH));
	
	wait for cCLK_PER;

	ram(i) <= s_q;

  end loop;

	s_we <= '1';
  	for i in 0 to 9 loop --write mem
	s_addr <= std_logic_vector(to_unsigned(256 + i, ADDR_WIDTH));
	s_data <= ram(i);
	

	wait for cCLK_PER;
	
  end loop;

  s_we <= '0';

	s_we <= '0';
	for i in 0 to 9 loop --read new mem
	s_addr <= std_logic_vector(to_unsigned(256+ i, ADDR_WIDTH));
	
	wait for cCLK_PER;

	ram(i) <= s_q;

  end loop;
	
  wait;
end process;

end behavior;
