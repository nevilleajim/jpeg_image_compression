----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/14/2025 01:46:12 PM
-- Design Name: 
-- Module Name: zigzag_encoding - rtl
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: FIXED VERSION - Improved pipeline synchronization
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.02 - Fixed pipeline timing
-- Additional Comments:
-- CHANGES:
-- 1. Added quant_block input latching
-- 2. Improved state machine for better synchronization
-- 3. Added pipeline_valid signal to track when outputs are valid
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
use work.jpeg_type_pkg.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity zigzag_encoding is
  Port (
    clk          : in std_logic;
    reset        : in std_logic;
    
    start        : in std_logic;
    quant_block  : in block8x8;
    
    zigzag_valid : out std_logic;
    done         : out std_logic;
    zigzag_out   : out block64
   );
end zigzag_encoding;

architecture rtl of zigzag_encoding is
    
    type zigzag_array is array (0 to 63) of integer range 0 to 63;
    type state_type is (IDLE, PROCESSING, DONE_STATE);
    
    signal state           : state_type := IDLE;
    signal zigzag_cnt      : integer range 0 to 63;
    signal quant_block_buf : block8x8;
    signal pipeline_valid  : std_logic := '0';  
    
    constant ZIGZAG_INDEX : zigzag_array := (
        0,  1,  5,  6, 14, 15, 27, 28,
        2,  4,  7, 13, 16, 26, 29, 42,
        3,  8, 12, 17, 25, 30, 41, 43,
        9, 11, 18, 24, 31, 40, 44, 53,
       10, 19, 23, 32, 39, 45, 52, 54,
       20, 22, 33, 38, 46, 51, 55, 60,
       21, 34, 37, 47, 50, 56, 59, 61,
       35, 36, 48, 49, 57, 58, 62, 63
    );

begin
    
    zigzag_proc : process(clk)
        variable index : integer range 0 to 63;
        variable row   : integer range 0 to 7;
        variable col   : integer range 0 to 7;
        
    begin
        if rising_edge(clk) then
            if reset = '1' then
                state          <= IDLE;
                zigzag_cnt     <= 0;
                done           <= '0';
                zigzag_valid   <= '0';
                pipeline_valid <= '0';
                
                for i in 0 to 63 loop
                    zigzag_out(i) <= (others => '0');
                end loop;
             
             elsif start = '1' then
                quant_block_buf <= quant_block;
                state           <= PROCESSING;
                zigzag_cnt      <= 0;
                done            <= '0';
                zigzag_valid    <= '0';
                pipeline_valid  <= '1';
             
             elsif state = PROCESSING then
                index := ZIGZAG_INDEX(zigzag_cnt);
                row   := index / 8;
                col   := index mod 8;
                
                zigzag_out(zigzag_cnt) <= quant_block_buf(row, col);
                zigzag_valid           <= '1';
                
                if zigzag_cnt = 63 then
                    state          <= DONE_STATE;
                    zigzag_cnt     <= 0;
                    pipeline_valid <= '0';
                    done           <= '1';
                else 
                    zigzag_cnt <= zigzag_cnt + 1;
                    done       <= '0';
                end if;
            
             elsif state = DONE_STATE then
                done         <= '0';
                zigzag_valid <= '0';
                state        <= IDLE;
                 
             else 
                zigzag_valid <= '0';
                done         <= '0';
                pipeline_valid <= '0';
             end if;
        end if;
     end process zigzag_proc;

end rtl;