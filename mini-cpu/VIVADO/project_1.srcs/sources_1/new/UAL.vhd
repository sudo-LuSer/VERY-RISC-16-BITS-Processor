----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/14/2026 09:32:13 AM
-- Design Name: 
-- Module Name: UAL - Behavioral
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

entity UAL is
    GENERIC (NbBits : INTEGER := 16); 
    Port ( A : in STD_LOGIC_VECTOR (NbBits-1 downto 0);
           B : in STD_LOGIC_VECTOR (NbBits-1 downto 0);
           carry : out STD_LOGIC;
           equal : out std_logic; 
           neg : out std_logic; 
           result : out STD_LOGIC_VECTOR (NbBits-1 downto 0);
           sel_UAL : in STD_LOGIC_VECTOR(3 downto 0));
end UAL;

architecture Behavioral of UAL is

signal res : signed (NbBits downto 0);
signal result_temp : STD_LOGIC_VECTOR (NbBits-1 downto 0);

begin

process(sel_UAL, A, B, res ) 
    
begin 
    case sel_UAL is 
        when "0000" => 
            result_temp <= A NOR B; 
            carry <= '0';
            res <= to_signed(0 , NbBits+1);
        when "0100" => 
            res <= signed("0" & A) + signed("0" & B); 
            result_temp <= std_logic_vector(res(NbBits-1 downto 0)); 
            carry <= std_logic(res(NbBits)); 
        when "0001" =>
            res <=  signed("0" & B) - signed("0" & A); 
            result_temp <= std_logic_vector(res(NbBits-1 downto 0)); 
            carry <= std_logic(res(NbBits));  
        when "0010" => 
            res <= signed("0" & B) + 1; 
            result_temp <= std_logic_vector(res(NbBits-1 downto 0)); 
            carry <= std_logic(res(NbBits));
        when "1111" =>
            res <= to_signed(0 , NbBits+1); 
            result_temp <= std_logic_vector(to_signed(0, NbBits));
            carry <= '0';
        when others =>
            result_temp <= A NOR B; 
            carry <= '0';
            res <= to_signed(0 , NbBits+1);
    end case; 
    
end process;

process(A, B, result_temp)
begin 
    if(A = B)then 
        equal <= '1'; 
    else
        equal <= '0'; 
    end if;
end process;  

process(A, B, result_temp)
begin 
    if(B < A)then 
        neg <= '1'; 
    else
        neg <= '0'; 
    end if; 
end process;  

result <= result_temp;

end Behavioral;