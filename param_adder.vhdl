--Parameterized N-Bit Adder-Subtractor:
--Create a parameterized module for an N-bit adder-subtractor (N as a parameter).
--Inputs: A (N bits), B (N bits), Sub (when Sub = 1, it performs subtraction, otherwise addition).
--Output: Result (N bits).
library IEEE;
use IEEE.std_logic_1164.all;

entity param_adder is
generic( N : integer := 4);
port (a_i : in std_logic_vector(N-1 downto 0);
		b_i : in std_logic_vector(N-1 downto 0);
		sub : in std_logic;
		sum_o : out std_logic_vector(N-1 downto 0);
		cout : out std_logic);
end entity;

architecture param_adder_arch of param_adder is
component full_adder 
port (a_i : in std_logic;
		b_i : in std_logic;
		cin : in std_logic;
		sum_o : out std_logic;
		cout : out std_logic);
end component;
signal carry_s : std_logic_vector(N downto 0);
signal b_tmp : std_logic_vector(N-1 downto 0);
begin
	gen_b_tmp : for i in 0 to N-1 generate
		b_tmp(i) <= b_i(i) xor sub;
	end generate;
	carry_s(0) <= sub;
	gen_FA : for i in 0 to N-1 generate
		FA : full_adder port map (a_i(i), b_tmp(i), carry_s(i), sum_o(i), carry_s(i+1));
	end generate;
	cout <= carry_s(N);
end architecture;