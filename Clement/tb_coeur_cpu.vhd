-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : 14.3.2023 14:39:52 UTC

library ieee;
use ieee.std_logic_1164.all;

entity tb_COEUR_CPU is
end tb_COEUR_CPU;

architecture tb of tb_COEUR_CPU is

    component COEUR_CPU
        port (CLK : in std_logic;
              RST : in std_logic;
              CE  : in std_logic);
    end component;

    signal CLK : std_logic;
    signal RST : std_logic;
    signal CE  : std_logic;

    constant TbPeriod : time := 10 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : COEUR_CPU
    port map (CLK => CLK,
              RST => RST,
              CE  => CE);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that CLK is really your main clock signal
    CLK <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        CE <= '1';

        -- Reset generation
        -- EDIT: Check that RST is really your reset signal
        RST <= '1';
        wait for 100 ns;
        RST <= '0';
        wait for 100 ns;

        -- EDIT Add stimuli here
        wait for 10000 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_COEUR_CPU of tb_COEUR_CPU is
    for tb
    end for;
end cfg_tb_COEUR_CPU;