library IEEE;
use IEEE.std_logic_1164.all;

entity full_adder is
port(a_i : in std_logic;
		b_i : in std_logic;
		cin : in std_logic;
		sum_o : out std_logic;
		cout : out std_logic);
end entity;

architecture full_adder_arch of full_adder is
component half_adder
	port (a_i : in std_logic;
			b_i : in std_logic;
			sum_o : out std_logic;
			cout : out std_logic);
end component;
signal HA1_sum, HA1_cout, HA2_cout : std_logic;
begin
	HA1 : half_adder port map (a_i, b_i, HA1_sum, HA1_cout);
	HA2 : half_adder port map (HA1_sum, cin, sum_o, HA2_cout);
	cout <= HA1_cout or HA2_cout;
end architecture;