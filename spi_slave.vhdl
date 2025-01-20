--SPI Slave Module:
--Create an SPI Slave module to receive data from an SPI Master.
--Inputs: clk, reset, MOSI, SCK, start.
--Outputs: data_out (8-bit received data), done (indicates completion of reception).
--The SPI Slave should sample MOSI on the rising edge of SCK and assemble the data into 


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity spi_slave is
generic(
  N : integer := 8;      
  CPOL : std_logic := '0'  
);
port (
  start : in std_logic;
  clk : in std_logic;  
  reset : in std_logic; 
  SCK_S : in std_logic; 
  MOSI : in std_logic;
  data_out : out std_logic_vector(N-1 downto 0);
  done_o : out std_logic  
);
end spi_slave;

architecture rtl of spi_slave is

signal count_en : std_logic :='0';
signal sync_reg1 : std_logic := '0';
signal sync_reg2 : std_logic := '0';
signal sck_shift_s : std_logic_vector(N-1 downto 0) := (others => '0');
signal clk_shift_s : std_logic_vector(N-1 downto 0) := (others => '0');
signal rx_data_s : std_logic_vector(N-1 downto 0) := (others => '0');
signal bit_count : integer range 0 to N := 0;
signal done_s : std_logic := '0'; 

begin
data_out <= clk_shift_s;
done_o <= sync_reg2;


SLAVE_INPUT : process(SCK_S , reset)
begin
	if (reset = '1') then
		rx_data_s <= (others => '0');
	elsif(rising_edge(SCK_S)) then 
	   
	   if(start = '1') then
	       count_en <= '1';
	   end if;
	   
	   if(count_en = '1' or start = '1') then
            rx_data_s <= rx_data_s(N-2 downto 0)&MOSI;
            bit_count <= bit_count + 1;
            
            if (bit_count = N-1) then
                done_s <= '1';
                bit_count <= 0;
                count_en <= '0';
            else
                done_s <= '0';
            end if;
       end if;
       
  end if;
end process SLAVE_INPUT;

CDC : process(clk)
begin
        if(rising_edge(clk)) then
            sync_reg1 <= done_s;
            sync_reg2 <= sync_reg1;
            
            if(sync_reg2 = '1') then
                clk_shift_s <= rx_data_s;
            end if;
        end if;
end process CDC;

end rtl;
