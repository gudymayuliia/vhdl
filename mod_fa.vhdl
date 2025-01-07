library IEEE;
use IEEE.std_logic_1164.all;

entity mod_fa is
port(a_i : in std_logic;
		b_i : in std_logic;
		cin : in std_logic;
		sum_o : out std_logic;
		cout_o : out std_logic);
end entity;

architecture full_adder_arch of mod_fa is
component ha
	port (a_i : in std_logic;
			b_i : in std_logic;
			sum_o : out std_logic;
			cout_o : out std_logic);
end component;

signal HA1_sum, HA1_cout, HA2_cout : std_logic;
begin
	HA1 : ha port map (a_i, b_i, HA1_sum, HA1_cout);
	HA2 : ha port map (HA1_sum, cin, sum_o, HA2_cout);
	cout_o <= HA1_cout or HA2_cout;
end architecture;
