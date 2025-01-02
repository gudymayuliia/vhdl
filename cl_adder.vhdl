--16-Bit Carry Lookahead Adder:
--Create a 16-bit carry-lookahead adder for faster addition.
--Inputs: A (16 bits), B (16 bits), Cin (carry-in).
--Outputs: Sum (16 bits), Cout (carry-out).
--Implement carry lookahead logic to reduce propagation delay.

library IEEE;
use IEEE.std_logic_1164.all;

entity cl_adder is
  generic (
    N : integer := 16);
  port (
    A_i  : in std_logic_vector(N-1 downto 0);
    B_i  : in std_logic_vector(N-1 downto 0);
    Sum   : out std_logic_vector(N-1 downto 0);
	 Cout : out std_logic);
end entity;


architecture rtl of cl_adder is
 
  component mod_fa is
    port (a_i : in std_logic;
		b_i : in std_logic;
		cin : in std_logic;
		sum_o : out std_logic;
		cout_o : out std_logic);
	end component;
 
  signal g_s: std_logic_vector(N-1 downto 0); -- Generate
  signal p_s : std_logic_vector(N-1 downto 0); -- Propagate
  signal C_s : std_logic_vector(N downto 0);   -- Carry
 
  signal sum_s  : std_logic_vector(N-1 downto 0);
 
begin
 
  -- Create the Full Adders
  GEN_FULL_ADDERS : for ii in 0 to N-1 generate
    FULL_ADDER_INST : mod_fa
      port map (
        a_i  => A_i(ii),
        b_i  => B_i(ii),
        cin => C_s(ii),        
        sum_o   => sum_s(ii),
		  cout_o => open);
  end generate GEN_FULL_ADDERS;
 
  -- Create the Generate (G) Terms:  Gi=Ai*Bi
  -- Create the Propagate Terms: Pi=Ai+Bi
  -- Create the Carry Terms:  
  GEN_CLA : for jj in 0 to N-1 generate
    g_s(jj)   <= A_i(jj) and B_i(jj);
    p_s(jj)   <= A_i(jj) or B_i(jj);
    C_s(jj+1) <= g_s(jj) or (p_s(jj) and C_s(jj));
  end generate GEN_CLA;
     
  C_s(0) <= '0'; -- no carry input
 
  Sum <= sum_s;  -- VHDL Concatenation
  Cout <= C_s(N);
end rtl;





