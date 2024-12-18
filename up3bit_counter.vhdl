--3-Bit Binary Counter:
--Design a 3-bit up-counter with reset and enable:
--Inputs: clk, reset, enable.
--Output: count (3-bit output).
--The counter should increment on each rising clock edge when enable is active and reset to zero when reset is active.


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity up3bit_counter is
port (clk : in std_logic;
		reset : in std_logic;
		enable : in std_logic;
		count : out unsigned(2 downto 0));
end entity;

architecture up3bit_counter_arch of up3bit_counter is
signal CNT_tmp : unsigned (2 downto 0);
begin
COUNTER : process(clk, reset)
begin
	if(reset = '0') then
		CNT_tmp <= "000";
	elsif (rising_edge(clk)) then
		if(enable = '1') then
			CNT_tmp <= CNT_tmp + 1;
		end if;
	end if;
count <= CNT_tmp;
end process;
end architecture;















