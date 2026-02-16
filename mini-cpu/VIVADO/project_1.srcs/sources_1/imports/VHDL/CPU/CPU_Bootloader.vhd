LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY CPU_Bootloader IS
    GENERIC (
        RAM_ADR_WIDTH : INTEGER := 7;
        RAM_SIZE : INTEGER := 64;
        NbBits : INTEGER := 16);
    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        scan_memory : IN STD_LOGIC;
        rx : IN STD_LOGIC;
        tx : OUT STD_LOGIC;
        led : OUT STD_LOGIC_VECTOR(15 downto 0);
        sept_segment : out STD_LOGIC_VECTOR (6 downto 0);
        AN : out std_logic_vector(7 downto 0));
END CPU_Bootloader;

ARCHITECTURE Behavioral OF CPU_Bootloader IS

    COMPONENT boot_loader IS
        GENERIC (
            RAM_ADR_WIDTH : INTEGER := 6;
            RAM_SIZE : INTEGER := 64);
        PORT (
            rst : IN STD_LOGIC;
            clk : IN STD_LOGIC;
            rx : IN STD_LOGIC;
            tx : OUT STD_LOGIC;
            boot : OUT STD_LOGIC;
            scan_memory : IN STD_LOGIC;
            ram_out : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            ram_rw : OUT STD_LOGIC;
            ram_enable : OUT STD_LOGIC;
            ram_adr : OUT STD_LOGIC_VECTOR(RAM_ADR_WIDTH - 1 DOWNTO 0);
            ram_in : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
    END COMPONENT;

    COMPONENT Control_Unit IS
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
    END COMPONENT;

    COMPONENT Processing_unit
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
    END COMPONENT;

    COMPONENT RAM_SP_64_8 IS
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
    END COMPONENT;
    
    COMPONENT CTRL_LED IS 
        Port ( clk : in STD_LOGIC;
               rst : in STD_LOGIC;
               led_in : in STD_LOGIC_VECTOR (15 downto 0);
               led_out : out STD_LOGIC_VECTOR (15 downto 0);
               ce_led : in STD_LOGIC);
    END COMPONENT; 
    
    COMPONENT CTRL_SeptSeg IS 
        Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           value : in STD_LOGIC_VECTOR (15 downto 0);
           sept_segment : out STD_LOGIC_VECTOR (6 downto 0);
           AN : out std_logic_vector(7 downto 0));
    END COMPONENT; 

    SIGNAL UT_data_out : STD_LOGIC_VECTOR (15 DOWNTO 0);
    SIGNAL sig_adr : STD_LOGIC_VECTOR (RAM_ADR_WIDTH - 1 DOWNTO 0);
    SIGNAL carry : STD_LOGIC;
    SIGNAL equal : STD_LOGIC;
    SIGNAL neg : STD_LOGIC;
    SIGNAL clear_carry : STD_LOGIC;
    SIGNAL clear_equal : STD_LOGIC;
    SIGNAL clear_neg : STD_LOGIC;
    SIGNAL enable_mem : STD_LOGIC;
    SIGNAL load_R1 : STD_LOGIC;
    SIGNAL load_accu : STD_LOGIC;
    SIGNAL load_carry : STD_LOGIC;
    SIGNAL load_equal : STD_LOGIC;
    SIGNAL load_neg : STD_LOGIC; 
    SIGNAL sel_accu : STD_LOGIC;
    SIGNAL sel_UAL_UC : STD_LOGIC_VECTOR (3 DOWNTO 0);
    SIGNAL w_mem : STD_LOGIC;

    SIGNAL ram_data_in, ram_data_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL ram_enable : STD_LOGIC;

    SIGNAL sig_rw : STD_LOGIC;
    SIGNAL sig_ram_enable : STD_LOGIC;
    SIGNAL sig_ram_adr : STD_LOGIC_VECTOR(RAM_ADR_WIDTH - 1 DOWNTO 0);
    SIGNAL sig_ram_in : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL RW_led : STD_LOGIC; 
    SIGNAL RW_RAM : STD_LOGIC;

    SIGNAL boot : STD_LOGIC;
    SIGNAL boot_ram_adr : STD_LOGIC_VECTOR(RAM_ADR_WIDTH - 1 DOWNTO 0);
    SIGNAL boot_ram_in : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL boot_ram_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL boot_ram_rw : STD_LOGIC;
    SIGNAL boot_ram_enable : STD_LOGIC; 
    
    SIGNAL led_reg_out : STD_LOGIC_VECTOR(15 downto 0);

BEGIN
    UC : Control_unit
    GENERIC MAP(RAM_ADR_WIDTH => RAM_ADR_WIDTH,
                NbBits => NbBits)
    PORT MAP(
        clk => clk,
        rst => rst,
        carry => carry,
        equal => equal, 
        neg => neg,
        boot => boot,
        data_in => ram_data_out,
        adr => sig_adr,
        clear_carry => clear_carry,
        clear_equal => clear_equal, 
        clear_neg => clear_neg,
        enable_mem => enable_mem,
        load_R1 => load_R1,
        load_accu => load_accu,
        load_carry => load_carry,
        load_equal => load_equal,
        load_neg => load_neg,
        sel_accu => sel_accu,
        sel_UAL => sel_UAL_UC,
        w_mem => w_mem);

    UT : Processing_unit 
    GENERIC MAP(NbBits => NbBits)
    PORT MAP(
        data_in => ram_data_out,
        clk => clk,
        rst => rst,
        load_R1 => load_R1,
        load_accu => load_accu,
        load_carry => load_carry,
        load_equal => load_equal,
        load_neg => load_neg,
        init_carry => clear_carry,
        init_equal => clear_equal,
        init_neg => clear_neg,
        sel_UAL => sel_UAL_UC,
        sel_accu => sel_accu,
        data_out => UT_data_out,
        carry => carry,
        equal => equal, 
        neg => neg);

    BL : boot_loader GENERIC MAP(
        RAM_ADR_WIDTH => RAM_ADR_WIDTH,
        RAM_SIZE => RAM_SIZE)
    PORT MAP(
        rst => rst,
        clk => clk,
        rx => rx,
        tx => tx,
        boot => boot,
        scan_memory => scan_memory,
        ram_out => ram_data_out,
        ram_rw => boot_ram_rw,
        ram_enable => boot_ram_enable,
        ram_adr => boot_ram_adr,
        ram_in => boot_ram_in);
    
    LED_CTRL : CTRL_LED 
    PORT MAP(clk => clk, 
             rst => rst, 
             led_in => sig_ram_in, 
             led_out => led_reg_out, 
             ce_led => RW_led); 
             
         
    SEPT_SEG_CTRL : CTRL_SeptSeg 
        PORT MAP(clk => clk, 
                 rst => rst, 
                 value => led_reg_out, 
                 sept_segment => sept_segment, 
                 AN => AN);             
    -- boot controled MUX for RAM signal 
    sig_rw <= boot_ram_rw WHEN boot = '1' ELSE
        w_mem;
    sig_ram_enable <= boot_ram_enable WHEN boot = '1' ELSE
        enable_mem;
    sig_ram_adr <= boot_ram_adr WHEN boot = '1' ELSE
        sig_adr;
    sig_ram_in <= boot_ram_in WHEN boot = '1' ELSE
        UT_data_out;
    
    led <= led_reg_out;
       
    UM : RAM_SP_64_8
    GENERIC MAP(
        NbBits => NbBits,
        Nbadr => RAM_ADR_WIDTH)
    PORT MAP(
        add => sig_ram_adr,
        data_in => sig_ram_in,
        r_w => RW_RAM,
        clk => clk,
        data_out => ram_data_out);
        
    process(sig_ram_adr, sig_rw)
    begin   
        if(sig_rw = '1')then 
            if(to_integer(unsigned(sig_ram_adr)) < 64)then 
                RW_RAM <= '1'; 
                RW_led <= '0';
            else
                RW_RAM <= '0'; 
                RW_led <= '1';      
            end if; 
        else
            RW_RAM <= '0'; 
            RW_led <= '0';     
        end if;         
    end process;  

END Behavioral;