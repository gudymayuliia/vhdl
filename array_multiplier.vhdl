library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity array_multiplier is
    Port (
        A       : in  std_logic_vector(3 downto 0);
        B       : in  std_logic_vector(3 downto 0);
        Product : out std_logic_vector(7 downto 0)
    );
end entity array_multiplier;

architecture array_multiplier_arch of array_multiplier is

    component full_adder_f is
        port (
            A    : in  std_logic;
            B    : in  std_logic;
            Cin  : in  std_logic;
            Sum  : out std_logic;
            Cout : out std_logic
        );
    end component;

    component half_adder_f is
        port (
            A    : in  std_logic;
            B    : in  std_logic;
            Sum  : out std_logic;
            Cout : out std_logic
        );
    end component;

    type std_logic_vector_array is array (0 to 3) of std_logic_vector(3 downto 0);
    type std_logic_vector_carry is array (0 to 3) of std_logic_vector(4 downto 0);

    signal part_prod : std_logic_vector_array;
    signal sum       : std_logic_vector_array;
    signal carry     : std_logic_vector_carry;

begin

    gen_partial_products : for i in 0 to 3 generate
        gen_partial_products_j: for j in 0 to 3 generate
            part_prod(i)(j) <= A(i) and B(j);
        end generate gen_partial_products_j;
    end generate gen_partial_products;

    gen_adders : for i in 0 to 2 generate
        HA : half_adder_f port map (
            A    => part_prod(i + 1)(0),
            B    => part_prod(i)(1),
            Sum  => sum(i)(0),
            Cout => carry(i)(1)
        );

        gen_fa : for j in 1 to 2 generate
            FA : full_adder_f port map (
                A    => part_prod(i)(j + 1),
                B    => part_prod(i + 1)(j),
                Cin  => carry(i)(j),
                Sum  => sum(i)(j),
                Cout => carry(i)(j + 1)
            );
        end generate gen_fa;
    end generate gen_adders;

end architecture array_multiplier_arch;



