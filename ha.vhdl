library IEEE;
use IEEE.std_logic_1164.all;

entity ha is
port (a_i : in std_logic;
		b_i : in std_logic;
		sum_o : out std_logic;
		cout_o : out std_logic);
end entity;

architecture half_adder_arch of ha is
begin
	sum_o <= a_i xor b_i;
	cout_o <= a_i and b_i;
end architecture;