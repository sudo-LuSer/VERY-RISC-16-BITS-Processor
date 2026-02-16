----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/15/2025 05:37:58 PM
-- Design Name: 
-- Module Name: Transcodeur4_7 - Behavioral
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

entity Transcodeur4_7 is
    Port ( E : in std_logic_vector(3 downto 0);
           S : out std_logic_vector(6 downto 0));
end Transcodeur4_7;

architecture Behavioral of Transcodeur4_7 is

signal S_out : std_logic_vector(6 downto 0);

begin

process(E)
begin 

    case E is 
        when "0000"=>
        
            S_out <="1000000";
        
        when "0001"=>
        
            S_out <="1111001";
        
        when "0010"=>
        
            S_out <="0100100";
        
        when "0011"=>
        
            S_out <="0110000";
        
        when "0100"=>
        
            S_out <="0011001";
        
        when "0101"=>
        
            S_out <="0010010";
        
        when "0110"=>
        
            S_out <="0000010";
        
        when "0111"=>
        
            S_out <="1111000";
        
        when "1000"=>
        
            S_out <="0000000";
        
        when "1001"=>
        
            S_out <="0010000";
        
        when others=>
        
            S_out <="1111111";
            
        end case; 
        
end process; 

S <= S_out;


end Behavioral;
