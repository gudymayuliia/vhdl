entity mux_2to1 is
port (a : in bit;
		b : in bit;
		sel : in bit;
		y : out bit);
end entity;

architecture mux_2to1_arch of mux_2to1 is
begin
	with (sel) select
		y <= a when '0',
			  b when '1';
			
end architecture;