----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.01.2023 08:30:50
-- Design Name: 
-- Module Name: PC - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PC is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           ce : in STD_LOGIC;
           init_pc : in STD_LOGIC;
           incr_pc : in STD_LOGIC;
           load_pc : in STD_LOGIC;
           input : in STD_LOGIC_VECTOR (27 downto 0);
           output : out STD_LOGIC_VECTOR (27 downto 0));
end PC;

architecture Behavioral of PC is
signal output_sig : unsigned (27 downto 0);
begin 
cpt_process : process(clk, reset, ce) is
    begin
        if(reset = '1') then
            output_sig <= "0000000000000000000000000000";
        elsif(clk'event and clk = '1') then
            if (ce = '1') then
                if (load_pc = '1') then
                    output_sig <= unsigned(input);
                elsif (init_pc = '1') then
                    output_sig <= "0000000000000000000000000000";
                elsif (incr_pc = '1') then
                    output_sig <= output_sig +1;
                end if;
            end if;
        end if;
    end process cpt_process;
output <= std_logic_vector(output_sig);

end Behavioral;
