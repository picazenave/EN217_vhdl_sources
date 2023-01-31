-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : 27.1.2023 09:22:19 UTC

library ieee;
use ieee.std_logic_1164.all;

entity tb_Memory is
end tb_Memory;

architecture tb of tb_Memory is

    component Memory
        port (clk     : in std_logic;
              ce      : in std_logic;
              rw      : in std_logic;
              enable  : in std_logic;
              address : in std_logic_vector (7 downto 0);
              input   : in std_logic_vector (7 downto 0);
              output  : out std_logic_vector (7 downto 0));
    end component;

    signal clk     : std_logic;
    signal ce      : std_logic;
    signal rw      : std_logic;
    signal enable  : std_logic;
    signal address : std_logic_vector (7 downto 0);
    signal input   : std_logic_vector (7 downto 0);
    signal output  : std_logic_vector (7 downto 0);

    constant TbPeriod : time := 50 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : Memory
    port map (clk     => clk,
              ce      => ce,
              rw      => rw,
              enable  => enable,
              address => address,
              input   => input,
              output  => output);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        ce <= '0';
        rw <= '0';
        enable <= '0';
        address <= (others => '0');
        input <= (others => '0');

        -- EDIT Add stimuli here
        ce<='1';
        enable<='1';
        rw<='0';
        address<=x"00";
        wait for TbPeriod;
        address<=x"01";
       wait for TbPeriod;
        address<=x"02";
        wait for TbPeriod;
        address<=x"03";
        ---------
        wait for TbPeriod;
        rw<='1';
        address<=x"00";
        input<=x"AB";
        wait for TbPeriod;
        address<=x"01";
        input<=x"AB";
       wait for TbPeriod;
        address<=x"02";
        input<=x"AB";
        ---------
        wait for TbPeriod;
         rw<='0';
        address<=x"00";
        wait for TbPeriod;
        address<=x"01";
        wait for TbPeriod;
        address<=x"02";
        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_Memory of tb_Memory is
    for tb
    end for;
end cfg_tb_Memory;