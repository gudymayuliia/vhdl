--SPI Slave Module:
--Create an SPI Slave module to receive data from an SPI Master.
--Inputs: clk, reset, MOSI, SCK, start.
--Outputs: data_out (8-bit received data), done (indicates completion of reception).
--The SPI Slave should sample MOSI on the rising edge of SCK and assemble the data into 


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity spi_slave is
generic(
  N : integer := 8;      
  CPOL : std_logic := '1' );  
 port (
   reset : in std_logic;
   start : in std_logic;
   data_out : out  std_logic_vector(N-1 downto 0); 
   SCK : in  std_logic;
   done_o : out std_logic;
   MOSI : in  std_logic);
end spi_slave;

architecture rtl of spi_slave is

signal rx_data_s : std_logic_vector(N-1 downto 0) := (others => '0');  -- received data
signal bit_count : integer range 0 to N := 0;
begin
data_out  <= rx_data_s;
SLAVE_INPUT : process(SCK)
begin
	if (reset = '1') then
		rx_data_s <= (others => '0');
		bit_count <= 0;
		done_o <= '0';
	elsif(SCK'event and SCK=CPOL) then 
		rx_data_s <= rx_data_s(N-2 downto 0)&MOSI;
		if bit_count < N-1 then
            bit_count <= bit_count + 1;
            done_o <= '0'; -- Transmission not complete
        else
            bit_count <= 0; -- Reset counter after receiving full data
            done_o <= '1'; -- Indicate completion
        end if;
  end if;
end process SLAVE_INPUT;

end rtl;