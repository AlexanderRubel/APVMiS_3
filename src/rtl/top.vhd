----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 16.09.2023 18:03:12
-- Design Name:
-- Module Name: top - Behavioral
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

entity top is
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

        CCO_no_1  : out std_logic;
        CCO_no_2  : out std_logic;
        RCO_no_1  : out std_logic;
        RCO_no_2  : out std_logic;
        Q_ls_o    : out std_logic_vector(3 downto 0);
        Q_ms_o    : out std_logic_vector(3 downto 0)
    );
end top;

architecture Behavioral of top is
    component counter is
        port (
            CLK_i   : in  std_logic;
            OE_ni   : in  std_logic;
            UD_i    : in  std_logic;
            ENT_ni  : in  std_logic;
            ENP_ni  : in  std_logic;
            SCLR_ni : in  std_logic;
            LOAD_ni : in  std_logic;
            ACLR_ni : in  std_logic;
            Data_i  : in  std_logic_vector(3 downto 0);
            CCO_no  : out std_logic;
            RCO_no  : out std_logic;
            Q_o     : out std_logic_vector(3 downto 0)
        );
    end component;
    signal RCO_no_cascad : std_logic;
    signal Q_ls_unsign : unsigned (3 downto 0);
    signal Q_ms_unsign : unsigned (3 downto 0);
begin

    u_counter_1 : counter
        port map (
            CLK_i   => CLK_i,
            OE_ni   => OE_ni,
            UD_i    => UD_i,
            ENT_ni  => ENT_ni,
            ENP_ni  => ENP_ni,
            SCLR_ni => SCLR_ni,
            LOAD_ni => LOAD_ni,
            ACLR_ni => ACLR_ni,
            Data_i  => unsigned(Data_i(3 downto 0)),
            CCO_no  => CCO_no_1,
            RCO_no  => RCO_no_cascad,
            Q_o     => Q_ls_unsign
        );

    u_counter_2 : counter
        port map (
            CLK_i   => CLK_i,
            OE_ni   => OE_ni,
            UD_i    => UD_i,
            ENT_ni  => RCO_no_cascad,
            ENP_ni  => ENP_ni,
            SCLR_ni => SCLR_ni,
            LOAD_ni => LOAD_ni,
            Data_i  => unsigned(Data_i(7 downto 4)),
            ACLR_ni => ACLR_ni,
            CCO_no  => CCO_no_2,
            RCO_no  => RCO_no_2,
            Q_o     => Q_ms_unsign
        );

    Q_ls_o <= std_logic_vector(Q_ls_unsign);
    Q_ms_o <= std_logic_vector(Q_ms_unsign);

    RCO_no_1 <= RCO_no_cascad;

end Behavioral;
