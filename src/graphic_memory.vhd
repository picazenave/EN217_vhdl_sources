----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.02.2023 15:29:34
-- Design Name: 
-- Module Name: graphic_memory - Behavioral
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

ENTITY graphic_memory IS
    PORT (
        clk : IN STD_LOGIC;
        ce : IN STD_LOGIC;
        address : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
        data_out : OUT STD_LOGIC_VECTOR(47 DOWNTO 0));
END graphic_memory;

ARCHITECTURE Behavioral OF graphic_memory IS
    TYPE memory_array IS ARRAY (INTEGER RANGE 0 TO 4095) OF STD_LOGIC_VECTOR (47 DOWNTO 0);
    SIGNAL memory_data : memory_array := (--x/y
    x"0c0c83232064",
    x"100000d398e6", --D 230/230
    x"0c0c83232190", --ligne 100/100 400/400
    x"1000001320c8", --1 200/200
    x"1000002028c8", --2 200/10
    x"0c0c8320c8c8", --ligne 100/100 200/100
    x"100000d320ce", --D 206/200
    x"10000033200a", --3 10/200
    x"100000c3e8c8",
    x"100000c3e8c8", --debut phrase
    x"100000b3e8ce",
    x"100000e3e8d4",
    x"100001b3e8da",
    x"100001d3e8e0",
    x"10000113e8e6",
    x"100000e3e8ec",--15
    x"10000153e8f2",
    x"10000183e8f8",
    x"100001d3e8fe",
    x"10000243e904",
    x"100001d3e90a",--20
    x"10000243e910",
    x"100000b3e916",
    x"10000183e91c", --fin phrase
    -- debut bongo cat
   x"0c0102c0102a",
x"0c0142d01429",
x"0c0182e01828",
x"0c01c2f01c28",
x"0c0203102027",
x"0c0243402425",
x"0c0283602822",
x"0c02c3702c1f",
x"0c030390301d",
x"0c0343b0341a",
x"0c0383c03817",
x"0c03c3d03c15",
x"0c0403e04014",
x"0c0440804406",
x"0c0444004412",
x"0c0480a04806",
x"0c0484104810",
x"0c04c0d04c06",
x"0c04c4204c0e",
x"0c0504305006",
x"0c0543305407",
x"0c0544405436",
x"0c0583305807",
x"0c0584505837",
x"0c05c3305c07",
x"0c05c4605c37",
x"0c0602f06008",
x"0c0603306031",
x"0c0604706037",
x"0c0642b06408",
x"0c0644806431",
x"0c0682a06808",
x"0c0684906830",
x"0c06c2706c08",
x"0c06c4906c2c",
x"0c0701d07008",
x"0c070280701e",
x"0c0704a0702b",
x"0c0741c07409",
x"0c0744a07420",
x"0c0781c07809",
x"0c0784b07820",
x"0c07c1c07c09",
x"0c07c3a07c20",
x"0c07c4b07c3c",
x"0c0803608008",
x"0c0804b0803f",
x"0c0843108407",
x"0c0844a08442",
x"0c0882d08807",
x"0c08c2908c06",
x"0c0901c09006",
x"0c090250901d",
x"0c0941c09405",
x"0c094210941e",
x"0c0981d09805",
x"0c09c1d09c04",
x"0c0a01e0a004",
x"0c0a41e0a404",
x"0c0a80b0a803",
x"0c0a81e0a811",
x"0c0ac080ac03",
x"0c0ac1e0ac14",
x"0c0b01c0b017",
--fin bongo cat

    OTHERS => x"000000000000");
BEGIN

    PROCESS (clk)
    BEGIN
        IF falling_edge(clk) THEN
            IF ce = '1' THEN
                data_out <= memory_data(to_integer(unsigned(address)));
            END IF;
        END IF;
    END PROCESS;

END Behavioral;