-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : 2.4.2023 16:08:56 UTC

library ieee;
use ieee.std_logic_1164.all;
USE IEEE.NUMERIC_STD.ALL;

entity tb_prime_converter is
end tb_prime_converter;

architecture tb of tb_prime_converter is

    component prime_converter
        port (clk             : in std_logic;
              reset           : in std_logic;
              ce              : in std_logic;
              prime_data_in   : in std_logic_vector (27 downto 0);
              address_graphic : out std_logic_vector (11 downto 0);
              address_prime   : out std_logic_vector (7 downto 0);
              r_w_graphic     : out std_logic;
              data_graphic    : out std_logic_vector (47 downto 0));
    end component;

    signal clk             : std_logic;
    signal reset           : std_logic;
    signal ce              : std_logic;
    signal prime_data_in   : std_logic_vector (27 downto 0);
    signal address_graphic : std_logic_vector (11 downto 0);
    signal address_prime   : std_logic_vector (7 downto 0);
    signal r_w_graphic     : std_logic;
    signal data_graphic    : std_logic_vector (47 downto 0);

    constant TbPeriod : time := 10 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : prime_converter
    port map (clk             => clk,
              reset           => reset,
              ce              => ce,
              prime_data_in   => STD_LOGIC_VECTOR(to_unsigned(1234,28)),
              address_graphic => address_graphic,
              address_prime   => address_prime,
              r_w_graphic     => r_w_graphic,
              data_graphic    => data_graphic);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        ce <= '0';
        prime_data_in <= (others => '0');

        -- Reset generation
        -- EDIT: Check that reset is really your reset signal
        reset <= '1';
        ce<='1';
        wait for 20 ns;
        reset <= '0';
        wait for 20 ns;

        -- EDIT Add stimuli here
        wait for 1000 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_prime_converter of tb_prime_converter is
    for tb
    end for;
end cfg_tb_prime_converter;