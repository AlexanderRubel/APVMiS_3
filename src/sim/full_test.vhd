library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use std.textio.all;

-- library textutil;
-- use textutil.std_logic_textio.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity full_test is
--  Port ( );
end full_test;

architecture Behavioral of full_test is
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
            -- CCO_no_0  : out std_logic;
            -- RCO_no_0  : out std_logic;
            -- Q_o_0     : out unsigned(3 downto 0);
            CCO_no_1  : out std_logic;
            CCO_no_2  : out std_logic;
            RCO_no_1  : out std_logic;
            RCO_no_2  : out std_logic;
            Q_ls_o    : out std_logic_vector(3 downto 0);
            Q_ms_o    : out std_logic_vector(3 downto 0)
        );
    end component;

    function str2vec(str: string) return std_logic_vector is
        variable temp: std_logic_vector(str'range) := (others => 'X');
    begin
        for i in str'range loop
            if (str(i) = '1') then
                temp(i) := '1';
            elsif (str(i) = '0') then
                temp(i) := '0';
            elsif (str(i) = 'X') then
                temp(i) := 'X';
            elsif (str(i) = 'Z') then
                temp(i) := 'Z';
            elsif (str(i) = 'U') then
                temp(i) := 'U';
            elsif (str(i) = 'W') then
                temp(i) := 'W';
            elsif (str(i) = 'L') then
                temp(i) := 'L';
            elsif (str(i) = 'H') then
                temp(i) := 'H';
            else
                temp(i) := '-';
            end if;
        end loop;
        return temp;
    end function;

    function vec2str(vec: std_logic_vector) return string is
        variable temp: string(vec'left+1 downto 1);
    begin
        for i in vec'reverse_range loop
            if (vec(i) = '1') then
                temp(i+1) := '1';
            elsif (vec(i) = '0') then
                temp(i+1) := '0';
            elsif (vec(i) = 'X') then
                temp(i+1) := 'X';
            elsif (vec(i) = 'Z') then
                temp(i+1) := 'Z';
            elsif (vec(i) = 'U') then
                temp(i+1) := 'U';
            elsif (vec(i) = 'W') then
                temp(i+1) := 'W';
            elsif (vec(i) = 'L') then
                temp(i+1) := 'L';
            elsif (vec(i) = 'H') then
                temp(i+1) := 'H';
            else
                temp(i+1) := '-';
            end if;
        end loop;
        return temp;
    end;

    function logic2str(vec: std_logic) return string is
        variable temp: string(1 downto 1);
    begin
        if (vec = '1') then
            temp(1) := '1';
        elsif (vec = '0') then
            temp(1) := '0';
        elsif (vec = 'X') then
            temp(1) := 'X';
        elsif (vec = 'Z') then
            temp(1) := 'Z';
        elsif (vec = 'U') then
            temp(1) := 'U';
        elsif (vec = 'W') then
            temp(1) := 'W';
        elsif (vec = 'L') then
            temp(1) := 'L';
        elsif (vec = 'H') then
            temp(1) := 'H';
        else
            temp(1) := '-';
        end if;
        return temp;
    end;

    signal CLK    : std_logic := '0';
    signal OE     : std_logic := '1';
    signal UD     : std_logic := '1';
    signal ENT    : std_logic := '1';
    signal ENP    : std_logic := '1';
    signal SCLR   : std_logic := '1';
    signal LOAD   : std_logic := '1';
    signal ACLR   : std_logic := '1';
    signal Data   : std_logic_vector(7 downto 0) := "00000000";

    signal CCO_1  : std_logic;
    signal CCO_2  : std_logic;
    signal RCO_1  : std_logic;
    signal RCO_2  : std_logic;
    signal Q_ls   : std_logic_vector(3 downto 0);
    signal Q_ms   : std_logic_vector(3 downto 0);
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
        CCO_no_1 => CCO_1,
        CCO_no_2 => CCO_2,
        RCO_no_1 => RCO_1,
        RCO_no_2 => RCO_2,
        Q_ls_o   => Q_ls,
        Q_ms_o   => Q_ms
    );

    CLK <= not CLK after PERIOD/2;

    process
        file     vector_file     : text;
        variable vect            : std_logic_vector(20 downto 0);
        variable stimulus        : std_logic_vector(10 downto 0);
        variable expected        : std_logic_vector(9  downto 0);
        variable str_vector      : string          (21 downto 1);
        variable err_cnt         : integer := 0;
        variable file_line       : line;

        variable total_time      : time := 0 ns;
        variable wait_time       : time := 0 ns;
        variable OE_f            : std_logic := '1';
        variable UD_f            : std_logic := '1';
        variable ENT_f           : std_logic := '1';
        variable ENP_f           : std_logic := '1';
        variable SCLR_f          : std_logic := '1';
        variable LOAD_f          : std_logic := '1';
        variable ACLR_f          : std_logic := '0';
        variable Data_f          : std_logic_vector(7 downto 0) := "00000000";
        variable CCO_1_f         : std_logic;
        variable CCO_2_f         : std_logic;
        variable RCO_1_f         : std_logic;
        variable RCO_2_f         : std_logic;
        variable Q_ls_f          : std_logic_vector(3 downto 0);
        variable Q_ms_f          : std_logic_vector(3 downto 0);
        variable ok              : boolean := False;
        variable line_num        : integer := 0;
    begin
        -- file_open(vector_file, "D:/PRJ/vivado/Lab_2/src/sim/test_file.vec", READ_MODE);
        file_open(vector_file,
            "D:/PRJ/vivado/Lab_3/src/sim/test_file.dat",
            READ_MODE);

        wait until rising_edge(CLK);

        while not endfile(vector_file) loop
            line_num := line_num + 1;
            
            readline (vector_file, file_line);
            if file_line.all'length = 0 or file_line.all(1) = '#' then
                next;
            end if;

            read(file_line, wait_time, ok);
            assert ok report "Read 'wait_time' failed"
                        & ". Line: " & integer'image(line_num)
            severity ERROR;

            read(file_line, OE_f, ok);
            assert ok report "Read 'OE_f' failed"
                        & ". Line: " & integer'image(line_num)
            severity ERROR;

            read(file_line, UD_f, ok);
            assert ok report "Read 'UD_f' failed"
                        & ". Line: " & integer'image(line_num)
            severity ERROR;

            read(file_line, ENT_f, ok);
            assert ok report "Read 'ENT_f' failed"
                        & ". Line: " & integer'image(line_num)
            severity ERROR;

            read(file_line, ENP_f, ok);
            assert ok report "Read 'ENP_f' failed"
                        & ". Line: " & integer'image(line_num)
            severity ERROR;

            read(file_line, SCLR_f, ok);
            assert ok report "Read 'SCLR_f' failed"
                        & ". Line: " & integer'image(line_num)
            severity ERROR;

            read(file_line, LOAD_f, ok);
            assert ok report "Read 'LOAD_f' failed"
                        & ". Line: " & integer'image(line_num)
            severity ERROR;

            read(file_line, ACLR_f, ok);
            assert ok report "Read 'ACLR_f' failed"
                        & ". Line: " & integer'image(line_num)
            severity ERROR;

            read(file_line, Data_f, ok);
            assert ok report "Read 'Data_f' failed"
                        & ". Line: " & integer'image(line_num)
            severity ERROR;

            read(file_line, CCO_1_f, ok);
            assert ok report "Read 'CCO_1_f' failed"
                        & ". Line: " & integer'image(line_num)
            severity ERROR;

            read(file_line, CCO_2_f, ok);
            assert ok report "Read 'CCO_2_f' failed"
                        & ". Line: " & integer'image(line_num)
            severity ERROR;

            read(file_line, RCO_1_f, ok);
            assert ok report "Read 'RCO_1_f' failed"
                        & ". Line: " & integer'image(line_num)
            severity ERROR;

            read(file_line, RCO_2_f, ok);
            assert ok report "Read 'RCO_2_f' failed"
                        & ". Line: " & integer'image(line_num)
            severity ERROR;

            read(file_line, Q_ms_f, ok);
            assert ok report "Read 'Q_ms_f' failed"
                        & ". Line: " & integer'image(line_num)
            severity ERROR;

            read(file_line, Q_ls_f, ok);
            assert ok report "Read 'Q_ls_f' failed"
                        & ". Line: " & integer'image(line_num)
            severity ERROR;

            OE   <= OE_f;
            UD   <= UD_f;
            ENT  <= ENT_f;
            ENP  <= ENP_f;
            SCLR <= SCLR_f;
            LOAD <= LOAD_f;
            ACLR <= ACLR_f;
            Data <= Data_f;

            wait for 1 ns;

            assert (CCO_1 = CCO_1_f or CCO_1_f = '-')
                report "CCO_1 failed. "
                        & "Expected: " & logic2str(CCO_1_f)
                        & ". Actual: " & logic2str(CCO_1)
                        & ". Line: " & integer'image(line_num)
                severity ERROR;
            assert (CCO_2 = CCO_2_f or CCO_2_f = '-')
                report "CCO_2 failed. "
                        & "Expected: " & logic2str(CCO_2_f)
                        & ". Actual: " & logic2str(CCO_2)
                        & ". Line: " & integer'image(line_num)
                severity ERROR;
            assert (RCO_1 = RCO_1_f or RCO_1_f = '-')
                report "RCO_1 failed. "
                        & "Expected: " & logic2str(RCO_1_f)
                        & ". Actual: " & logic2str(RCO_1)
                        & ". Line: " & integer'image(line_num)
                severity ERROR;
            assert (RCO_2 = RCO_2_f or RCO_2_f = '-')
                report "RCO_2 failed. "
                        & "Expected: " & logic2str(RCO_2_f)
                        & ". Actual: " & logic2str(RCO_2)
                        & ". Line: " & integer'image(line_num)
                severity ERROR;
            assert (Q_ls = Q_ls_f or Q_ls_f = "----")
                report "Q_ls failed. "
                        & "Expected: " & vec2str(Q_ls_f)
                        & ". Actual: " & vec2str(Q_ls)
                        & ". Line: " & integer'image(line_num)
                severity ERROR;
            assert (Q_ms = Q_ms_f or Q_ms_f = "----")
                report "Q_ms failed. "
                        & "Expected: " & vec2str(Q_ms_f)
                        & ". Actual: " & vec2str(Q_ms)
                        & ". Line: " & integer'image(line_num)
                severity ERROR;

            wait for wait_time - 1 ns;
        end loop;

        wait;
    end process;

end Behavioral;
