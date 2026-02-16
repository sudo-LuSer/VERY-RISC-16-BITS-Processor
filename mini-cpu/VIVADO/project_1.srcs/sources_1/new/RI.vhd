----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/14/2026 11:35:37 AM
-- Design Name: 
-- Module Name: RI - Behavioral
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

entity RI is
    GENERIC (Nbadr : INTEGER := 6;
    NbBits : INTEGER := 16); 
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           data_in : in STD_LOGIC_VECTOR (NbBits-1 downto 0);
           code_op : out STD_LOGIC_VECTOR (3 downto 0);
           R_n : out STD_LOGIC;
           addr_RI : out STD_LOGIC_VECTOR (Nbadr-1 downto 0);
           LOAD_RI : in STD_LOGIC);
end RI;

architecture Behavioral of RI is

signal adr : unsigned(Nbadr-1 downto 0) := to_unsigned(0, Nbadr);
signal op : unsigned(3 downto 0) := to_unsigned(0 ,4); 
signal R_nn : std_logic; 

begin

process(clk, rst)

begin 

    if(rst = '1')then
        op <= to_unsigned(0 ,4); 
        adr <= to_unsigned(0, Nbadr); 
        R_nn <= '0'; 
    elsif(rising_edge(clk))then 
        if(LOAD_RI = '1')then 
            op <= unsigned(data_in(NbBits-1 downto NbBits-4)); 
            R_nn <= data_in(NbBits-5); 
            adr <= unsigned(data_in(Nbadr-1 downto 0));
        else
            op <= op;
            adr <= adr; 
        end if; 
    end if; 

end process; 

addr_RI <= std_logic_vector(adr);
code_op <= std_logic_vector(op);
R_n <= R_nn; 

end Behavioral;