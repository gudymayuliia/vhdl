library IEEE;
use IEEE.std_logic_1164.all;

entity register_4bit is
port (clk : in std_logic;
		D : in std_logic_vector(3 downto 0);
		reset, enable : in std_logic;
		Q : out std_logic_vector(3 downto 0));
end entity;

architecture register_4bit_arch of register_4bit is
begin
	process (clk)
		begin
		if(rising_edge(clk)) then
			if(reset = '0') then
				Q <= (others => '0');
			elsif(enable = '1') then
				Q <= D;
			end if;
		end if;
		 
		end process;
end architecture;