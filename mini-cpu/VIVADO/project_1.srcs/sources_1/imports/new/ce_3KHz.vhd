----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/27/2025 12:26:58 PM
-- Design Name: 
-- Module Name: ce_3KHz - Behavioral
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

entity ce_3KHz is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           tick : out STD_LOGIC);
end ce_3KHz;


architecture Behavioral of ce_3KHz is

signal r_next : unsigned(15 downto 0) ; 
signal r_prst : unsigned(15 downto 0) := to_unsigned( 0  ,16) ; 

begin

process(clk , rst)

begin

    if(rst = '1')then 
    
        r_prst <= to_unsigned(0 , 16) ; 
        
    elsif(clk = '1' and clk'event)then 
    
        r_prst <= r_next; 
        
    end if; 
    
    
end process ;

process(r_prst)

begin 

    if(r_prst = to_unsigned(33332 , 16))then 
        tick <= '1'; 
        r_next <= to_unsigned(0 , 16);  
    else 
        tick <= '0'; 
        r_next <= r_prst + to_unsigned(1 , 16); 
    end if; 

end process; 

end Behavioral;
