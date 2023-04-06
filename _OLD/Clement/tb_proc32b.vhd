library ieee;
use ieee.std_logic_1164.all;

entity tb_proc is
end tb_proc;

architecture tb of tb_proc is

    component proc
        port (clk100M : in std_logic;
              reset   : in std_logic);
    end component;

    signal clk100M : std_logic;
    signal reset   : std_logic;

    constant TbPeriod : time := 10 ns;
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : proc
    port map (clk100M => clk100M,
              reset   => reset);
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    clk100M <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed

        -- Reset generation
        -- EDIT: Check that reset is really your reset signal
        reset <= '0';
        wait for 100 ns;
        reset <= '1';
        wait for 100 ns;

        -- EDIT Add stimuli here
        wait for 1000000 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;
