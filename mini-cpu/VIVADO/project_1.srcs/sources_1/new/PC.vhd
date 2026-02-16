----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/14/2026 11:19:47 AM
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PC is
    GENERIC (Nbadr : INTEGER := 6); 
    Port (clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           clear_PC : in STD_LOGIC;
           enable_PC : in STD_LOGIC;
           load_PC : in STD_LOGIC;
           address_PC : out STD_LOGIC_VECTOR (Nbadr-1 downto 0);
           L_AddPC : in STD_LOGIC_VECTOR (Nbadr-1 downto 0));
end PC;

architecture Behavioral of PC is

signal PC : unsigned(Nbadr-1 downto 0) := to_unsigned(0 ,Nbadr); 

begin

process(clk , rst) 
begin 
    if(rst = '1')then 
        PC <= to_unsigned(0, Nbadr); 
    elsif(rising_edge(clk))then 
        if(clear_PC = '1')then 
            PC <= to_unsigned(0, Nbadr); 
        elsif(load_PC = '1')then 
            PC <= unsigned(L_AddPC); 
        elsif(enable_PC = '1')then 
            PC <= PC + 1; 
        else 
            PC <= PC; 
        end if; 
    end if; 
end process; 

address_PC <= std_logic_vector(PC);

end Behavioral;