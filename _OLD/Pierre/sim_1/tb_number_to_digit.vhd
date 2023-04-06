-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : 29.3.2023 07:13:09 UTC

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY tb_number_to_digit IS
END tb_number_to_digit;

ARCHITECTURE tb OF tb_number_to_digit IS

    COMPONENT number_to_digit
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            ce : IN STD_LOGIC;
            number_in : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            digit_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
    END COMPONENT;

    SIGNAL clk : STD_LOGIC;
    SIGNAL reset : STD_LOGIC;
    SIGNAL ce : STD_LOGIC;
    SIGNAL number_in : STD_LOGIC_VECTOR (31 DOWNTO 0);
    SIGNAL digit_out : STD_LOGIC_VECTOR (15 DOWNTO 0);

    CONSTANT TbPeriod : TIME := 10 ns; -- EDIT Put right period here
    SIGNAL TbClock : STD_LOGIC := '0';
    SIGNAL TbSimEnded : STD_LOGIC := '0';

BEGIN

    dut : number_to_digit
    PORT MAP(
        clk => clk,
        reset => reset,
        ce => ce,
        number_in => number_in,
        digit_out => digit_out);

    -- Clock generation
    TbClock <= NOT TbClock AFTER TbPeriod/2 WHEN TbSimEnded /= '1' ELSE
        '0';

    -- EDIT: Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : PROCESS
    BEGIN
        -- EDIT Adapt initialization as needed
        ce <= '0';
        number_in <= (OTHERS => '0');

        -- Reset generation
        -- EDIT: Check that reset is really your reset signal
        reset <= '1';
        ce <= '1';
        WAIT FOR 100 ns;
        reset <= '0';
        WAIT FOR 100 ns;

        number_in <= STD_LOGIC_VECTOR(to_unsigned(1234, number_in'length));
        -- EDIT Add stimuli here
        WAIT FOR 1000 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        WAIT;
    END PROCESS;

END tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

CONFIGURATION cfg_tb_number_to_digit OF tb_number_to_digit IS
    FOR tb
    END FOR;
END cfg_tb_number_to_digit;