----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.02.2023 17:13:33
-- Design Name: 
-- Module Name: primitive_drawing - Behavioral
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

ENTITY primitive_drawing IS
    PORT(
        clk         : IN  STD_LOGIC;
        ce          : IN  STD_LOGIC;
        enable      : IN  STD_LOGIC;
        x           : IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
        y           : IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
        x2          : IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
        y2          : IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
        address_out : OUT STD_LOGIC_VECTOR(18 DOWNTO 0);
        data_out    : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
        ready       : OUT STD_LOGIC);
END primitive_drawing;

ARCHITECTURE Behavioral OF primitive_drawing IS
    SIGNAL internal_ready : STD_LOGIC := '0';
    SIGNAL first_loop     : STD_LOGIC := '1';

    SIGNAL x0       : signed(10 DOWNTO 0) := (OTHERS => '0');
    SIGNAL x1       : signed(10 DOWNTO 0) := (OTHERS => '0');
    SIGNAL y0       : signed(10 DOWNTO 0) := (OTHERS => '0');
    SIGNAL y1       : signed(10 DOWNTO 0) := (OTHERS => '0');
    SIGNAL dx       : signed(10 DOWNTO 0) := (OTHERS => '0');
    SIGNAL sx       : signed(10 DOWNTO 0) := (OTHERS => '0');
    SIGNAL dy       : signed(10 DOWNTO 0) := (OTHERS => '0');
    SIGNAL sy       : signed(10 DOWNTO 0) := (OTHERS => '0');
    SIGNAL my_error : signed(10 DOWNTO 0) := (OTHERS => '0');
    SIGNAL e2       : signed(21 DOWNTO 0) := (OTHERS => '0');
BEGIN

    PROCESS(clk)
    BEGIN
        IF rising_edge(clk) THEN
            IF (enable = '0') THEN
                internal_ready <= '0';
                x0             <= "0" & (signed(x));
                x1             <= "0" & (signed(x2));
                y0             <= "0" & (signed(y));
                y1             <= "0" & (signed(y2));
                first_loop     <= '1';

            ELSIF ce = '1' THEN

                IF internal_ready = '0' THEN
                    IF first_loop = '1' THEN
                        first_loop <= '0';
                        dx         <= ABS (x1 - x0);
                        IF (x0 < x1) THEN
                            sx <= to_signed(1,sx'length);
                        ELSE
                            sx <= to_signed(-1,sx'length);
                        END IF;
                        --sx <= x0 < x1 ? 1 : -1;
                        dy         <= -ABS (y1 - y0);
                        IF (y0 < y1) THEN
                            sy <= to_signed(1,sx'length);
                        ELSE
                            sy <= to_signed(-1,sx'length);
                        END IF;
                        --sy <= y0 < y1 ? 1 : -1;
                        my_error   <= dx + dy;
                    ELSE
                        -- plot(x0, y0)
                        IF ((x0 = x1) AND (y0 = y1)) THEN
                            internal_ready <= '1';
                            first_loop     <= '1';
                        END IF;
                        e2 <= 2 * my_error;
                        IF (e2 >= dy) THEN
                            IF (x0 = x1) THEN
                                internal_ready <= '1';
                                first_loop     <= '1';
                            END IF;
                            my_error <= my_error + dy;
                            x0       <= x0 + sx;
                        END IF;
                        IF (e2 <= dx) THEN
                            IF (y0 = y1) THEN
                                internal_ready <= '1';
                                first_loop     <= '1';
                            END IF;
                            my_error <= my_error + dx;
                            y0       <= y0 + sy;
                        END IF;
                    END IF;
                END IF;
            END IF;
        END IF;
    END PROCESS;

    address_out <= STD_LOGIC_VECTOR(resize(x0 + y0 * 640,19));
    data_out(0) <= NOT internal_ready AND NOT first_loop;
    ready       <= internal_ready;

END Behavioral;
