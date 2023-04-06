----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.03.2023 10:57:27
-- Design Name: 
-- Module Name: gpu_data_decoder - Behavioral
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

ENTITY gpu_data_decoder IS
    PORT (
        clk : IN STD_LOGIC;
        ce : IN STD_LOGIC;
        enable : IN STD_LOGIC;
        data_in : IN STD_LOGIC_VECTOR(47 DOWNTO 0);
        glyph_number : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        mode : OUT STD_LOGIC;--1=character 0=drawing
        x : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
        y : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
        x2 : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
        y2 : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
        ready : OUT STD_LOGIC);
END gpu_data_decoder;

ARCHITECTURE Behavioral OF gpu_data_decoder IS
    SIGNAL text_mode : STD_LOGIC := '0';
BEGIN

    mode <= data_in(44);
    text_mode <= data_in(44);

    PROCESS (text_mode,data_in,glyph_number) IS
    BEGIN
        CASE(text_mode) IS
            WHEN '1' =>
            y <= data_in(19 DOWNTO 10);
            x <= STD_LOGIC_VECTOR(to_unsigned(to_integer(unsigned(data_in(9 DOWNTO 0))) + 6 * to_integer(unsigned(glyph_number)), x'length));
            CASE(glyph_number) IS
                WHEN "00" =>
                x2<="0000" & data_in(25 DOWNTO 20);
                WHEN "01" =>
                x2<="0000" & data_in(31 DOWNTO 26);
                WHEN "10" =>
                x2<="0000" & data_in(37 DOWNTO 32);
                WHEN "11" =>
                x2<="0000" & data_in(43 DOWNTO 38);
                WHEN OTHERS =>
                x2<="0000000000";
            END CASE;
            y2 <= "0000000000";

            WHEN '0' =>
            x <= data_in(9 DOWNTO 0);
            y <= data_in(19 DOWNTO 10);
            x2 <= data_in(29 DOWNTO 20);
            y2 <= data_in(39 DOWNTO 30);

            WHEN OTHERS =>
            y <= "0000000000";
            x <= "0000000000";
            y2 <= "0000000000";
            x2 <= "0000000000";
        END CASE;
    END PROCESS;
END Behavioral;