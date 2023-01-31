-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : 27.1.2023 07:49:50 UTC

library ieee;
use ieee.std_logic_1164.all;

entity tb_Reg_1b is
end tb_Reg_1b;

architecture tb of tb_Reg_1b is

    component Reg_1b
        port (reset  : in std_logic;
              clk    : in std_logic;
              ce     : in std_logic;
              load   : in std_logic;
              init   : in std_logic;
              input  : in std_logic;
              output : out std_logic);
    end component;

    signal reset  : std_logic;
    signal clk    : std_logic;
    signal ce     : std_logic;
    signal load   : std_logic;
    signal init   : std_logic;
    signal input  : std_logic;
    signal output : std_logic;

    constant TbPeriod : time := 10 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : Reg_1b
    port map (reset  => reset,
              clk    => clk,
              ce     => ce,
              load   => load,
              init   => init,
              input  => input,
              output => output);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        ce <= '0';
        load <= '0';
        init <= '0';
        input <= '0';

        -- Reset generation
        -- EDIT: Check that reset is really your reset signal
        reset <= '1';
        wait for 100 ns;
        reset <= '0';
        wait for 100 ns;

        -- EDIT Add stimuli here
        ce<='1';
        
        wait for 5 * TbPeriod;
        load<='1';
        input<='1';
        wait for 5 * TbPeriod;
        input<='0';
         wait for 5 * TbPeriod;
        input<='1';
        wait for 5 * TbPeriod;
        input<='0';
        -- load 0
        wait for 5 * TbPeriod;
        
        input<='1';
        wait for 5 * TbPeriod;
        load<='0';
        input<='0';
         wait for 5 * TbPeriod;
        input<='1';
        wait for 5 * TbPeriod;
        input<='0';
        
        init<='1';
        wait for 5 * TbPeriod;
        init<='0';
        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_Reg_1b of tb_Reg_1b is
    for tb
    end for;
end cfg_tb_Reg_1b;