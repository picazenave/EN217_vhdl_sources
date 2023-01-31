library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Mux is
    Port ( input_0 : in STD_LOGIC_VECTOR(5 DOWNTO 0);
           input_1 : in STD_LOGIC_VECTOR(5 DOWNTO 0);
           input_select : in STD_LOGIC;
           output : out STD_LOGIC_VECTOR(5 DOWNTO 0));
end Mux;

architecture Behavioral of Mux is

begin

Process(input_select,input_0,input_1)
begin

    if(input_select = '0') then 
        output<=input_0;
    else
        output<=input_1;
    end if;
    
End Process;

end Behavioral;