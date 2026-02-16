----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/14/2026 11:54:17 AM
-- Design Name: 
-- Module Name: FSM - Behavioral
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

entity FSM is
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
end FSM;

architecture Behavioral of FSM is

type state is (INIT, FETCH_INSTR, FETCH_INSTR_DELAY, DECODE, FETCH_OP, FETCH_OP_DELAY, EXE_NOR_ADD, EXE_STA, EXE_STA_DELAY, EXE_JCC, EXE_JUMP, EXE_JCN, EXE_JCE); 
signal etat_p , etat_f : state; 

begin

process(etat_p, code_op)
begin 
    etat_f <= etat_p;
    case etat_p is 
        when INIT =>
            etat_f <= FETCH_INSTR; 
        when FETCH_INSTR => 
            etat_f <= FETCH_INSTR_DELAY; 
        when FETCH_INSTR_DELAY =>
            etat_f <= DECODE; 
        when DECODE => 
            case code_op is 
                when "1100" =>
                    etat_f <= EXE_JCC; 
                when "1000" =>
                    etat_f <= EXE_STA; 
                when "1001" =>
                    etat_f <= EXE_JUMP; 
                when "1010" => 
                    etat_f <= EXE_JCE; 
                when "1011" =>
                    etat_f <= EXE_JCN; 
                when others =>
                    etat_f <= FETCH_OP; 
            end case;         
        when FETCH_OP =>
            etat_f <= FETCH_OP_DELAY; 
        when FETCH_OP_DELAY => 
            etat_f <= EXE_NOR_ADD; 
        when EXE_STA =>
            etat_f <= EXE_STA_DELAY;
        when others =>
            etat_f <= FETCH_INSTR; 
    end case; 
end process; 

process(clk , rst)
begin 

    if(rst = '1')then 
        etat_p <= INIT;
    elsif(rising_edge(clk))then 
        if(boot = '0')then  
            etat_p <= etat_f; 
        else
            etat_p <= INIT; 
        end if; 
    end if; 
end process; 

process(etat_p, code_op, carry, equal, neg)
begin
    
    case etat_p is
        when INIT =>
            LOAD_RI <= '0';
            LOAD_PC <= '0';
            clear_PC <= '1';
            clear_neg <= '1'; 
            clear_equal <= '1';
            en_PC <= '0';
            RW <= '0';
            En_RAM <= '0';
            sel_adr <= '0';
            sel_UAL <= "0000";
            Load_Carry <= '0';
            Clear_Carry <= '1';
            LOAD_ACCU <= '0';
            LOAD_R1 <= '0';
            load_neg <= '0'; 
            load_equal <= '0';
        when FETCH_INSTR =>
            LOAD_RI <= '0';
            LOAD_PC <= '0';
            clear_PC <= '0';
            clear_neg <= '0'; 
            clear_equal <= '0';
            en_PC <= '0';
            RW <= '0';
            En_RAM <= '1';
            sel_adr <= '0';
            sel_UAL <= "0000";
            Load_Carry <= '0';
            Clear_Carry <= '0';
            LOAD_ACCU <= '0';
            LOAD_R1 <= '0';     
            load_neg <= '0'; 
            load_equal <= '0';
        when FETCH_INSTR_DELAY =>
            LOAD_RI <= '1';
            LOAD_PC <= '0';
            clear_PC <= '0';
            clear_neg <= '0'; 
            clear_equal <= '0';
            en_PC <= '0';
            RW <= '0';
            En_RAM <= '1';
            sel_adr <= '0';
            sel_UAL <= "0000";
            Load_Carry <= '0';
            Clear_Carry <= '0';
            LOAD_ACCU <= '0';
            LOAD_R1 <= '0';
            load_neg <= '0'; 
            load_equal <= '0';
        when DECODE =>
            LOAD_RI <= '0';
            LOAD_PC <= '0';
            clear_PC <= '0';
            clear_neg <= '0'; 
            clear_equal <= '0';
            en_PC <= '0';
            RW <= '0';
            En_RAM <= '0';
            sel_adr <= '1';
            sel_UAL <= "0000";
            Load_Carry <= '0';
            Clear_Carry <= '0';
            LOAD_ACCU <= '0';
            LOAD_R1 <= '0';
            load_neg <= '0'; 
            load_equal <= '0';
        when FETCH_OP =>
            LOAD_RI <= '0';
            LOAD_PC <= '0';
            clear_PC <= '0';
            clear_neg <= '0'; 
            clear_equal <= '0';
            en_PC <= '0';
            RW <= '0';
            En_RAM <= '1';
            sel_adr <= '1';
            sel_UAL <= "0000";
            Load_Carry <= '0';
            Clear_Carry <= '0';
            LOAD_ACCU <= '0';
            LOAD_R1 <= '1';
            load_neg <= '0'; 
            load_equal <= '0';
        when FETCH_OP_DELAY =>
            LOAD_RI <= '0';
            LOAD_PC <= '0';
            clear_PC <= '0';
            clear_neg <= '0'; 
            clear_equal <= '0';
            en_PC <= '0';
            RW <= '0';
            En_RAM <= '1';
            sel_adr <= '1';
            sel_UAL <= "0000";
            Load_Carry <= '0';
            Clear_Carry <= '0';
            LOAD_ACCU <= '0';
            LOAD_R1 <= '1';  
            load_neg <= '0'; 
            load_equal <= '0';  
            
        when EXE_NOR_ADD =>
            LOAD_RI <= '0';
            LOAD_PC <= '0';
            clear_PC <= '0';
            clear_neg <= '0'; 
            clear_equal <= '0';
            en_PC <= '1';
            RW <= '0';
            En_RAM <= '0';
            sel_adr <= '1';
            sel_UAL <= code_op;
            case code_op is 
                when "0000" =>
                    load_carry <= '0'; 
                when others => 
                    Load_Carry <= '1'; 
            end case; 
            load_neg <= '1'; 
            load_equal <= '1';
            Clear_Carry <= '0';
            LOAD_ACCU <= '1';
            LOAD_R1 <= '0'; 
            
        when EXE_STA =>
            LOAD_RI <= '0';
            LOAD_PC <= '0';
            clear_PC <= '0';
            clear_neg <= '0'; 
            clear_equal <= '0';
            en_PC <= '0';
            RW <= '1';
            En_RAM <= '1';
            sel_adr <= '1';
            sel_UAL <= "0000";
            Load_Carry <= '0';
            load_neg <= '0'; 
            load_equal <= '0';
            Clear_Carry <= '0';
            LOAD_ACCU <= '0';
            LOAD_R1 <= '0';
            
        when EXE_STA_DELAY =>
            LOAD_RI <= '0';
            LOAD_PC <= '0';
            clear_PC <= '0';
            clear_neg <= '0'; 
            clear_equal <= '0';
            en_PC <= '1';
            RW <= '0';
            En_RAM <= '1';
            sel_adr <= '1';
            sel_UAL <= "0000";
            Load_Carry <= '0';
            load_neg <= '0'; 
            load_equal <= '0';
            Clear_Carry <= '0';
            LOAD_ACCU <= '0';
            LOAD_R1 <= '0';
            
        when EXE_JCC =>
            LOAD_RI <= '1';
            LOAD_PC <= not(carry);
            clear_neg <= '0'; 
            clear_equal <= '0';
            clear_PC <= '0';
            en_PC <= carry;
            RW <= '0';
            En_RAM <= '0';
            sel_adr <= '1';
            sel_UAL <= "0000";
            Load_Carry <= '0';
            load_neg <= '0'; 
            load_equal <= '0';
            Clear_Carry <= carry;
            LOAD_ACCU <= '0';
            LOAD_R1 <= '0';
        when EXE_JCE =>
            LOAD_RI <= '1';
            LOAD_PC <= equal;
            clear_PC <= '0';
            clear_neg <= '0'; 
            clear_equal <= equal;
            en_PC <= not equal;
            RW <= '0';
            En_RAM <= '0';
            sel_adr <= '1';
            sel_UAL <= "0000";
            Load_Carry <= '0';
            load_neg <= '0'; 
            load_equal <= '0';
            Clear_Carry <= '0';
            LOAD_ACCU <= '0';
            LOAD_R1 <= '0';
        when EXE_JCN =>
            LOAD_RI <= '1';
            LOAD_PC <= not(neg);
            clear_neg <= neg; 
            clear_equal <= '0';
            clear_PC <= '0';
            en_PC <= neg;
            RW <= '0';
            En_RAM <= '0';
            sel_adr <= '1';
            sel_UAL <= "0000";
            Load_Carry <= '0';
            load_neg <= '0'; 
            load_equal <= '0';
            Clear_Carry <= '0';
            LOAD_ACCU <= '0';
            LOAD_R1 <= '0';
        when EXE_JUMP =>
            LOAD_RI <= '1';
            LOAD_PC <= '1';
            clear_neg <= '0'; 
            clear_equal <= '0';
            clear_PC <= '0';
            en_PC <= '0';
            RW <= '0';
            En_RAM <= '0';
            sel_adr <= '1';
            sel_UAL <= "0000";
            Load_Carry <= '0';
            load_neg <= '0'; 
            load_equal <= '0';
            Clear_Carry <= '0';
            LOAD_ACCU <= '0';
            LOAD_R1 <= '0';
    end case;
end process;


end Behavioral;