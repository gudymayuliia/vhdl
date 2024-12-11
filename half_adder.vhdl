library IEEE;
use IEEE.std_logic_1164.all;

entity half_adder is
port (a_i : in std_logic;
		b_i : in std_logic;
		sum_o : out std_logic;
		cout : out std_logic);
end entity;

architecture half_adder_arch of half_adder is
begin
	sum_o <= a_i xor b_i;
	cout <= a_i and b_i;
end architecture;