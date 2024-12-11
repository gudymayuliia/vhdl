entity mux_4to1 is
port (a_i : in bit;
		b_i : in bit;
		c_i : in bit;
		d_i : in bit;
		sel_i : in bit_vector(1 downto 0);
		y_o : out bit);
end entity;

architecture mux_4to1_arch of mux_4to1 is
begin
	with (sel_i) select
		y_o <= a_i when "00",
			  b_i when "01",
			  c_i when "10",
			  d_i when "11";
end architecture;