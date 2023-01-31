----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.01.2023 09:11:04
-- Design Name: 
-- Module Name: FSM - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FSM is
    Port ( clk                  : in STD_LOGIC;
           reset                : in STD_LOGIC;
           ce                   : in STD_LOGIC;
           code_op              : in STD_LOGIC_VECTOR(1 downto 0);
           carry                : in STD_LOGIC;
           sel_mux              : out STD_LOGIC;
           load_instruction     : out STD_LOGIC;
           r_w                  : out STD_LOGIC;
           enable_memory        : out STD_LOGIC;
           init_carry           : out STD_LOGIC;
           load_carry           : out STD_LOGIC;
           load_reg_data        : out STD_LOGIC;
           load_accu            : out STD_LOGIC;
           sel_ual              : out STD_LOGIC;
           load_pc              : out STD_LOGIC;
           incr_pc              : out STD_LOGIC;
           init_pc              : out STD_LOGIC);
end FSM;

architecture Behavioral of FSM is
type etat is(init, fetch_instruction, decode, fetch_operand, exec_nor_add, exec_sta, exec_jcc);
signal pr_state, nx_state : Etat;

begin

maj_etat : process (clk, reset) is
begin
    if (reset = '1') then
        pr_state <= init;
    elsif(clk'event and clk = '1') then
        if (ce = '1') then
            pr_state <= nx_state;
        end if;
    end if;
end process maj_etat;

calc_new_state : process (code_op, pr_state) is
begin
    case pr_state is
        when init => nx_state <= fetch_instruction;
        when fetch_instruction => nx_state <= decode;
        when decode => if(code_op(1) = '0') then
                            nx_state <= fetch_operand;
                       elsif(code_op = "10") then
                            nx_state <= exec_sta;
                       else
                            nx_state <= exec_jcc;
                       end if;
        when fetch_operand => nx_state <= exec_nor_add;
        when exec_nor_add => nx_state <= fetch_instruction;
        when exec_sta => nx_state <= fetch_instruction;
        when exec_jcc => nx_state <= fetch_instruction;
                            
    end case;

end process calc_new_state;

calc_output : process(pr_state)
begin
    case pr_state is
        when init =>
                     sel_mux            <= '0';
                     load_instruction   <= '0';
                     r_w                <= '0';
                     enable_memory      <= '0';
                     init_carry         <= '1';
                     load_carry         <= '0';
                     load_reg_data      <= '0';
                     load_accu          <= '0';
                     sel_ual            <= '0';
                     load_pc            <= '0';
                     incr_pc            <= '0';
                     init_pc            <= '1';
        when fetch_instruction =>
                     sel_mux            <= '0';
                     load_instruction   <= '1';
                     r_w                <= '0';
                     enable_memory      <= '1';
                     init_carry         <= '0';
                     load_carry         <= '0';
                     load_reg_data      <= '0';
                     load_accu          <= '0';
                     sel_ual            <= '0';
                     load_pc            <= '0';
                     incr_pc            <= '1';
                     init_pc            <= '0';
        when decode =>
                     sel_mux            <= '1';
                     load_instruction   <= '0';
                     r_w                <= '0';
                     enable_memory      <= '0';
                     init_carry         <= '0';
                     load_carry         <= '0';
                     load_reg_data      <= '0';
                     load_accu          <= '0';
                     sel_ual            <= '0';
                     load_pc            <= '0';
                     incr_pc            <= '0';
                     init_pc            <= '0';
        when fetch_operand =>
                     sel_mux            <= '1';
                     load_instruction   <= '0';
                     r_w                <= '0';
                     enable_memory      <= '1';
                     init_carry         <= '0';
                     load_carry         <= '0';
                     load_reg_data      <= '1';
                     load_accu          <= '0';
                     sel_ual            <= '0';
                     load_pc            <= '0';
                     incr_pc            <= '0';
                     init_pc            <= '0';
        when exec_nor_add =>
                     sel_mux            <= '1';
                     load_instruction   <= '0';
                     r_w                <= '0';
                     enable_memory      <= '0';
                     init_carry         <= '0';
                     load_carry         <= code_op(0);
                     load_reg_data      <= '0';
                     load_accu          <= '1';
                     sel_ual            <= code_op(0);
                     load_pc            <= '0';
                     incr_pc            <= '0';
                     init_pc            <= '0';
        when exec_sta =>
                     sel_mux            <= '1';
                     load_instruction   <= '0';
                     r_w                <= '1';
                     enable_memory      <= '1';
                     init_carry         <= '0';
                     load_carry         <= '0';
                     load_reg_data      <= '0';
                     load_accu          <= '0';
                     sel_ual            <= '0';
                     load_pc            <= '0';
                     incr_pc            <= '0';
                     init_pc            <= '0';
        when exec_jcc =>
                     sel_mux            <= '1';
                     load_instruction   <= '0';
                     r_w                <= '0';
                     enable_memory      <= '0';
                     init_carry         <= carry;
                     load_carry         <= '0';
                     load_reg_data      <= '0';
                     load_accu          <= '0';
                     sel_ual            <= '0';
                     load_pc            <= not(carry);
                     incr_pc            <= '0';
                     init_pc            <= '0';
     end case;
end process calc_output;

end Behavioral;
