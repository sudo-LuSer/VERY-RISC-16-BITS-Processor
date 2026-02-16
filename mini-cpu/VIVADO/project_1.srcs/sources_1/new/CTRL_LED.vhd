----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/28/2026 08:55:19 AM
-- Design Name: 
-- Module Name: CTRL_LED - Behavioral
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

entity CTRL_LED is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           led_in : in STD_LOGIC_VECTOR (15 downto 0);
           led_out : out STD_LOGIC_VECTOR (15 downto 0);
           ce_led : in STD_LOGIC);
end CTRL_LED;

architecture Behavioral of CTRL_LED is

signal led_reg : STD_LOGIC_VECTOR(15 downto 0);

begin

    process (clk , rst)
    begin 
        if(rst = '1')then 
            led_reg <= (others=>'0');
        elsif(rising_edge(clk))then 
            if(ce_led = '1')then 
                led_reg <= led_in;
            end if;           
        end if; 
        led_out <= led_reg; 
    end process; 
end Behavioral;
