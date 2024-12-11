library IEEE;
use IEEE.std_logic_1164.all;

entity or_gate is 
port (C_i, D_i : in bit;
		F1_o : out bit);	 	
end entity;

architecture or_arch of or_gate is
begin
	F1_o <= C_i or D_i;
end architecture;