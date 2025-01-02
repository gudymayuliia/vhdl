--Sequence Detector with FSM:
--Design an FSM-based sequence detector that detects a specific sequence of bits, 
--e.g., "1011":
--Input: clk, reset, in (single-bit input).
--Output: detected (1 if the sequence is detected, 0 otherwise).
--The FSM should reset when reset is active. 
--It should output detected = 1 when the sequence "1011" is detected on in.


library IEEE;
use IEEE.std_logic_1164.all;

entity sequence_detector is 
port (input : in std_logic;
		clk : in std_logic;
		reset : in std_logic;
		detected : out std_logic);
end entity;

architecture synth of sequence_detector is
type statetype is (S0, S1, S2, S3);
signal current_state, next_state : statetype;
begin
	STATE_MEMORY : process(clk, reset)
	begin
	if(reset = '1') then
		current_state <= S0;
	elsif (rising_edge(clk)) then
		current_state <= next_state;
	end if;
	end process;
	NEXT_STATE_LOGIC : process(current_state, input)
	begin
		case(current_state) is
			when S0 => if(input = '1') then
								next_state <= S1;
							else
								next_state <= S0;
							end if;
			when S1 => if(input = '0') then
								next_state <= S2;
							else
								next_state <= S0;
							end if;
			when S2 => if(input = '1') then
								next_state <= S3;
							else
								next_state <= S0;
							end if;
			when S3 => if(input = '1') then
								next_state <= S1;
							else
								next_state <= S0;
							end if;
			when others => next_state <= S0;
		end case;
	end process;
	OUTPUT_LOGIC : process(current_state, input)
	begin
		case(current_state) is
			when S0 => if(input = '1') then
								detected <= '0';
							else
								detected <= '0';
							end if;
			when S1 => if(input = '0') then
								detected <= '0';
							else
								detected <= '0';
							end if;
			when S2 => if(input = '1') then
								detected <= '0';
							else
								detected <= '0';
							end if;
			when S3 => if(input = '1') then
								detected <= '1';
							else
								detected <= '0';
							end if;
			when others => detected <= '0';
		end case;
		
	end process;
	

end architecture;

















