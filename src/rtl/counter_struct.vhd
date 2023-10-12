----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 19.09.2023 22:53:18
-- Design Name:
-- Module Name: counter_struct - Behavioral
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

entity counter_struct is
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
end counter_struct;

architecture Behavioral of counter_struct is
    signal regs_array     : std_logic_vector (3 downto 0);
    signal or_data_bus    : std_logic_vector (3 downto 0);
    signal load_bus       : std_logic_vector (3 downto 0);
    signal count_UD_bus   : std_logic_vector (3 downto 0);
    signal load_en        : std_logic;
    signal count_en       : std_logic;
    signal regs_en        : std_logic;
    signal nand_2         : std_logic;
    signal nand_1         : std_logic;
    signal and_3_2        : std_logic;
    signal and_3_1        : std_logic;
    signal and_2_2        : std_logic;
    signal and_2_1        : std_logic;
    signal and_1_2        : std_logic;
    signal and_1_1        : std_logic;
    signal and_0_2        : std_logic;
    signal and_0_1        : std_logic;
    signal and_rco_common : std_logic;
    signal and_rco_0      : std_logic;
    signal and_rco_1      : std_logic;
    signal RCO_n          : std_logic;
begin
    process (all)
    begin
        if (ACLR_ni = '0') then
            regs_array <= "0000"; --after 1 ns;
        elsif (CLK_i'event and CLK_i='1') then
            regs_array <= or_data_bus; --after 1 ns;
        end if;
    end process;

    count_en <=  LOAD_ni      and SCLR_ni;
    load_en  <= (not LOAD_ni) and SCLR_ni;
    regs_en  <= (not load_en) and (SCLR_ni) and (not ENP_ni) and (not ENT_ni);

    load_bus <=   (Data_i(3) and load_en)
                & (Data_i(2) and load_en)
                & (Data_i(1) and load_en)
                & (Data_i(0) and load_en);

    count_UD_bus <=   (not (((not  regs_array(3)) and     (UD_i))
                              or (regs_array(3)  and (not UD_i))))
                    & (not (((not  regs_array(2)) and     (UD_i))
                              or (regs_array(2)  and (not UD_i))))
                    & (not (((not  regs_array(1)) and     (UD_i))
                              or (regs_array(1)  and (not UD_i))))
                    & (not (((not  regs_array(0)) and     (UD_i))
                              or (regs_array(0)  and (not UD_i))));

    nand_2 <= not ((not regs_array(3)) and (not UD_i) and (not regs_array(2)));
    nand_1 <= not (count_UD_bus(3) and UD_i);

    and_3_2 <= (not (count_en and regs_array(3))) and regs_en
                and count_UD_bus(0) and count_UD_bus(1)
                and count_UD_bus(2);
    and_3_1 <= (count_en and (not (count_UD_bus(0) and regs_en))
                and regs_array(3));

    and_2_2 <= nand_2 and (not (count_en and regs_array(2))) and regs_en
                    and count_UD_bus(0) and count_UD_bus(1);
    and_2_1 <= regs_array(2) and count_en
                and (not (regs_en and count_UD_bus(0) and count_UD_bus(1)));

    and_1_2 <= nand_1 and (not regs_array(1)) and nand_2 and regs_en
                and count_UD_bus(0);
    and_1_1 <= regs_array(1) and count_en
                    and (not (regs_en and count_UD_bus(0)));

    and_0_2 <= regs_en and (not (count_en and regs_array(0)));
    and_0_1 <= regs_array(0) and (not regs_en) and count_en;

    or_data_bus <=  (load_bus(3) or and_3_1 or and_3_2)
                  & (load_bus(2) or and_2_2 or and_2_1)
                  & (load_bus(1) or and_1_2 or and_1_1)
                  & (load_bus(0) or and_0_2 or and_0_1);


    and_rco_common <= count_UD_bus(3) and count_UD_bus(0) and (not ENT_ni);
    and_rco_0      <= UD_i and and_rco_common;
    and_rco_1      <= (not UD_i) and and_rco_common and count_UD_bus(1)
                        and count_UD_bus(2);
    RCO_n  <= not (and_rco_0 or and_rco_1);
    RCO_no <= RCO_n;

    CCO_no <= not ((not RCO_n) and ((not ENT_ni) and (not ENP_ni))
                and (CLK_i));

    Q_o <= regs_array when OE_ni = '0' else "ZZZZ";

end Behavioral;
