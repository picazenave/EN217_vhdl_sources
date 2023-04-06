-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : 20.3.2023 13:36:17 UTC

library ieee;
use ieee.std_logic_1164.all;

entity tb_top_level_fsm_gpu is
end tb_top_level_fsm_gpu;

architecture tb of tb_top_level_fsm_gpu is

    component top_level_fsm_gpu
        port (reset    : in std_logic;
              clk100M  : in std_logic;
              AN       : out std_logic_vector (7 downto 0);
              Sevenseg : out std_logic_vector (7 downto 0);
              LED      : out std_logic_vector (7 downto 0);
              VGA_HS   : out std_logic;
              VGA_VS   : out std_logic;
              VGA_R    : out std_logic_vector (3 downto 0);
              VGA_G    : out std_logic_vector (3 downto 0);
              VGA_B    : out std_logic_vector (3 downto 0));
    end component;

    signal reset    : std_logic;
    signal clk100M  : std_logic;
    signal AN       : std_logic_vector (7 downto 0);
    signal Sevenseg : std_logic_vector (7 downto 0);
    signal LED      : std_logic_vector (7 downto 0);
    signal VGA_HS   : std_logic;
    signal VGA_VS   : std_logic;
    signal VGA_R    : std_logic_vector (3 downto 0);
    signal VGA_G    : std_logic_vector (3 downto 0);
    signal VGA_B    : std_logic_vector (3 downto 0);

    constant TbPeriod : time := 10 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : top_level_fsm_gpu
    port map (reset    => reset,
              clk100M  => clk100M,
              AN       => AN,
              Sevenseg => Sevenseg,
              LED      => LED,
              VGA_HS   => VGA_HS,
              VGA_VS   => VGA_VS,
              VGA_R    => VGA_R,
              VGA_G    => VGA_G,
              VGA_B    => VGA_B);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that clk100M is really your main clock signal
    clk100M <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed

        -- Reset generation
        -- EDIT: Check that reset is really your reset signal
        reset <= '0';
        wait for 10 ns;
        reset <= '1';
        wait for 10 ns;

        -- EDIT Add stimuli here
        wait for 10000 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        --TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_top_level_fsm_gpu of tb_top_level_fsm_gpu is
    for tb
    end for;
end cfg_tb_top_level_fsm_gpu;