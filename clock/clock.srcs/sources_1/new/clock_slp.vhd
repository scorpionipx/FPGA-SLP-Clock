----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/08/2019 12:14:53 PM
-- Design Name: 
-- Module Name: clock_slp - Behavioral
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
use IEEE.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity clock_slp is
    Port ( CLK100MHZ : in STD_LOGIC;
           SW : in STD_LOGIC_VECTOR (1 downto 0);
           BTNC : in STD_LOGIC;
           BTNU : in STD_LOGIC;
           BTNL : in STD_LOGIC;
           BTNR : in STD_LOGIC;
           BTND : in STD_LOGIC;
           SEGMENT : out STD_LOGIC_VECTOR (6 downto 0);
           DIGIT : out STD_LOGIC_VECTOR (3 downto 0);
           LED : out STD_LOGIC_VECTOR (15 downto 0));
end clock_slp;

architecture Behavioral of clock_slp is

signal clock_rising_edge_counter: STD_LOGIC_VECTOR (27 downto 0);
signal digit_change_counter: STD_LOGIC_VECTOR (19 downto 0);
signal seconds_counter: STD_LOGIC_VECTOR (27 downto 0) := "0000000000000000000000000000";
signal digit_selector: STD_LOGIC_VECTOR (1 downto 0) := "00";

signal S0: STD_LOGIC_VECTOR (3 downto 0) := "0000";
signal S1: STD_LOGIC_VECTOR (3 downto 0) := "0000";

signal M0: STD_LOGIC_VECTOR (3 downto 0) := "1000";
signal M1: STD_LOGIC_VECTOR (3 downto 0) := "0101";

signal H0: STD_LOGIC_VECTOR (3 downto 0) := "1001";
signal H1: STD_LOGIC_VECTOR (3 downto 0) := "0001";
signal SETTINGS: STD_LOGIC;

constant DIGIT_0: STD_LOGIC_VECTOR (3 downto 0) := "1110";
constant DIGIT_1: STD_LOGIC_VECTOR (3 downto 0) := "1101";
constant DIGIT_2: STD_LOGIC_VECTOR (3 downto 0) := "1011";
constant DIGIT_3: STD_LOGIC_VECTOR (3 downto 0) := "0111";

constant SEGMENT_0: STD_LOGIC_VECTOR (6 downto 0) := "1000000";
constant SEGMENT_1: STD_LOGIC_VECTOR (6 downto 0) := "1111001";
constant SEGMENT_2: STD_LOGIC_VECTOR (6 downto 0) := "0100100";
constant SEGMENT_3: STD_LOGIC_VECTOR (6 downto 0) := "0110000";
constant SEGMENT_4: STD_LOGIC_VECTOR (6 downto 0) := "0011001";
constant SEGMENT_5: STD_LOGIC_VECTOR (6 downto 0) := "0010010";
constant SEGMENT_6: STD_LOGIC_VECTOR (6 downto 0) := "0000010";
constant SEGMENT_7: STD_LOGIC_VECTOR (6 downto 0) := "1111000";
constant SEGMENT_8: STD_LOGIC_VECTOR (6 downto 0) := "0000000";
constant SEGMENT_9: STD_LOGIC_VECTOR (6 downto 0) := "0010000";

constant ONE_SECOND: STD_LOGIC_VECTOR (27 downto 0)       := "0101111101011110000011111111";
constant ONE_SECOND_4: STD_LOGIC_VECTOR (27 downto 0)     := "0001011111010111100000111111";
constant ONE_SECOND_10: STD_LOGIC_VECTOR (27 downto 0)    := "0000100110001001011000011100";
constant ONE_SECOND_100: STD_LOGIC_VECTOR (27 downto 0)   := "0000000011110100001000110110";
constant ONE_SECOND_1000: STD_LOGIC_VECTOR (27 downto 0)  := "0000000000011000011010011111";
signal ONE_SECOND_DIVIDED: STD_LOGIC_VECTOR (27 downto 0) := "0000000000001110000011111111";
signal CLOCK_DIVIDER: STD_LOGIC_VECTOR (1 downto 0) := "00";

begin

SETTINGS <= BTND;

process(SW, SETTINGS)
begin
    if SETTINGS = '1' then
            ONE_SECOND_DIVIDED <= ONE_SECOND_4;
    else
        case SW is
            when "00" =>
            ONE_SECOND_DIVIDED <= ONE_SECOND;
            when "01" =>
            ONE_SECOND_DIVIDED <= ONE_SECOND_10;
            when "10" =>
            ONE_SECOND_DIVIDED <= ONE_SECOND_100;
            when "11" =>
            ONE_SECOND_DIVIDED <= ONE_SECOND_1000;
        end case;
    end if;
end process;

--process(BTNC)
--begin
--    if rising_edge(BTNC) then
--        if SETTINGS = '1' then
--            SETTINGS <= '0';
--        else
--            SETTINGS <= '1';
--        end if;
--    end if;
--end process;

process(CLK100MHZ)
begin 
    if(rising_edge(CLK100MHZ)) then
        clock_rising_edge_counter <= clock_rising_edge_counter + 1;
        digit_change_counter <= digit_change_counter + 1;
        seconds_counter <= seconds_counter + 1;
        if H1 = "0010" then
            if H0 = "0101" or H0 = "0110" or H0 = "0111" or H0 = "1000" or H0 = "1001" or H0 = "0100" then
                H1 <= "0000";
                H0 <= "0000";
            end if;
        end if;
        if H1 = "0011" or H1 = "0100" or H1 = "0101" or H1 = "0110" or H1 = "0111" or H1 = "1001" or H1 = "1000" then
            H1 <= "0000";
            H0 <= "0000";
        end if;
        if S0 = "1010" then
            S0 <= "0000";
            S1 <= S1 + 1;
        end if;
        if S1 = "0110" then
            S1 <= "0000";
            M0 <= M0 + 1;
        end if;
        if M0 = "1010" then
            M0 <= "0000";
            M1 <= M1 + 1;
        end if;
        if M1 = "0110" then
            M1 <= "0000";
            H0 <= H0 + 1;
            if H0 = "0011" and H1 = "0010" then
                H0 <= "0000";
                H1 <= "0000";
            end if;
        end if;
        if H0 = "1010" then
            H0 <= "0000";
            H1 <= H1 + 1;
        end if;
        if seconds_counter = ONE_SECOND_DIVIDED then
            seconds_counter <= "0000000000000000000000000000";
            if SETTINGS = '1' then
                if BTNR = '1' then
                    M0 <= M0 + 1;
                end if;
                if BTNL = '1' then
                    H0 <= H0 + 1;
                end if;
            else
                S0 <= S0 + 1;
            end if;
        end if;
    end if;
end process;

digit_selector <= digit_change_counter(19 downto 18); 

process(digit_selector)
begin
    case digit_selector is
  when "00" =>
        DIGIT <= DIGIT_0;
        case M0 is
            when "0000" =>
            SEGMENT <= SEGMENT_0;
            when "0001" =>
            SEGMENT <= SEGMENT_1;
            when "0010" =>
            SEGMENT <= SEGMENT_2;
            when "0011" =>
            SEGMENT <= SEGMENT_3;
            when "0100" =>
            SEGMENT <= SEGMENT_4;
            when "0101" =>
            SEGMENT <= SEGMENT_5;
            when "0110" =>
            SEGMENT <= SEGMENT_6;
            when "0111" =>
            SEGMENT <= SEGMENT_7;
            when "1000" =>
            SEGMENT <= SEGMENT_8;
            when "1001" =>
            SEGMENT <= SEGMENT_9;
            when others =>
            SEGMENT <= "1010101";
        end case;
    when "01" =>
        DIGIT <= DIGIT_1; 
        case M1 is
            when "0000" =>
            SEGMENT <= SEGMENT_0;
            when "0001" =>
            SEGMENT <= SEGMENT_1;
            when "0010" =>
            SEGMENT <= SEGMENT_2;
            when "0011" =>
            SEGMENT <= SEGMENT_3;
            when "0100" =>
            SEGMENT <= SEGMENT_4;
            when "0101" =>
            SEGMENT <= SEGMENT_5;
            when "0110" =>
            SEGMENT <= SEGMENT_6;
            when "0111" =>
            SEGMENT <= SEGMENT_7;
            when "1000" =>
            SEGMENT <= SEGMENT_8;
            when "1001" =>
            SEGMENT <= SEGMENT_9;
            when others =>
            SEGMENT <= "1010101";
        end case;
    when "10" =>
        DIGIT <= DIGIT_2; 
        case H0 is
            when "0000" =>
            SEGMENT <= SEGMENT_0;
            when "0001" =>
            SEGMENT <= SEGMENT_1;
            when "0010" =>
            SEGMENT <= SEGMENT_2;
            when "0011" =>
            SEGMENT <= SEGMENT_3;
            when "0100" =>
            SEGMENT <= SEGMENT_4;
            when "0101" =>
            SEGMENT <= SEGMENT_5;
            when "0110" =>
            SEGMENT <= SEGMENT_6;
            when "0111" =>
            SEGMENT <= SEGMENT_7;
            when "1000" =>
            SEGMENT <= SEGMENT_8;
            when "1001" =>
            SEGMENT <= SEGMENT_9;
            when others =>
            SEGMENT <= "1010101";
        end case;
    when "11" =>
        DIGIT <= DIGIT_3; 
        case H1 is
            when "0000" =>
            SEGMENT <= SEGMENT_0;
            when "0001" =>
            SEGMENT <= SEGMENT_1;
            when "0010" =>
            SEGMENT <= SEGMENT_2;
            when "0011" =>
            SEGMENT <= SEGMENT_3;
            when "0100" =>
            SEGMENT <= SEGMENT_4;
            when "0101" =>
            SEGMENT <= SEGMENT_5;
            when "0110" =>
            SEGMENT <= SEGMENT_6;
            when "0111" =>
            SEGMENT <= SEGMENT_7;
            when "1000" =>
            SEGMENT <= SEGMENT_8;
            when "1001" =>
            SEGMENT <= SEGMENT_9;
            when others =>
            SEGMENT <= "1010101";
        end case;
    end case;
end process;

end Behavioral;
