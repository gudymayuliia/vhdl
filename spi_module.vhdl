--SPI Master Module:
--Design an SPI Master module that sends data serially 
--using an SPI protocol.
--Inputs: clk, reset, data_in (8-bit data to be transmitted), start (signal to start the transmission).
--Outputs: MOSI (Master Out Slave In), SCK (SPI clock), done (signal indicating the completion of data transmission).
--The SPI Master should send data_in bit-by-bit on MOSI synchronized with SCK.

library IEEE;
use IEEE.std_logic_1164.all;

entity spi_module is
generic (N : integer := 8; 
			clk_div : integer := 100);
port (clk : in std_logic;
		reset : in std_logic;
		data_in : in std_logic_vector (N-1 downto 0);
		start : in std_logic;
		MOSI : out std_logic;
		SCK : out std_logic;
		done_o : out std_logic);
end entity;

architecture rtl of spi_module is 
type statetype is (st_reset, st_tx, st_end);

signal counter_clk_s : integer range 0 to clk_div*2;
signal rising_edge_s : std_logic;
signal falling_edge_s : std_logic;
signal counter_en : std_logic;
signal data_counter : integer range 0 to N;
signal alldata_tick : std_logic;
signal current_state : statetype;
signal next_state : statetype;
signal tx_start_s : std_logic;
signal tx_data_s : std_logic_vector(N-1 downto 0);

begin 
alldata_tick <= '0' when (data_counter > 0) else '1';
--FSM
STATE_MEMORY : process(clk, reset) 
begin
  if(reset='0') then
    current_state <= st_reset;
  elsif(rising_edge(clk)) then
    current_state <= next_state;
  end if;
end process STATE_MEMORY;

NEXT_STATE_LOGIC : process(current_state, alldata_tick, tx_start_s, rising_edge_s, falling_edge_s)
begin
case current_state is
    when st_tx => 
      if(alldata_tick='1') and (rising_edge_s='1') then  
        next_state <= st_end;
      else                                                         
        next_state <= st_tx;
      end if;
    when st_end=> 
      if(falling_edge_s='1') then
        next_state <= st_reset;  
      else
        next_state <= st_end;  
      end if;
    when others =>  -- ST_RESET
      if(tx_start_s='1') then   
        next_state  <= st_tx;
      else                      
        next_state <= st_reset;
      end if;
  end case;
end process NEXT_STATE_LOGIC;

OUTPUT_LOGIC : process(clk, reset)
begin
  if(reset='0') then
    tx_start_s <= '0';
    tx_data_s <= (others=>'0');
    done_o <= '0';
    data_counter <= N-1;
    counter_en <= '0';
    SCK <= '1';
    MOSI <= '1';
  elsif(rising_edge(clk)) then
    tx_start_s <= start;
    case current_state is
      when st_tx =>
        done_o <= '0';
        counter_en <= '1';
        if(rising_edge_s='1') then
          SCK <= '1';
          if(data_counter>0) then
            data_counter <= data_counter-1;
          end if;
        elsif(falling_edge_s='1') then
          SCK <= '0';
          MOSI <= tx_data_s(N-1);
          tx_data_s <= tx_data_s(N-2 downto 0)&'1';
        end if;
      when st_end =>
        done_o <= falling_edge_s;
        data_counter <= N-1;
        counter_en <= '1';
      when others =>  -- ST_RESET
        tx_data_s <= data_in;
        done_o <= '0';
        data_counter <= N-1;
        counter_en <= '0';
        SCK <= '1';
        MOSI <= '1';
    end case;
  end if;
end process OUTPUT_LOGIC;

SERIAL_CLOCK : process(clk, reset)
begin
  if(reset='0') then
    counter_clk_s <= 0;
    rising_edge_s <= '0';
    falling_edge_s <= '0';
	 
  elsif(rising_edge(clk)) then
    if(counter_en='1') then  -- sclk = '1' by default 
      if(counter_clk_s=clk_div-1) then  -- firse edge = fall
        counter_clk_s <= counter_clk_s + 1;
        rising_edge_s <= '0';
        falling_edge_s <= '1';
      elsif(counter_clk_s=(clk_div*2)-1) then
        counter_clk_s <= 0;
        rising_edge_s <= '1';
        falling_edge_s <= '0';
      else
        counter_clk_s <= counter_clk_s + 1;
        rising_edge_s <= '0';
        falling_edge_s <= '0';
      end if;
    else
      counter_clk_s <= 0;
      rising_edge_s <= '0';
      falling_edge_s <= '0';
    end if;
  end if;
end process SERIAL_CLOCK;


end architecture;




