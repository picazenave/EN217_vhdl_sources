library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;


entity acces_carte is
    port (
	 	  clk       : in std_logic;
	 	  reset     : in std_logic;
	 	  ce1s      : out std_logic;
	 	  ce25M     : out std_logic);

end acces_carte;

architecture acces_carte_a of acces_carte is
signal ce195k : std_logic;
		
component gen_ce is
    Port ( H    : in std_logic;
           raz  : in std_logic;
		   S_8  : out std_logic;
		   S_1  : out std_logic;
           S_25 : out std_logic);
end component;
		
		
begin  
i_gen_ce              : gen_ce  port map(clk,reset,ce195k,ce25M,ce1s);
end acces_carte_a;

--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity gen_ce is
    Port ( H    : in std_logic;
           raz  : in std_logic;
		   S_8  : out std_logic;
		   S_1  : out std_logic;
           S_25 : out std_logic);
end gen_ce;

architecture Behavioral of gen_ce is
signal compt : std_logic_vector (25 downto 0);
begin
   P1: process (H,raz)
		begin
		  if raz = '1' then 
		        compt <= (others => '0');
		  elsif H = '1' and H'event then
                compt <= compt + 1;
		  end if;
   end process;

   P2: process (compt)
		begin
		  if (compt(7 downto 0)="11111111") then S_8 <='1';
		                                    else S_8 <='0';
        end if;
	     if (compt(0)='1')                 then S_1 <='1';
		                                    else S_1 <='0';
        end if;
		  if (compt=((2**25)-1)) then S_25 <='1';
		                         else S_25 <='0';
        end if;
       end process;



end Behavioral;
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------




