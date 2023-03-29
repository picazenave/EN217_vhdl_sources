-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : 27.1.2023 11:08:49 UTC

library ieee;
use ieee.std_logic_1164.all;

entity tb_toplevel_CPU is
end tb_toplevel_CPU;

architecture tb of tb_toplevel_CPU is

    component CPU
        port (clk   : in std_logic;
              reset : in std_logic;
              ce    : in std_logic);
    end component;

    signal clk   : std_logic;
    signal reset : std_logic;
    signal ce    : std_logic;

    constant TbPeriod : time := 10 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : CPU
    port map (clk   => clk,
              reset => reset,
              ce    => ce);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        ce <= '0';

        -- Reset generation
        -- EDIT: Check that reset is really your reset signal
        reset <= '1';
        wait for 100 ns;
        reset <= '0';
        wait for 100 ns;

        -- EDIT Add stimuli here
        ce<='1';
        
        wait for 100 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_toplevel_CPU of tb_toplevel_CPU is
    for tb
    end for;
end cfg_tb_toplevel_CPU;