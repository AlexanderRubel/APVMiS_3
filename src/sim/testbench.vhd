----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 17.09.2023 12:37:43
-- Design Name:
-- Module Name: testbench - Behavioral
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

entity testbench is
--  Port ( );
end testbench;

architecture Behavioral of testbench is
    component top is
        Port (
            CLK_i   : in  std_logic;
            OE_ni   : in  std_logic;
            UD_i    : in  std_logic;    
            ENT_ni  : in  std_logic;
            ENP_ni  : in  std_logic;
            SCLR_ni : in  std_logic;
            LOAD_ni : in  std_logic;
            ACLR_ni : in  std_logic;
            Data_i  : in  std_logic_vector(7 downto 0);
            CCO_no_0  : out std_logic;
            RCO_no_0  : out std_logic;
            Q_o_0     : out unsigned(3 downto 0);
            CCO_no_1  : out std_logic;
            RCO_no_1  : out std_logic;
            Q_ls_o_1 : out std_logic_vector(3 downto 0);
            Q_ms_o_1 : out std_logic_vector(3 downto 0)
        );
    end component;
    signal CLK    : std_logic := '0';
    signal OE     : std_logic;
    signal UD     : std_logic;
    signal ENT    : std_logic;
    signal ENP    : std_logic;
    signal SCLR   : std_logic;
    signal LOAD   : std_logic;
    signal ACLR   : std_logic;
    signal Data   : std_logic_vector(7 downto 0);
    signal CCO_0  : std_logic;
    signal RCO_0  : std_logic;
    signal Q_0    : unsigned(3 downto 0);
    signal CCO_1  : std_logic;
    signal RCO_1  : std_logic;
    -- signal Q_1    : std_logic_vector(3 downto 0);
    signal Q_ls_o_1 : std_logic_vector(3 downto 0);
    signal Q_ms_o_1 : std_logic_vector(3 downto 0);
    constant PERIOD : time := 10 ns;
begin
    u_top_0 : top
    port map (
        CLK_i    => CLK,
        OE_ni    => OE,
        UD_i     => UD,
        ENT_ni   => ENT,
        ENP_ni   => ENP,
        SCLR_ni  => SCLR,
        LOAD_ni  => LOAD,
        ACLR_ni  => ACLR,
        Data_i   => Data,
        CCO_no_0 => CCO_0,
        RCO_no_0 => RCO_0,
        Q_o_0    => Q_0,
        CCO_no_1 => CCO_1,
        RCO_no_1 => RCO_1,
        -- Q_o_1    => Q_1
        Q_ls_o_1 => Q_ls_o_1,
        Q_ms_o_1 => Q_ms_o_1
    );

    CLK <= not CLK after PERIOD/2;

    process
    begin
        ACLR <= '0';
        OE   <= '0';
        SCLR <= '1';
        LOAD <= '1';
        ENP  <= '0';
        ENT  <= '0';
        UD   <= '1';
        Data <= "00000000";
        wait for PERIOD/2;
        LOAD <= '0';
        wait for PERIOD;
        LOAD <= '1';
        wait for PERIOD*2;
        UD   <= '0';
        wait for PERIOD;
        UD   <= '1';
        wait for PERIOD*2;
        ACLR <= '1';
        wait for PERIOD*30;
        UD   <= '0';
        wait for PERIOD*30;
        UD   <= '1';
        Data <= "00000101";
        wait for PERIOD*3;
        LOAD <= '0';
        wait for PERIOD;
        UD   <= '0';
        wait for PERIOD;
        UD   <= '1';
        wait for PERIOD*2;
        LOAD <= '1';
        wait for PERIOD*5;
        LOAD <= '0';
        wait for PERIOD*2;
        SCLR <= '0';
        wait for PERIOD;
        SCLR <= '1';
        LOAD <= '1';
        wait for PERIOD*5;
        SCLR <= '0';
        wait for PERIOD;
        UD   <= '0';
        wait for PERIOD;
        UD   <= '1';
        wait for PERIOD;
        SCLR <= '1';
        wait for PERIOD*12;
        ENT <= '1';
        wait for PERIOD*5;
        ENP <= '1';
        wait for PERIOD*5;
        ENT <= '0';
        wait for PERIOD*5;
        ENP <= '0';
        wait for PERIOD*5;
        wait;
    end process;

    -- process
    -- begin
    --     ACLR <= '0';
    --     OE   <= '0';
    --     SCLR <= '1';
    --     LOAD <= '1';
    --     ENP  <= '0';
    --     ENT  <= '0';
    --     UD   <= '1';
    --     Data <= "0101";
    --     wait for PERIOD;
    --     LOAD <= '1';
    --     wait for PERIOD;
    --     LOAD <= '0';
    --     wait for PERIOD;
    --     LOAD <= '1';
    --     wait for PERIOD*2;
    --     UD   <= '1';
    --     wait for PERIOD;
    --     UD   <= '0';
    --     wait for PERIOD;
    --     UD   <= '1';
    --     wait for PERIOD*3;
    --     ACLR <= '1';
    --     wait for PERIOD*10;
    --     SCLR <= '0';
    --     wait for PERIOD*3;
    --     LOAD <= '0';
    --     wait for PERIOD;
    --     LOAD <= '1';
    --     wait for PERIOD*3;
    --     wait for PERIOD;
    --     UD   <= '0';
    --     wait for PERIOD;
    --     UD   <= '1';
    --     wait for PERIOD*3;
    --     SCLR <= '1';
    --     wait for PERIOD;
    --     LOAD <= '0';
    --     wait for PERIOD;
    --     UD   <= '0';
    --     wait for PERIOD;
    --     UD   <= '1';
    --     wait for PERIOD*2;
    --     LOAD <= '1';
    --     wait for PERIOD;
    --     Data <= "0011";
    --     wait for PERIOD/2;
    --     SCLR <= '0';
    --     wait for PERIOD/2;
    --     wait for PERIOD;
    --     SCLR <= '1';
    --     wait for PERIOD/2;
    --     LOAD <= '0';
    --     wait for PERIOD/2;
    --     wait for PERIOD/2;
    --     LOAD <= '1';
    --     wait for PERIOD/2;
    --     ENT  <= '0';
    --     wait for PERIOD*5;
    --     LOAD <= '0';
    --     wait for PERIOD;
    --     LOAD <= '1';
    --     wait for PERIOD*5;
    --     UD <= '0';
    --     wait for PERIOD;
    --     LOAD <= '0';
    --     wait for PERIOD;
    --     LOAD <= '1';
    --     wait for PERIOD*10;
    --     UD <= '1';

    --     wait for PERIOD*10;
    --     wait for PERIOD/2;
    --     OE   <= '1';
    --     wait for PERIOD*4;
    --     OE   <= '0';
    --     wait for PERIOD/2;
    --     wait for PERIOD;
    --     wait for PERIOD/2;
    --     UD   <= '0';
    --     wait for PERIOD/2;
    --     wait for PERIOD*6;
    --     UD   <= '1';
    --     wait for PERIOD;
    --     UD   <= '0';
    --     wait for PERIOD*2;
    --     wait for PERIOD/2;
    --     OE   <= '1';
    --     wait for PERIOD*4;
    --     OE   <= '0';
    --     wait for PERIOD/2;
    --     wait for PERIOD/2;
    --     ENP  <= '1';
    --     wait for PERIOD*2;
    --     ENT  <= '1';
    --     wait for PERIOD;
    --     ENP  <= '0';
    --     wait for PERIOD/2;
    --     SCLR <= '0';
    --     wait for PERIOD*3;
    --     LOAD <= '0';
    --     wait for PERIOD;
    --     LOAD <= '1';
    --     wait for PERIOD*3;
    --     wait for PERIOD;
    --     UD   <= '0';
    --     wait for PERIOD;
    --     UD   <= '1';
    --     wait for PERIOD*3;
    --     SCLR <= '1';
    --     wait for PERIOD;
    --     LOAD <= '0';
    --     wait for PERIOD;
    --     UD   <= '0';
    --     wait for PERIOD;
    --     UD   <= '1';
    --     wait for PERIOD*2;
    --     LOAD <= '1';
    --     wait for PERIOD;
    --     wait for PERIOD;
    --     -- ACLR <= 'Z';
    --     -- OE   <= 'Z';
    --     -- SCLR <= 'Z';
    --     -- LOAD <= 'Z';
    --     -- ENP  <= 'Z';
    --     -- ENT  <= 'Z';
    --     -- UD   <= 'Z';
    --     -- Data <= "ZZZZ";
    --     wait;
    -- end process;

end Behavioral;
