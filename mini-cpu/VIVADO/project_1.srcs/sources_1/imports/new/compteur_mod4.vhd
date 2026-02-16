----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/15/2025 04:05:55 PM
-- Design Name: 
-- Module Name: compteur_mod4 - Behavioral
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

entity compteur_mod4 is
    Port ( ce : in STD_LOGIC;
           rst : in STD_LOGIC;
           S : out STD_LOGIC);
end compteur_mod4;

architecture Behavioral of compteur_mod4 is

signal cmp : std_logic;

begin

process(ce , rst)
begin

    if(rst ='1')then 
        cmp <= '0';
    elsif(ce='1' and ce'event)then 
        case cmp is 
            when '1' => 
                cmp <= '0'; 
            when '0' => 
                cmp <= '1'; 
        end case;   
    end if;  

end process; 

S <= cmp; 


end Behavioral;
