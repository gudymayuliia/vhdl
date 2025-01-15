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
  clk : in std_logic;  
  reset : in std_logic; 
  SCK : in std_logic; 
  MOSI : in std_logic;
  data_out : out std_logic_vector(N-1 downto 0);
  done_o : out std_logic  
);
end spi_slave;

architecture rtl of spi_slave is

signal sck_shift_s : std_logic_vector(2 downto 0) := "000"; 
signal sck_rising_edge : std_logic := '0';
signal sck_falling_edge : std_logic := '0';
signal rx_data_s : std_logic_vector(N-1 downto 0) := (others => '0');
signal bit_count : integer range 0 to N := 0;
signal done_s : std_logic := '0'; 

begin
data_out <= rx_data_s;
done_o <= done_s;

SCK_SHIFTING : process(clk)
begin
    if rising_edge(clk) then
        if reset = '1' then
            sck_shift_s <= (others => '0');
        else
            sck_shift_s <= sck_shift_s(1 downto 0) & SCK;
        end if;
    end if;
end process;

SCK_EDGE_DETECT : process(clk)
begin
    if rising_edge(clk) then
        if reset = '1' then
            sck_rising_edge <= '0';
            sck_falling_edge <= '0';
        else
            if sck_shift_s(2 downto 1) = "01" then
                sck_rising_edge <= '1';
					 sck_falling_edge <= '0';
            elsif sck_shift_s(2 downto 1) = "10" then
                sck_falling_edge <= '1';
					 sck_rising_edge <= '0';	 
            else
                sck_falling_edge <= '0';
					 sck_rising_edge <= '0';
            end if;
        end if;
    end if;
end process SCK_EDGE_DETECT;



SLAVE_INPUT : process(clk)
begin
    if rising_edge(clk) then
        if reset = '1' then
            rx_data_s <= (others => '0');
            bit_count <= 0;
            done_s <= '0';
        elsif sck_rising_edge = '1' then  
            rx_data_s <= rx_data_s(N-2 downto 0) & MOSI;  
            if bit_count < N-1 then
                bit_count <= bit_count + 1;
                done_s <= '0';
            else
                bit_count <= 0;
                done_s <= '1';
            end if;
        end if;
    end if;
end process;

end rtl;
