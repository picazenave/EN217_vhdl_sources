-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : 27.1.2023 08:21:38 UTC

library ieee;
use ieee.std_logic_1164.all;

entity tb_UAL is
end tb_UAL;

architecture tb of tb_UAL is

    component UAL
        port (sel       : in std_logic;
              operand_0 : in std_logic_vector (7 downto 0);
              operand_1 : in std_logic_vector (7 downto 0);
              carry     : out std_logic;
              output    : out std_logic_vector (7 downto 0));
    end component;

    signal sel       : std_logic;
    signal operand_0 : std_logic_vector (7 downto 0);
    signal operand_1 : std_logic_vector (7 downto 0);
    signal carry     : std_logic;
    signal output    : std_logic_vector (7 downto 0);

begin

    dut : UAL
    port map (sel       => sel,
              operand_0 => operand_0,
              operand_1 => operand_1,
              carry     => carry,
              output    => output);

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        sel <= '0';
        operand_0 <= (others => '0');
        operand_1 <= (others => '0');
        wait for 100ns;
        -- EDIT Add stimuli here
        sel<='0';
        operand_0<="00001111";
        operand_1<="11111111";
        wait for 100ns;
        sel<='0';
        operand_0<="00001111";
        operand_1<="00000000";
        wait for 100ns;
        sel<='1';
        operand_0<="00000001";
        operand_1<="01111111";
        wait for 100ns;
        sel<='1';
        operand_0<="00000001";
        operand_1<="11111111";
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_UAL of tb_UAL is
    for tb
    end for;
end cfg_tb_UAL;