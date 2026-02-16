----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/26/2026 09:38:56 AM
-- Design Name: 
-- Module Name: Registre_File - Behavioral
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

entity Registre_File is
    GENERIC (NbBits : INTEGER := 16); 
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           load_accu : in STD_LOGIC;
           sel_accu : in STD_LOGIC;
           ACCU : out STD_LOGIC_VECTOR (NbBits-1 downto 0);
           ACCU_reg : in STD_LOGIC_VECTOR (NbBits-1 downto 0));
end Registre_File;

architecture Behavioral of Registre_File is

signal Acc_reg_1 : std_logic_vector(NbBits -1 downto 0);
signal Acc_reg_2 : std_logic_vector(NbBits -1 downto 0);

begin

process(clk, rst)
begin 

    if(rst = '1')then 
        Acc_reg_1 <= std_logic_vector(to_unsigned(0,16)); 
        Acc_reg_2 <= std_logic_vector(to_unsigned(0,16)); 
    elsif(rising_edge(clk))then 
        if(load_accu = '1')then
            case sel_accu is 
                when '0' =>
                    Acc_reg_1 <= ACCU_reg;
                    --Acc_reg_2 <= Acc_reg_2; 
                when others =>
                    Acc_reg_2 <= ACCU_reg;
                    --Acc_reg_1 <= Acc_reg_1; 
            end case;           
        end if; 
    end if; 

end process; 

process (sel_accu, Acc_reg_1, Acc_reg_2)
begin 
    case sel_accu is 
        when '0' =>
            ACCU <= Acc_reg_1;
        when others =>
            ACCU <= Acc_reg_2; 
    end case;  
end process; 

end Behavioral;
