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
    Port ( clk                  : in STD_LOGIC;
           ce                   : in STD_LOGIC;
           rw                   : in STD_LOGIC;--R/=0 W=0
           enable               : in STD_LOGIC;
           address_read_only    : in STD_LOGIC_VECTOR(27 downto 0);
           address              : in STD_LOGIC_VECTOR(27 downto 0);
           input                : in STD_LOGIC_VECTOR(31 downto 0);
           output_read_only     : out STD_LOGIC_VECTOR(31 downto 0);
           output               : out STD_LOGIC_VECTOR(31 downto 0));
end Memory;

architecture Behavioral of Memory is
type memory_array is array (integer range 0 to 255) of std_logic_vector (31 downto 0);

-- 1er programme de test vu en cours
--signal memory_data: memory_array :=(
--                                   x"20000008",--0 NOR(0,FE)
--                                   x"30000007",--1 ADD (1,7E)
--                                   x"00000006",--2 STA (128, 6)
--                                   x"10000004",--3 JCC
--                                   x"10000004",--4 JCC                                
--                                   x"00000000",--5
--                                   x"00000000",--6
--                                   x"0000007E",--7
--                                   x"000000FE",--8
--                                   others => x"00000000");

-- Calcul PGCD vu en cours
--signal memory_data: memory_array :=(
--                                   x"20000011",--0 NOR
--                                   x"20000015",--1 NOR
--                                   x"30000012",--2 ADD
--                                   x"30000014",--3 ADD
--                                   x"10000009",--4 JCC                                
--                                   x"00000014",--5 STA
--                                   x"30000011",--6 ADD
--                                   x"1000000D",--7 JCC
--                                   x"10000000",--8 JCC
--                                   x"20000013",--9 NOR
--                                   x"30000012",--10 ADD
--                                   x"00000015",--11 STA
--                                   x"10000000",--12 JCC
--                                   x"1000000D",--13 JCC
--                                   x"FFFFFFFF",--14
--                                   x"FFFFFFFF",--15
--                                   x"FFFFFFFF",--16
--                                   x"FFFFFFFF",--17 allone
--                                   x"00000001",--18 one
--                                   x"00000000",--19 zero
--                                   x"00000028",--20 data a = 40
--                                   x"00000018",--21 data b = 24
--                                   others => x"00000000");

-- test de certaine instruction
-- signal memory_data: memory_array :=(
--                                    x"2000000C",--0 NOR allone
--                                    x"3000000A",--1 Add 100
--                                    x"8000000B",--2 MOD 100 > 2 carry 1
--                                    x"50000000",--3 CLA
--                                    x"3000000B",--4 Add 2                                
--                                    x"8000000A",--5 2 > 100 carry 0
--                                    x"50000000",--6 CLA
--                                    x"3000000D",--7 Add D
--                                    x"7000000A",--8 a!=D
--                                    x"10000009",--9 NOR
--                                    x"00000064",--10 100
--                                    x"00000002",--11 2
--                                    x"FFFFFFFF",--12 allone
--                                    x"00000006",--13 6
--                                    others => x"00000000");



-- 5 => CLA
-- 2 => NOR
-- 3 => Add
-- 4 => MUL
-- 6 => MOD
-- 0 => STA
-- 1 => JCC
-- 7 => IFNeq
-- 8 => IFSup

--determination si un nb est premier
--signal memory_data: memory_array :=(
--                                   x"50000000",--0  CLA
--                                   x"3000000E",--1  Add (i)
--                                   x"6000000F",--2  MOD (n mod i)
--                                   x"70000010",--3  IFNeq si (n mod i) != 0 carry => 1
--                                   x"1000000D",--4  JCC (fin prog nombre pas premier)
--                                   x"50000000",--5  CLA
--                                   x"3000000E",--6  Add (i)
--                                   x"30000011",--7  Add (1)
--                                   x"0000000E",--8  STA i
--                                   x"4000000E",--9  MUL ixi
--                                   x"8000000F",--10 IFsup si ixi > n => carry 1
--                                   x"10000000",--11 JCC 0 si ixi < n go debut
--                                   x"1000000C",--12 JCC here fin du programme et nombre nombre premier
--                                   x"1000000D",--13 JCC here fin du programme et nombre pas premier
--                                   x"00000002",--14 i (au depart vaut 2)
--                                   x"00000008",--15 n (entrer du syst�me) 7 ou 8 
--                                   x"00000000",--16 zero
--                                   x"00000001",--17 one
--                                   others => x"00000000");
---- SI CARRY = 0 JCC SAUTE prog nb premier avec out of range pour la memoire                                   
--     signal memory_data: memory_array :=(
--                                   x"50000000",--0  CLA
--                                   x"30000023",--1  Add (i)
--                                   x"60000024",--2  MOD (n mod i)
--                                   x"70000025",--3  IFNeq si (n mod i) != 0 carry => 1
--                                   x"1000001B",--4  JCC (fin prog nombre pas premier) 
--                                   x"50000000",--5  CLA
--                                   x"30000023",--6  Add (i)
--                                   x"30000026",--7  Add (1)
--                                   x"00000023",--8  STA i
--                                   x"40000023",--9  MUL ixi
--                                   x"80000024",--10 IFsup si ixi > n => carry 1
--                                   x"10000000",--11 JCC 0 si ixi < n go debut
--                                   x"50000000",--12  CLA
--                                   x"30000024",--13  Accu = nb
--                                   x"90000027",--14 STA nb � l'adresse ADR
--                                   x"50000000",--15 CLA
--                                   x"30000027",--16 Add adr
--                                   x"30000026",--17 add 1 
--                                   x"00000027",--18 Adr = adr + 1
--                                   x"50000000",--19 CLA
--                                   x"30000024",--20 Add nb
--                                   x"30000026",--21 Add 1
--                                   x"00000024",--22 nb = nb + 1
--                                   x"50000000",--23 CLA
--                                   x"30000028",--24 add 2
--                                   x"00000023",--25 i = 2
--                                   x"10000000",--26 JCC debut
--                                   x"50000000",--27 CLA
--                                   x"30000024",--28 Add nb
--                                   x"30000026",--29 add 1
--                                   x"00000024",--30 nb = nb + 1
--                                   x"50000000",--31 CLA
--                                   x"30000028",--32 Add 2
--                                   x"00000023",--33 i = 2
--                                   x"10000000",--34 JCC debut
--                                   --DATA
--                                   x"00000002",--35 i
--                                   x"00000002",--36 nb
--                                   x"00000000",--37 0
--                                   x"00000001",--38 1
--                                   x"00000029",--39 adr (41)
--                                   x"00000002",--40 2
--                                   x"00000000",--41 nb premier
--                                   others => x"00000000");
-- TEST STA_FROM_MEMORY
--signal memory_data: memory_array :=(
--                                   x"50000000",--0  CLA
--                                   x"30000004",--1  Add (i)
--                                   x"90000005",--2  STA from memory 
--                                   x"10000003",--3  JCC 
--                                   x"00000001",--4  1
--                                   x"0000000A",--5  10
--                                   x"00000000",--6
--                                   x"00000000",--7
--                                   x"00000000",--8
--                                   x"00000000",--9
--                                   x"00000000",--10
--                                   others => x"00000000");                                      
                      
                      
-- SI CARRY = 0 JCC SAUTE    fonctionne sans out of range                               
signal memory_data: memory_array :=(
    x"50000000",--0  CLA
    x"30000033",--1  Add (i)
    x"60000034",--2  MOD (n mod i)
    x"70000035",--3  IFNeq si (n mod i) != 0 carry => 1
    x"1000001E",--4  JCC INCR (fin prog nombre pas premier)  
    x"50000000",--5  CLA
    x"30000033",--6  Add (i)
    x"30000036",--7  Add (1)
    x"00000033",--8  STA i
    x"40000033",--9  MUL ixi
    x"80000034",--10 IFsup si ixi > n => carry 1
    x"10000000",--11 JCC 0 si ixi < n go debut
    x"50000000",--12 CLA
    x"30000034",--13 Accu = nb
    x"90000037",--14 STA nb � l'adresse ADR
    x"50000000",--15 CLA
    x"30000037",--16 Add adr
    x"30000036",--17 add 1 
    x"00000037",--18 Adr = adr + 1
    x"80000032",--19 IFsup si adr + 1 > max_adr => carry 1
    x"10000016",--20 JCC CONTINUER
    x"10000015",--21 JCC sur moi m�me
    x"50000000",--22 CLA --CONTINUER
    x"30000034",--23 Add nb
    x"30000036",--24 Add 1
    x"00000034",--25 nb = nb + 1
    x"50000000",--26 CLA
    x"30000038",--27 add 2
    x"00000033",--28 i = 2
    x"10000000",--29 JCC debut
    x"50000000",--30 CLA --INCR
    x"30000034",--31 Add nb
    x"30000036",--32 add 1
    x"00000034",--33 nb = nb + 1
    x"50000000",--34 CLA
    x"30000038",--35 Add 2
    x"00000033",--36 i = 2
    x"10000000",--37 JCC debut
    x"00000000",--38
    x"00000000",--39
    x"00000000",--40
    x"00000000",--41
    x"00000000",--42
    x"00000000",--43
    x"00000000",--44
    x"00000000",--45
    x"00000000",--46
    x"00000000",--47
    x"00000000",--48
    x"00000000",--49
    --DATA
    x"000000FF",--50 max_adr
    x"00000002",--51 i
    x"00000002",--52 nb
    x"00000000",--53 0
    x"00000001",--54 1
    x"00000039",--55 adr 57
    x"00000002",--56 2
    x"00000000",--57 nb premier
    others => x"00000000");   

begin

process(clk)
    begin
        if falling_edge(clk) then
            if ce = '1' then
            output_read_only <= memory_data(to_integer(unsigned(address_read_only)));
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
