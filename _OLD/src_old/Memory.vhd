----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.01.2023 08:20:16
-- Design Name: 
-- Module Name: Reg_1b - Behavioral
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


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Memory is
    Port ( clk : in STD_LOGIC;
           ce : in STD_LOGIC;
           rw : in STD_LOGIC;--R/=0 W=0
           enable : in STD_LOGIC;
           address : in STD_LOGIC_VECTOR(5 downto 0);
           input : in STD_LOGIC_VECTOR(7 downto 0);
           output : out STD_LOGIC_VECTOR(7 downto 0));
end Memory;

architecture Behavioral of Memory is
type memory_array is array (integer range 0 to 63) of std_logic_vector (7 downto 0);
signal memory_data: memory_array :=(
                                   x"08",--0
                                   x"47",--1
                                   x"86",--2
                                   x"C4",--3
                                   x"C4",--4                                 
                                   x"00",--5
                                   x"00",--6
                                   x"7E",--7
                                   x"FE",--8
                                   others => "00000000");

--signal memory_data: memory_array :=(
--                                   x"11",--0
--                                   x"15",--1
--                                   x"52",--2
--                                   x"54",--3
--                                   x"C9",--4                                 
--                                   x"94",--5
--                                   x"51",--6
--                                   x"CD",--7
--                                   x"C0",--8
--                                   x"13",--9
--                                   x"52",--10
--                                   x"95",--11
--                                   x"C0",--12
--                                   x"CD",--13
--                                   x"FF",--14
--                                   x"FF",--15
--                                   x"FF",--16
--                                   x"FF",--17
--                                   x"01",--18
--                                   x"00",--19
--                                   x"28",--20
--                                   x"18",--21
--                                   others => "00000000");

begin

process(clk)
    begin
        if falling_edge(clk) then
            if ce = '1' then
                if enable = '1' then
                    if rw = '1' then -- write
                        memory_data(to_integer(unsigned(address)))<=input;
                    else --read
                       output<=memory_data(to_integer(unsigned(address)));
                    end if;
                end if;
            end if;
        end if;
    end process;
end Behavioral;
