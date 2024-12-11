library IEEE;
use IEEE.std_logic_1164.all;

entity and_gate is 
port (A_i, B_i : in bit;
		F_o : out bit);	 	
end entity;

architecture and_arch of and_gate is
begin
	F_o <= A_i and B_i;
end architecture;