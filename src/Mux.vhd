library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Mux is
    Port ( input_0 : in STD_LOGIC_VECTOR(27 DOWNTO 0);
           input_1 : in STD_LOGIC_VECTOR(27 DOWNTO 0);
           input_2 : in STD_LOGIC_VECTOR(27 DOWNTO 0);
           input_select : in STD_LOGIC_VECTOR (1 downto 0);
           output : out STD_LOGIC_VECTOR(27 DOWNTO 0));
end Mux;

architecture Behavioral of Mux is

begin

Process(input_select,input_0,input_1)
begin

    if(input_select = "00") then 
        output <= input_0;
    elsif (input_select = "01") then
        output <= input_1;
    elsif (input_select = "11") then
        output <= input_2;
    end if;
    
End Process;

end Behavioral;