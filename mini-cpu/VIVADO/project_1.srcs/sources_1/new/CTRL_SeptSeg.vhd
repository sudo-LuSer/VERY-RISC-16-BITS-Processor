----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/28/2026 10:59:48 AM
-- Design Name: 
-- Module Name: CTRL_SeptSeg - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity CTRL_SeptSeg is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           value : in STD_LOGIC_VECTOR (15 downto 0);
           sept_segment : out STD_LOGIC_VECTOR (6 downto 0);
           AN : out std_logic_vector(7 downto 0));
end CTRL_SeptSeg;

architecture Behavioral of CTRL_SeptSeg is

component Transcodeur4_7 is
    Port ( E : in std_logic_vector(3 downto 0);
           S : out std_logic_vector(6 downto 0));
end component;

component MUX4_1_4bits is
    Port (E0 : in std_logic_vector(3 downto 0);
           E1 : in std_logic_vector(3 downto 0);
           S : out std_logic_vector(3 downto 0);
           cmd : in std_logic);
end component;
    
component bin_to_dec is
    Port ( E : in std_logic_vector(15 downto 0);
           D : out std_logic_vector(3 downto 0);
           U : out std_logic_vector(3 downto 0));
end component;

component compteur_mod4 is 
    Port ( ce : in STD_LOGIC;
           rst : in STD_LOGIC;
           S : out STD_LOGIC);
end component; 

component MUX_AN is 
    Port (E0 : in std_logic_vector(6 downto 0);
       E1 : in std_logic_vector(6 downto 0);
       S : out std_logic_vector(6 downto 0);
       cmd : in std_logic);
end component; 

component ce_3KHz is 
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           tick : out STD_LOGIC);
end component;

signal D_Val : STD_LOGIC_VECTOR(3 downto 0); 
signal U_Val : STD_LOGIC_VECTOR(3 downto 0);
signal val_cmp4 : STD_LOGIC;

signal E0_Mux : STD_LOGIC_VECTOR(6 downto 0); 
signal E2_Mux : STD_LOGIC_VECTOR(6 downto 0);

signal ANOD_SAVE : std_logic_vector(6 downto 0);

signal ANN : std_logic_vector(3 downto 0); 

signal ce : std_logic;

begin


bit_dec : bin_to_dec 
    port map(E => value , D => D_Val , U => U_Val); 
    
clock_segment : ce_3KHz 
    port map(clk => clk, rst => rst, tick =>  ce); 
  
Mux1input : Transcodeur4_7
    port map(E => D_Val , S => E0_Mux); 

Mux2input : Transcodeur4_7
    port map(E => U_Val , S => E2_Mux);
    
cmp_mod4:compteur_mod4
    port map(ce => ce, rst => rst , S => val_cmp4); 
    
Mux_Anode : MUX_AN
    port map(E0 => E0_Mux , E1 => E2_Mux, cmd => val_cmp4 , S => ANOD_SAVE);
    
Multiplixer_4bit : MUX4_1_4bits
    port map(E0 => "1110" , E1 => "1101", cmd => val_cmp4 , S => ANN);
    
sept_segment <= ANOD_SAVE; 
AN <= "1111" & ANN;

end Behavioral;
