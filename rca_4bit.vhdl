library IEEE;
use IEEE.std_logic_1164.all;

entity rca_4bit is
port (a_i : in std_logic_vector(3 downto 0);
		b_i : in std_logic_vector(3 downto 0);
		sum_o : out std_logic_vector(3 downto 0);
		cout : out std_logic);
end entity;

architecture rca_4bit_arch of rca_4bit is
component full_adder 
port (a_i : in std_logic;
		b_i : in std_logic;
		cin : in std_logic;
		sum_o : out std_logic;
		cout : out std_logic);
end component;
signal C1, C2, C3 : std_logic;
begin
	FA0 : full_adder port map (a_i(0), b_i(0), '0', sum_o(0), C1);
	FA1 : full_adder port map (a_i(1), b_i(1), C1, sum_o(1), C2);
	FA2 : full_adder port map (a_i(2), b_i(2), C2, sum_o(2), C3);
	FA3 : full_adder port map (a_i(3), b_i(3), C3, sum_o(3), cout);
end architecture;