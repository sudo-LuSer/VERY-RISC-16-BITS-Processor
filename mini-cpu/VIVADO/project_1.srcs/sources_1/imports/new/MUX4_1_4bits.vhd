----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/15/2025 04:18:37 PM
-- Design Name: 
-- Module Name: MUX4_1_4bits - Behavioral
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

entity MUX4_1_4bits is
    Port (E0 : in std_logic_vector(3 downto 0);
           E1 : in std_logic_vector(3 downto 0);
           S : out std_logic_vector(3 downto 0);
           cmd : in std_logic);
end MUX4_1_4bits;

architecture Behavioral of MUX4_1_4bits is

signal S_out : std_logic_vector (3 downto 0); 

begin

process(cmd) 
begin 
    case cmd is 
        when '0' => 
            S_out <= E0; 
        when '1' => 
            S_out <= E1; 
        when others => 
            S_Out <= E0;  
     end case; 
    
end process ;  

S <= S_out; 

end Behavioral;
