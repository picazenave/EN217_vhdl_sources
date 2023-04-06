-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : 8.2.2023 14:19:12 UTC

library ieee;
use ieee.std_logic_1164.all;

entity tb_UAL is
end tb_UAL;

architecture tb of tb_UAL is

    component UAL
        port (sel             : in std_logic_vector (2 downto 0);
              operand_accu    : in std_logic_vector (31 downto 0);
              operand_memoire : in std_logic_vector (31 downto 0);
              carry           : out std_logic;
              output          : out std_logic_vector (31 downto 0));
    end component;

    signal sel             : std_logic_vector (2 downto 0);
    signal operand_accu    : std_logic_vector (31 downto 0);
    signal operand_memoire : std_logic_vector (31 downto 0);
    signal carry           : std_logic;
    signal output          : std_logic_vector (31 downto 0);

    constant TbPeriod : time := 10 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : UAL
    port map (sel             => sel,
              operand_accu    => operand_accu,
              operand_memoire => operand_memoire,
              carry           => carry,
              output          => output);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    --  EDIT: Replace YOURCLOCKSIGNAL below by the name of your clock as I haven't guessed it
    --  YOURCLOCKSIGNAL <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        sel <= (others => '0');
        operand_accu <= (others => '0');
        operand_memoire <= (others => '0');


        -- NOR
        sel <= "000";
        operand_accu <= x"0000000A";
        operand_memoire <= x"00000000";
        wait for 100 ns;
        -- ADD
        sel <= "001";
        operand_accu <= x"0000000A";
        operand_memoire <= x"0000000A";
        wait for 100 ns;
        -- MUL
        sel <= "010";
        operand_accu <= x"0000000A";
        operand_memoire <= x"0000000A";
        wait for 100 ns;
        -- MOD
        sel <= "011";
        operand_accu <= x"00000002";
        operand_memoire <= x"00000003";
        wait for 100 ns;
        
        --IFNeq
        sel <= "100";
        operand_accu <= x"0000000A";
        operand_memoire <= x"0000000A";
        wait for 100 ns;
        sel <= "100";
        operand_accu <= x"0000000B";
        operand_memoire <= x"0000000A";
         wait for 100 ns;
        
        --IFSup
        
        sel <= "101";
        operand_accu <= x"0000000A";
        operand_memoire <= x"0000000B";
        wait for 101 ns;
        operand_accu <= x"0000000B";
        operand_memoire <= x"0000000A";



        wait for 100 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_UAL of tb_UAL is
    for tb
    end for;
end cfg_tb_UAL;