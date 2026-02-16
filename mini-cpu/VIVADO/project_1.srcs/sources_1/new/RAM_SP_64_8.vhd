----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/14/2026 08:58:22 AM
-- Design Name: 
-- Module Name: RAM_SP_64_8 - Behavioral
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

entity RAM_SP_64_8 is
GENERIC (
    NbBits : INTEGER := 16;
    Nbadr : INTEGER := 6);
PORT (
    add : IN STD_LOGIC_VECTOR ((Nbadr - 1) DOWNTO 0);
    data_in : IN STD_LOGIC_VECTOR ((NbBits - 1) DOWNTO 0);
    r_w : IN STD_LOGIC;
    clk : IN STD_LOGIC;
    data_out : OUT STD_LOGIC_VECTOR ((NbBits - 1) DOWNTO 0)
);
end RAM_SP_64_8;

architecture Behavioral of RAM_SP_64_8 is

type grid_ram_type is array (0 to 2**Nbadr -1) of std_logic_vector(NbBits-1 downto 0); 
signal grid_ram : grid_ram_type := (others => std_logic_vector(to_unsigned(0,NbBits)));

begin

    PROCESS (clk) 
    BEGIN
        IF rising_edge(clk) then
            if r_w = '1' then
                grid_ram(to_integer(unsigned(add))) <= data_in; 
            else 
                data_out <= grid_ram(to_integer(unsigned(add))); 
            end if;
        END IF;
    END PROCESS;

end Behavioral;
