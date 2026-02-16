----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/14/2026 09:27:42 AM
-- Design Name: 
-- Module Name: Processing_unit - Behavioral
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

entity Processing_unit is
GENERIC (NbBits : INTEGER := 16); 
PORT (
    data_in : IN STD_LOGIC_VECTOR (NbBits-1 DOWNTO 0);
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    load_R1 : IN STD_LOGIC;
    load_accu : IN STD_LOGIC;
    load_carry : IN STD_LOGIC;
    load_equal : IN STD_LOGIC;
    load_neg : IN STD_LOGIC;
    init_carry : IN STD_LOGIC;
    init_equal : IN STD_LOGIC;
    init_neg : IN STD_LOGIC; 
    sel_UAL : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
    sel_accu : IN STD_LOGIC;
    data_out : OUT STD_LOGIC_VECTOR (NbBits-1 DOWNTO 0);
    equal : OUT STD_LOGIC; 
    carry : OUT STD_LOGIC;
    neg : OUT STD_LOGIC);
end Processing_unit;

architecture Behavioral of Processing_unit is

component UAL is 
    GENERIC (NbBits : INTEGER := 16); 
    Port ( A : in STD_LOGIC_VECTOR (NbBits-1 downto 0);
           B : in STD_LOGIC_VECTOR (NbBits-1 downto 0);
           carry : out STD_LOGIC;
           equal : out std_logic;
           neg : out std_logic;
           result : out STD_LOGIC_VECTOR (NbBits-1 downto 0);
           sel_UAL : in STD_LOGIC_VECTOR(3 downto 0));
end component; 

component Registre_File is 
GENERIC (NbBits : INTEGER := 16); 
Port ( clk : in STD_LOGIC;
       rst : in STD_LOGIC;
       load_accu : in STD_LOGIC;
       sel_accu : in STD_LOGIC;
       ACCU : out STD_LOGIC_VECTOR (NbBits-1 downto 0);
       ACCU_reg : in STD_LOGIC_VECTOR (NbBits-1 downto 0));
end component; 

signal R1 : std_logic_vector(NbBits-1 downto 0);
signal ACCU_reg : std_logic_vector(NbBits-1 downto 0); 
signal carry_out : std_logic; 
signal equal_out : std_logic; 
signal neg_out : std_logic; 
signal ACCU : std_logic_vector(NbBits-1 downto 0); 
signal carry_reg : std_logic := '0';
signal equal_reg : std_logic := '0'; 
signal neg_reg : std_logic := '0';  


begin

ALU : UAL 
GENERIC MAP(NbBits => NbBits)
port map(
   A => R1, 
   B => ACCU, 
   sel_UAL => sel_UAL,
   carry => carry_out,
   result => ACCU_reg,
   equal => equal_out,
   neg => neg_out
);

Reg_File : Registre_File 
GENERIC MAP(NbBits => NbBits) 
Port MAP(
    clk => clk,
    rst => rst, 
    load_accu => load_accu,
    sel_accu => sel_accu, 
    ACCU_reg => ACCU_reg,
    ACCU => ACCU
);

process(clk, rst)
begin 
    
    if(rst = '1')then 
        R1 <= std_logic_vector(to_unsigned(0,NbBits)); 
    elsif(rising_edge(clk))then 
        if(load_R1 = '1')then
            R1 <= data_in; 
        else    
            R1 <= R1; 
        end if; 
    end if; 

end process; 

process(clk, rst)
begin 

    if(rst = '1')then 
        carry_reg <= '0'; 
    elsif(rising_edge(clk))then 
        
        if(init_carry = '1')then 
            carry_reg <= '0'; 
        elsif(load_carry = '1')then
            carry_reg <= carry_out; 
        else
            carry_reg <= carry_reg;
        end if; 
    end if; 

end process; 

process(clk, rst)
begin 

    if(rst = '1')then 
        equal_reg <= '0'; 
    elsif(rising_edge(clk))then 
        if(init_equal = '1')then 
            equal_reg <= '0'; 
        elsif(load_equal = '1')then
            equal_reg <= equal_out; 
        else
            equal_reg <= equal_reg;
        end if; 
    end if; 

end process; 

process(clk, rst)
begin 

    if(rst = '1')then 
        neg_reg <= '0'; 
    elsif(rising_edge(clk))then 
        if(init_neg = '1')then 
            neg_reg <= '0'; 
        elsif(load_neg = '1')then
            neg_reg <= neg_out; 
        else
            neg_reg <= neg_reg;
        end if; 
    end if; 

end process; 

carry <= carry_reg;
data_out <= ACCU;
equal <= equal_reg;
neg <= neg_reg;  

end Behavioral;