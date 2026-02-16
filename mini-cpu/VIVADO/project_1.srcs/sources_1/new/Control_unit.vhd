----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/16/2026 01:06:00 PM
-- Design Name: 
-- Module Name: Control_unit - Behavioral
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

entity Control_unit is
    GENERIC (RAM_ADR_WIDTH : INTEGER := 6;
            NbBits : INTEGER := 16);
    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        carry : IN STD_LOGIC;
        equal : IN STD_LOGIC;
        neg : IN STD_LOGIC;
        boot : IN STD_LOGIC;
        data_in : IN STD_LOGIC_VECTOR (NbBits-1 DOWNTO 0);
        adr : OUT STD_LOGIC_VECTOR (RAM_ADR_WIDTH - 1 DOWNTO 0);
        clear_carry : OUT STD_LOGIC;
        clear_equal : OUT STD_LOGIC;
        clear_neg : OUT STD_LOGIC; 
        enable_mem : OUT STD_LOGIC;
        load_R1 : OUT STD_LOGIC;
        load_accu : OUT STD_LOGIC;
        load_carry : OUT STD_LOGIC;
        load_neg : OUT STD_LOGIC;
        load_equal : OUT STD_LOGIC;
        sel_UAL : OUT STD_LOGIC_VECTOR(3 downto 0);
        sel_accu : OUT STD_LOGIC;
        w_mem : OUT STD_LOGIC);
end Control_unit;

architecture Behavioral of Control_unit is

component FSM is 
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           code_op : in STD_LOGIC_VECTOR (3 downto 0);
           carry : in STD_LOGIC;
           equal : in STD_LOGIC;
           neg : in STD_LOGIC;
           boot : in STD_LOGIC;
           LOAD_RI : out STD_LOGIC;
           LOAD_PC : out STD_LOGIC;
           clear_PC : out STD_LOGIC;
           en_PC : out STD_LOGIC;
           RW : out STD_LOGIC;
           En_RAM : out STD_LOGIC;
           sel_adr : out STD_LOGIC;
           sel_UAL : out STD_LOGIC_VECTOR (3 downto 0);
           Load_Carry : out STD_LOGIC;
           load_equal : out STD_LOGIC; 
           load_neg : out STD_LOGIC; 
           Clear_Carry : out STD_LOGIC;
           clear_neg : out STD_LOGIC; 
           clear_equal : out STD_LOGIC; 
           LOAD_ACCU : out STD_LOGIC; 
           LOAD_R1 : out STD_LOGIC);
end component; 

    component PC is 
        GENERIC (Nbadr : INTEGER := 6); 
        Port (clk : in STD_LOGIC;
            rst : in STD_LOGIC;
            clear_PC : in STD_LOGIC;
            enable_PC : in STD_LOGIC;
            load_PC : in STD_LOGIC;
            address_PC : out STD_LOGIC_VECTOR (Nbadr-1 downto 0);
            L_AddPC : in STD_LOGIC_VECTOR (Nbadr-1 downto 0));
    end component; 

    component RI is 
        GENERIC (Nbadr : INTEGER := 6;
        NbBits : INTEGER := 16); 
        Port ( clk : in STD_LOGIC;
            rst : in STD_LOGIC;
            data_in : in STD_LOGIC_VECTOR (NbBits-1 downto 0);
            code_op : out STD_LOGIC_VECTOR (3 downto 0);
            R_n : out STD_LOGIC;
            addr_RI : out STD_LOGIC_VECTOR (Nbadr-1 downto 0);
            LOAD_RI : in STD_LOGIC);
    end component; 

signal code_op : STD_LOGIC_VECTOR(3 downto 0);
signal LOAD_RI : STD_LOGIC;
signal addr_RI : STD_LOGIC_VECTOR(RAM_ADR_WIDTH-1 downto 0);
signal sel_adr : STD_LOGIC; 
signal clear_PC : STD_LOGIC;
signal en_PC : STD_LOGIC;
signal LOAD_PC : STD_LOGIC; 
signal addr_PC : STD_LOGIC_VECTOR(RAM_ADR_WIDTH-1 downto 0); 

begin 

Inst_Reg : RI 
    GENERIC MAP(Nbadr => RAM_ADR_WIDTH,
    NbBits => NbBits)
    PORT MAP(clk => clk,
            rst => rst, 
            data_in => data_in,
            code_op => code_op,
            R_n => sel_accu,
            addr_RI => addr_RI, 
            LOAD_RI => LOAD_RI);

CPU : FSM 
    PORT MAP( clk => clk,
        rst => rst,
        code_op => code_op,
        carry => carry,
        equal => equal, 
        neg => neg,
        boot => boot,
        clear_PC => clear_PC, 
        en_PC => en_PC, 
        LOAD_PC => LOAD_PC,
        LOAD_RI => LOAD_RI, 
        sel_adr => sel_adr,
        clear_carry => clear_carry,
        clear_neg => clear_neg, 
        clear_equal => clear_equal,
        En_RAM => enable_mem,
        LOAD_R1 => load_R1,
        LOAD_accu => load_accu,
        LOAD_carry => load_carry,
        load_equal => load_equal, 
        load_neg => load_neg, 
        sel_UAL => sel_UAL,
        RW => w_mem);

Program_Counter : PC 
    GENERIC MAP(Nbadr => RAM_ADR_WIDTH)
    PORT MAP(clk => clk,
            rst => rst,
            clear_PC => clear_PC, 
            enable_PC => en_PC,
            load_PC => LOAD_PC, 
            address_PC => addr_PC,
            L_AddPC => addr_RI);

process(sel_adr, addr_PC, addr_RI)
begin 
    case sel_adr is 
        when '0' =>
            adr <= addr_PC;
        when '1' =>
            adr <= addr_RI;
        when others =>
            adr <= addr_PC;
    end case; 
end process; 

end architecture; 