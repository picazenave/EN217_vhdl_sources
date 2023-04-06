----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.03.2023 12:57:22
-- Design Name: 
-- Module Name: glyph_counter - Behavioral
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
USE IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY glyph_counter IS
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
END glyph_counter;

ARCHITECTURE Behavioral OF glyph_counter IS
-- ATTRIBUTE mark_debug : STRING;

    SIGNAL output_sig : unsigned (18 DOWNTO 0);
    
    -- ATTRIBUTE mark_debug OF input_counter : SIGNAL IS "true";
    -- ATTRIBUTE mark_debug OF load : SIGNAL IS "true";
    -- ATTRIBUTE mark_debug OF init : SIGNAL IS "true";
BEGIN
    cpt_process : PROCESS (clk, reset, ce) IS
    BEGIN
        IF (reset = '1') THEN
            output_sig <= (OTHERS => '0');
        ELSIF (clk'event AND clk = '1') THEN
            IF (ce = '1') THEN
                IF (load = '1') THEN
                    output_sig <= unsigned(input_counter);
                ELSIF (init = '1') THEN
                    output_sig <= (OTHERS => '0');
                ELSIF (incr_1 = '1') THEN
                    output_sig <= output_sig + 1;
                ELSIF (incr_640 = '1') THEN
                    output_sig <= output_sig + 640 - 4;
                END IF;
            END IF;
        END IF;
    END PROCESS cpt_process;
    output_counter <= STD_LOGIC_VECTOR(output_sig);
END Behavioral;
