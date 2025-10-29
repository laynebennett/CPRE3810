library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control is 
port(
	i_instruction : in std_logic_vector(6 downto 0);
	Branch : out std_logic;
	MemRead : out std_logic;
	MemtoReg : out std_logic;
	ALUOp : out std_logic_vector(1 downto 0);
	MemWrite : out std_logic;
	ALUSrc : out std_logic;
	RegWrite : out std_logic	
);
end control;

architecture behavioral of control is 

	signal i_control : std_logic_vector(6 downto 0);
    	
begin

i_control <= i_instruction;

process
begin

--R type
if i_control = "0110011" then
	Branch <= '0';
	MemRead <= '0';
	MemtoReg <= '0';
	ALUOp <= "10";
	Memwrite <= '0';
	ALUSrc <= '0';
	Regwrite <= '1';
--I(imm) type
elsif i_control = "0010011" then
	Branch <= '0';
	MemRead <= '0';
	MemtoReg <= '0';
	ALUOp <= "10";
	Memwrite <= '0';
	ALUSrc <= '1';
	Regwrite <= '1';
--I(Load) type
elsif i_control = "0000011" then
	Branch <= '0';
	MemRead <= '1';
	MemtoReg <= '1';
	ALUOp <= "00";
	Memwrite <= '0';
	ALUSrc <= '1';
	Regwrite <= '1';
--I(Jump) type
elsif i_control = "1100111" then
	Branch <= '0';
	MemRead <= '0';
	MemtoReg <= '0';
	ALUOp <= "00";
	Memwrite <= '0';
	ALUSrc <= '1';
	Regwrite <= '1';
--S type
elsif i_control = "0100011" then
	Branch <= '0';
	MemRead <= '0';
	MemtoReg <= '0';
	ALUOp <= "00";
	Memwrite <= '1';
	ALUSrc <= '1';
	Regwrite <= '0';
--B type
elsif i_control = "1100011" then
	Branch <= '1';
	MemRead <= '0';
	MemtoReg <= '0';
	ALUOp <= "01";
	Memwrite <= '0';
	ALUSrc <= '1';
	Regwrite <= '1';
--U(AUIPC) type
elsif i_control = "0010111" then
	Branch <= '0';
	MemRead <= '0';
	MemtoReg <= '0';
	ALUOp <= "00";
	Memwrite <= '0';
	ALUSrc <= '1';
	Regwrite <= '1';
--U(LUI) type
elsif i_control = "0110111" then
	Branch <= '0';
	MemRead <= '0';
	MemtoReg <= '0';
	ALUOp <= "00";
	Memwrite <= '0';
	ALUSrc <= '1';
	Regwrite <= '1';
--J type
elsif i_control = "1101111" then
	Branch <= '0';
	MemRead <= '0';
	MemtoReg <= '0';
	ALUOp <= "00";
	Memwrite <= '0';
	ALUSrc <= '1';
	Regwrite <= '1';

	end if;

end process;

end behavioral; 
