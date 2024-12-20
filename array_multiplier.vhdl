library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

entity array_multiplier is
    Port (
        A       : in  std_logic_vector(3 downto 0);
        B       : in  std_logic_vector(3 downto 0);
        Product : out std_logic_vector(7 downto 0)
    );
end entity array_multiplier;

architecture array_multiplier_arch of array_multiplier is
	signal A_8 : unsigned(7 downto 0):= "00000000";
	signal sum : unsigned(7 downto 0);
	begin
		A_8 <= resize(unsigned(A), 8);
		process (A_8, B)
		begin
		 sum <= "00000000";
        for i in 0 to 3 loop
            if (B(i) = '1') then
                sum <= sum + shift_left(A_8, i);
            end if;
        end loop;
    end process;
	 
    Product <= std_logic_vector(sum);
end architecture array_multiplier_arch;



