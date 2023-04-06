-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : 9.3.2023 08:25:42 UTC

library ieee;
use ieee.std_logic_1164.all;

entity tb_prime2graphic is
end tb_prime2graphic;

architecture tb of tb_prime2graphic is

    component prime2graphic
        port (clk      : in std_logic;
              ce       : in std_logic;
              enable   : in std_logic;
              data_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
              counter : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
              data_out : out std_logic_vector (44 downto 0);
              ready    : out std_logic);
    end component;

    signal clk      : std_logic;
    signal ce       : std_logic;
    signal enable   : std_logic;
    signal data_out : std_logic_vector (44 downto 0);
    signal ready    : std_logic;

    constant TbPeriod : time := 10 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : prime2graphic
    port map (clk      => clk,
              ce       => ce,
              enable   => enable,
              data_in => x"0000000F",
              counter => x"00000001",
              data_out => data_out,
              ready    => ready);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        ce <= '1';
        enable <= '1';

        -- Reset generation
        -- EDIT Add stimuli here
        wait for 100 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_prime2graphic of tb_prime2graphic is
    for tb
    end for;
end cfg_tb_prime2graphic;