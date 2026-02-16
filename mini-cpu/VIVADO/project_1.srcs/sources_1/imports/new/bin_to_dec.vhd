----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/17/2025 02:00:51 PM
-- Design Name: 
-- Module Name: bin_to_dec - Behavioral
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

entity bin_to_dec is
    Port ( E : in std_logic_vector(15 downto 0);
           D : out std_logic_vector(3 downto 0);
           U : out std_logic_vector(3 downto 0));
end bin_to_dec;

architecture Behavioral of bin_to_dec is

signal a : unsigned(15 downto 0); 
signal b : unsigned(15 downto 0);

begin


a <= (unsigned(E) / to_unsigned(10,16)) rem to_unsigned(10,16);
b <= unsigned(E) rem to_unsigned(10,16);

D <= std_logic_vector(resize(a , 4)); 
U <= std_logic_vector(resize(b , 4)); 
end Behavioral;
