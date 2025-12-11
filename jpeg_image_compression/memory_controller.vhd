----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/30/2025 12:42:54 PM
-- Design Name: 
-- Module Name: memory_controller - rtl
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
--use IEEE.MATH_REAL.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity memory_controller is
    generic (
       DATA_WIDTH  : integer := 8;
       LINE_LENGTH : integer := 256
    );
    port(
       clk         : in std_logic;
       reset       : in std_logic;
       
       pixel_in    : in std_logic_vector(DATA_WIDTH-1 downto 0);
       p_valid     : in std_logic;
       i_valid     : in std_logic;
       
       pixel_out   : out std_logic_vector((DATA_WIDTH*8)-1 downto 0);
       pixel_valid : out std_logic
    );
end memory_controller;

architecture rtl of memory_controller is
    signal state          : std_logic_vector(1 downto 0);
    constant RESET_ST     : std_logic_vector(1 downto 0) := "00";
    constant WAIT_FRAME   : std_logic_vector(1 downto 0) := "01";
    constant WAIT_PIXELS  : std_logic_vector(1 downto 0) := "10";
    constant WRITE        : std_logic_vector(1 downto 0) := "11";

    signal ram_we         : std_logic_vector(7 downto 0);
    signal ram_addr_wr    : std_logic_vector(7 downto 0);
    signal ram_addr_rd    : std_logic_vector(7 downto 0);
    signal ram_dout       : std_logic_vector(63 downto 0);
    
    signal block_index    : unsigned(2 downto 0) := (others => '0');
    signal line_addr      : unsigned(7 downto 0) := (others => '0');
         
    signal block_row      : unsigned(7 downto 0) := (others => '0');
    signal block_col      : unsigned(2 downto 0) := "000";
    
    signal i_valid_prev   : std_logic := '0';
    signal i_valid_rise   : std_logic := '0';

begin

    RAMS: for i in 0 to 7 generate
     U_RAM : entity work.simple_dual_ram
     generic map (
         DATA_WIDTH => 8,
         ADDR_WIDTH => 8
     )
     port map (
         clk     => clk,
         write_a => ram_we(i),
         addr_a  => ram_addr_wr,
         din_a   => pixel_in,
         addr_b  => ram_addr_rd, 
         dout_b  => ram_dout(8*(i+1)-1 downto 8*i)
     );
    end generate;
    
    edge_detector_proc : process(clk)
    begin
        if rising_edge(clk) then
            i_valid_prev  <= i_valid;
            i_valid_rise  <= i_valid and not i_valid_prev;
        end if;
    end process;

    fsm : process (clk)
     begin
        if rising_edge(clk) then
            if reset = '1' then
                state <= RESET_ST; 
            else 
                case state is
                    when RESET_ST    => state <= WAIT_FRAME;
                    when WAIT_FRAME  => if i_valid_rise = '1' then 
                                            state <= WAIT_PIXELS;    
                                        end if;
                    when WAIT_PIXELS => if p_valid = '1' then 
                                            state <= WRITE; 
                                        end if;
                    when WRITE       => if p_valid = '0' then 
                                            state <= WAIT_PIXELS; 
                                        end if;
                    when others      => state <= RESET_ST;
                end case;
            end if;
        end if;
     end process;
     
    counters : process(clk)
     begin
        if rising_edge(clk) then
            if reset = '1' or state = RESET_ST or i_valid = '1' then
                block_index  <= (others => '0');
                line_addr    <= (others => '0');
            elsif state = WRITE and p_valid = '1' then
                if block_index = 7 then
                    block_index <= (others => '0');
                else
                    block_index <= block_index + 1;
                end if;
            
                if block_index = 7 then
                    line_addr <= line_addr + 1;
                end if;
            end if;
        end if;
     end process;
     
     we_gen: for i in 0 to 7 generate
        ram_we(i) <= '1' when (state = WRITE and p_valid = '1' and block_index = to_unsigned(i, 3)) else '0';
     end generate;
     
     ram_addr_wr <= std_logic_vector(line_addr);
     
     read_ram : process(clk)
     begin
        if rising_edge(clk) then
            if reset = '1' then
                block_row     <= (others => '0');
                block_col     <= "000";
                pixel_valid   <= '0';
            else
                pixel_valid   <= '1';
                
                if block_col = 7 and block_row = 255 then
                    block_row <= (others => '0');
                    block_col <= "000";
                elsif block_col = 7 then
                    block_row <= block_row + 1;
                    block_col <= "000";
                else
                    block_col <= block_col + 1;
                end if;
            end if;
         end if;
     
     end process;
     
     ram_addr_rd <= std_logic_vector(block_row);
     pixel_out   <= ram_dout(8 * to_integer(block_col)+7 downto 8 * to_integer(block_col));

end rtl;
