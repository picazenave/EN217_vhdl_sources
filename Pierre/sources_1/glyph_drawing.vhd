----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.02.2023 16:27:29
-- Design Name: 
-- Module Name: glyph_drawing - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY glyph_drawing IS
    PORT (
        clk : IN STD_LOGIC;
        ce : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        enable : IN STD_LOGIC;
        x : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
        y : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
        glyph_data_in : IN STD_LOGIC_VECTOR(39 DOWNTO 0);
        address_out : OUT STD_LOGIC_VECTOR(18 DOWNTO 0);
        data_out : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
        ready : OUT STD_LOGIC);
END glyph_drawing;

ARCHITECTURE Behavioral OF glyph_drawing IS
    -- ATTRIBUTE mark_debug : STRING;
    COMPONENT PC
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            ce : IN STD_LOGIC;
            init_pc : IN STD_LOGIC;
            incr_pc : IN STD_LOGIC;
            load_pc : IN STD_LOGIC;
            input_pc : IN STD_LOGIC_VECTOR (5 DOWNTO 0);
            output_pc : OUT STD_LOGIC_VECTOR (5 DOWNTO 0));
    END COMPONENT;
    COMPONENT glyph_counter IS
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            ce : IN STD_LOGIC;
            init : IN STD_LOGIC;
            incr_1 : IN STD_LOGIC;
            incr_640 : IN STD_LOGIC;
            load : IN STD_LOGIC;
            input_counter : IN STD_LOGIC_VECTOR(18 DOWNTO 0);
            output_counter : OUT STD_LOGIC_VECTOR(18 DOWNTO 0));
    END COMPONENT;
    COMPONENT Reg_19b IS
        PORT (
            reset : IN STD_LOGIC;
            clk : IN STD_LOGIC;
            ce : IN STD_LOGIC;
            load : IN STD_LOGIC;
            init : IN STD_LOGIC;
            input : IN STD_LOGIC_VECTOR(18 DOWNTO 0);
            output : OUT STD_LOGIC_VECTOR(18 DOWNTO 0));
    END COMPONENT;
    --=======================================================

    TYPE etat IS(init,
    load_data,
    draw,
    incr_position,
    incr_line,
    end_state);

    SIGNAL pr_state, nx_state : Etat;

    SIGNAL init_counter_address : STD_LOGIC := '0';
    SIGNAL load_counter_address : STD_LOGIC := '0';

    SIGNAL output_counter_position : STD_LOGIC_VECTOR(5 DOWNTO 0) := (OTHERS => '0');
    SIGNAL init_counter_position : STD_LOGIC := '0';
    SIGNAL incr_counter_position : STD_LOGIC := '0';

    SIGNAL output_counter_line : STD_LOGIC_VECTOR(5 DOWNTO 0) := (OTHERS => '0');
    SIGNAL init_counter_line : STD_LOGIC := '0';
    SIGNAL incr_counter_line : STD_LOGIC := '0';
    SIGNAL address_counter_input : STD_LOGIC_VECTOR(18 DOWNTO 0) := (OTHERS => '0');

    -- ATTRIBUTE mark_debug OF pr_state : SIGNAL IS "true";
    -- ATTRIBUTE mark_debug OF incr_counter_line : SIGNAL IS "true";
    -- ATTRIBUTE mark_debug OF incr_counter_position : SIGNAL IS "true";
    -- ATTRIBUTE mark_debug OF output_counter_position : SIGNAL IS "true";
    -- ATTRIBUTE mark_debug OF output_counter_line : SIGNAL IS "true";
    -- ATTRIBUTE mark_debug OF address_out : SIGNAL IS "true";
    -- ATTRIBUTE mark_debug OF data_out : SIGNAL IS "true";
    -- ATTRIBUTE mark_debug OF enable : SIGNAL IS "true";
    -- ATTRIBUTE mark_debug OF ready : SIGNAL IS "true";
BEGIN

    counter_position : PC
    PORT MAP(
        clk => clk,
        reset => reset,
        ce => ce,
        init_pc => init_counter_position,
        incr_pc => incr_counter_position,
        load_pc => '0',
        input_pc => "000000",
        output_pc => output_counter_position);

    counter_line : PC
    PORT MAP(
        clk => clk,
        reset => reset,
        ce => ce,
        init_pc => init_counter_line,
        incr_pc => incr_counter_line,
        load_pc => '0',
        input_pc => "000000",
        output_pc => output_counter_line);

    counter_address : glyph_counter
    PORT MAP(
        clk => clk,
        reset => reset,
        ce => ce,
        init => init_counter_address,
        incr_1 => incr_counter_position,
        incr_640 => incr_counter_line,
        load => load_counter_address,
        input_counter => address_counter_input,
        output_counter => address_out);

    -- reg_ Reg_19b
    --     PORT MAP(
    --         reset : IN STD_LOGIC;
    --         clk : IN STD_LOGIC;
    --         ce : IN STD_LOGIC;
    --         load : IN STD_LOGIC;
    --         init : IN STD_LOGIC;
    --         input : IN STD_LOGIC_VECTOR(18 DOWNTO 0);
    --         output : OUT STD_LOGIC_VECTOR(18 DOWNTO 0));
    -- END COMPONENT;
    --===================================

    maj_etat : PROCESS (clk, reset) IS
    BEGIN
        IF (reset = '1') THEN
            pr_state <= init;
        ELSIF (clk'event AND clk = '1') THEN
            IF (ce = '1') THEN
                pr_state <= nx_state;
            END IF;
        END IF;
    END PROCESS maj_etat;
    ----------------------------------------------------------------------------------

    --===============================================================================

    ----------------------------------------------------------------------------------
    calc_new_state : PROCESS (pr_state, enable, output_counter_position, output_counter_line) IS
    BEGIN
        CASE pr_state IS
            WHEN init =>
                IF (enable = '1') THEN
                    nx_state <= load_data;
                ELSE
                    nx_state <= init;
                END IF;
                ----------------------------------------------------------------------------------
            WHEN load_data => nx_state <= draw;
                ----------------------------------------------------------------------------------
            WHEN draw =>
                IF (unsigned(output_counter_position) < 4 AND unsigned(output_counter_line) < 8) THEN
                    nx_state <= incr_position;
                ELSIF (unsigned(output_counter_line) < 8) THEN
                    nx_state <= incr_line;
                ELSE
                    nx_state <= end_state;
                END IF;

            WHEN incr_position => nx_state <= draw;
            WHEN incr_line => nx_state <= draw;

            WHEN end_state =>
                IF (enable = '1') THEN
                    nx_state <= end_state;
                ELSE
                    nx_state <= init;
                END IF;
                ----------------------------------------------------------------------------------
                --WHEN exec_IFSup => nx_state <= fetch_instruction;
        END CASE;

    END PROCESS calc_new_state;
    ----------------------------------------------------------------------------------

    --===============================================================================

    ----------------------------------------------------------------------------------
    calc_output : PROCESS (pr_state)
    BEGIN
        CASE pr_state IS
            WHEN init =>
                data_out(0) <= '0';
                ready <= '0';
                init_counter_address <= '1';
                init_counter_line <= '1';
                init_counter_position <= '1';
                load_counter_address <= '0';
                incr_counter_line <= '0';
                incr_counter_position <= '0';

            WHEN load_data =>
                ready <= '0';
                incr_counter_line <= '0';
                incr_counter_position <= '0';
                data_out(0) <= '0';
                ready <= '0';
                init_counter_address <= '0';
                init_counter_line <= '0';
                init_counter_position <= '0';
                load_counter_address <= '1';

            WHEN draw =>
                ready <= '0';
                data_out(0) <= glyph_data_in(to_integer(39-(unsigned(output_counter_position) + unsigned(output_counter_line) * 5)));
                incr_counter_line <= '0';
                incr_counter_position <= '0';
                load_counter_address <= '0';
                init_counter_position <= '0';
                init_counter_address <= '0';
                init_counter_line <= '0';

            WHEN incr_position =>
                ready <= '0';
                data_out(0) <= glyph_data_in(to_integer(39-(unsigned(output_counter_position) + unsigned(output_counter_line) * 5)));
                incr_counter_line <= '0';
                incr_counter_position <= '1';
                load_counter_address <= '0';
                init_counter_position <= '0';
                init_counter_address <= '0';
                init_counter_line <= '0';

            WHEN incr_line =>
                ready <= '0';
                data_out(0) <= glyph_data_in(to_integer(39-(unsigned(output_counter_position) + unsigned(output_counter_line) * 5)));
                incr_counter_line <= '1';
                incr_counter_position <= '0';
                load_counter_address <= '0';
                init_counter_position <= '1';
                init_counter_address <= '0';
                init_counter_line <= '0';

            WHEN end_state =>
                ready <= '1';
                data_out(0) <= '0';
                -- input_counter_address : STD_LOGIC_VECTOR(18 DOWNTO 0);
                incr_counter_line <= '0';
                incr_counter_position <= '0';
                load_counter_address <= '0';
                init_counter_position <= '0';
                init_counter_address <= '0';
                init_counter_line <= '0';
                
        END CASE;
    END PROCESS calc_output;
    address_counter_input <= STD_LOGIC_VECTOR(resize(unsigned(x) + unsigned(y(9 DOWNTO 0)) * 640,address_counter_input'length));
END Behavioral;