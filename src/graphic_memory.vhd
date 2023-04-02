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
        rw : IN STD_LOGIC;--R/=0 W=1
        address_read_only : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
        address : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
        input : IN STD_LOGIC_VECTOR(47 DOWNTO 0);
        data_out_read_only : OUT STD_LOGIC_VECTOR(47 DOWNTO 0);
        data_out : OUT STD_LOGIC_VECTOR(47 DOWNTO 0));
END graphic_memory;

ARCHITECTURE Behavioral OF graphic_memory IS
    TYPE memory_array IS ARRAY (INTEGER RANGE 0 TO 4095) OF STD_LOGIC_VECTOR (47 DOWNTO 0);
    SIGNAL memory_data : memory_array := (--x/y
    x"100000402810", --4 10/10
    x"0c0c83232190", --ligne 100/100 200/200
    x"1000001320c8", --1 200/200
    x"1000002028c8", --2 200/10
    x"0c0c8320c8c8", --ligne 100/100 200/100
    x"10000033200a", --3 10/200 --case 5
    x"100001541024", --debut lorem ipsum
    x"10000184102a",
    x"100001b41030",
    x"100000e41036",
    x"10000164103c",
    x"100002441042",
    x"100001241048",
    x"10000194104e",
    x"100001c41054",
    x"100001e4105a",
    x"100001641060",
    x"100002441066",
    x"100000d4106c",
    x"100001841072",
    x"100001541078",
    x"10000184107e",
    x"100001b41084",
    x"10000244108a",
    x"100001c41090",
    x"100001241096",
    x"100001d4109c",
    x"1000024410a2",
    x"100000a410a8",
    x"1000016410ae",
    x"100000e410b4",
    x"100001d410ba",
    x"1000024410c0",
    x"100000c410c6",
    x"1000018410cc",
    x"1000017410d2",
    x"100001c410d8",
    x"100000e410de",
    x"100000c410e4",
    x"100001d410ea",
    x"100000e410f0",
    x"100001d410f6",
    x"100001e410fc",
    x"100001b41102",
    x"100002441108",
    x"100000a4110e",
    x"100000d41114",
    x"10000124111a",
    x"100001941120",
    x"100001241126",
    x"100001c4112c",
    x"100000c41132",
    x"100001241138",
    x"10000174113e",
    x"100001041144",
    x"10000244114a",
    x"100000e41150",
    x"100001541156",
    x"10000124115c",
    x"100001d41162", --fin lorem ipsum
    x"100000e46024", --debut phrase EN217
    x"10000174602a",
    x"100000246030",
    x"100000146036",
    x"10000074603c",
    x"100002446042",
    x"100001946048",
    x"100001b4604e",
    x"100001846054",
    x"100000c4605a",
    x"100000e46060",
    x"100001c46066",
    x"100001c4606c",
    x"100000e46072",
    x"100001e46078",
    x"100001b4607e",
    x"100002446084",
    x"10000034608a",
    x"100000246090",
    x"100000b46096",
    x"10000124609c",
    x"100001d460a2",
    x"1000024460a8",
    x"1000019460ae",
    x"1000018460b4",
    x"100001e460ba",
    x"100001b460c0",
    x"1000024460c6",
    x"100000c460cc",
    x"100000a460d2",
    x"1000015460d8",
    x"100000c460de",
    x"100001e460e4",
    x"1000015460ea",
    x"1000024460f0",
    x"100000d460f6",
    x"100000e460fc",
    x"100002446102",
    x"100001746108",
    x"10000184610e",
    x"100001646114",
    x"100000b4611a",
    x"100001b46120",
    x"100000e46126",
    x"100001c4612c",
    x"100002446132",
    x"100001946138",
    x"100001b4613e",
    x"100000e46144",
    x"10000164614a",
    x"100001246150",
    x"100000e46156",
    x"100001b4615c",
    x"100001c46162", --fin phrase EN217  
    x"0c4c0364c034", --debut bongo cat
    x"0c4c4374c433",
    x"0c4c8384c832",
    x"0c4cc394cc32",
    x"0c4d03b4d031",
    x"0c4d43e4d42f",
    x"0c4d8404d82c",
    x"0c4dc414dc29",
    x"0c4e0434e027",
    x"0c4e4454e424",
    x"0c4e8464e821",
    x"0c4ec474ec1f",
    x"0c4f0484f01e",
    x"0c4f4124f410",
    x"0c4f44a4f41c",
    x"0c4f8144f810",
    x"0c4f84b4f81a",
    x"0c4fc174fc10",
    x"0c4fc4c4fc18",
    x"0c5004d50010",
    x"0c5043d50411",
    x"0c5044e50440",
    x"0c5083d50811",
    x"0c5084f50841",
    x"0c50c3d50c11",
    x"0c50c5050c41",
    x"0c5103951012",
    x"0c5103d5103b",
    x"0c5105151041",
    x"0c5143551412",
    x"0c514525143b",
    x"0c5183451812",
    x"0c518535183a",
    x"0c51c3151c12",
    x"0c51c5351c36",
    x"0c5202752012",
    x"0c5203252028",
    x"0c5205452035",
    x"0c5242652413",
    x"0c524545242a",
    x"0c5282652813",
    x"0c528555282a",
    x"0c52c2652c13",
    x"0c52c4452c2a",
    x"0c52c5552c46",
    x"0c5304053012",
    x"0c5305553049",
    x"0c5343b53411",
    x"0c534545344c",
    x"0c5383753811",
    x"0c53c3353c10",
    x"0c5402654010",
    x"0c5402f54027",
    x"0c544265440f",
    x"0c5442b54428",
    x"0c548275480f",
    x"0c54c2754c0e",
    x"0c550285500e",
    x"0c554285540e",
    x"0c558155580d",
    x"0c558285581b",
    x"0c55c1255c0d",
    x"0c55c2855c1e",
    x"0c5602656021",

    --fin bongo cat

    OTHERS => x"000000000000");
BEGIN

    PROCESS (clk)
    BEGIN
        IF falling_edge(clk) THEN
            IF ce = '1' THEN
                data_out_read_only <= memory_data(to_integer(unsigned(address_read_only)));
                IF rw = '1' THEN -- write
                    memory_data(to_integer(unsigned(address))) <= input;
                ELSE --read
                    data_out <= memory_data(to_integer(unsigned(address)));
                END IF;
            END IF;
        END IF;
    END PROCESS;

END Behavioral;