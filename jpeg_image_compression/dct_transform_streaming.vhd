----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/30/2025 01:04:37 PM
-- Design Name: 
-- Module Name: dct_transform_streaming - rtl
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
use work.dct_package.ALL;
-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity dct_transform_streaming is
  Port (
    clk   : in std_logic;
    reset : in std_logic;
    
    pixel_in     : in std_logic_vector(7 downto 0);
    pixel_valid  : in std_logic;
    
    dct_coeff    : out std_logic_vector(15 downto 0);
    coeff_u      : out std_logic_vector(2 downto 0);
    coeff_v      : out std_logic_vector(2 downto 0);
    coeff_valid  : out std_logic;
    block_done   : out std_logic
   );
end dct_transform_streaming;

architecture rtl of dct_transform_streaming is

    signal pixel_count : integer range 0 to 63 := 0;
    signal row_idx     : integer range 0 to 7 := 0;
    signal col_idx     : integer range 0 to 7 := 0;
    
    signal dct_input_buf : cos_matrix := (others => (others => (others => '0')));
    signal dct_start     : std_logic := '0';
    signal dct_busy      : std_logic;
    signal dct_done      : std_logic;
    signal dct_out_matrix: cos_matrix;
    
    signal coeff_counter : integer range 0 to 63 := 0;
    signal output_u      : integer range 0 to 7 := 0;
    signal output_v      : integer range 0 to 7 := 0;
    
begin

     process(clk)
     begin
        if rising_edge(clk) then
            if reset = '1' then
                pixel_count <= 0;
                row_idx     <= 0;
                col_idx     <= 0;
            elsif pixel_valid = '1' then
                dct_input_buf(row_idx, col_idx) <= to_signed(to_integer(signed(pixel_in)) - 128, 16);  -- thresholding
                
                if col_idx = 7 then
                    col_idx <= 0;
                    if row_idx = 7 then
                        row_idx <= 0;
                        pixel_count <= 0;
                        dct_start <= '1';
                    else
                        row_idx <= row_idx + 1;
                    end if;
                 else
                    col_idx <= col_idx + 1;
                 end if;
                 pixel_count <= pixel_count + 1;
             else
                dct_start <= '0';
            end if;
        end if;
     end process;
     
    U_DCT : entity work.dct_transform
        port map(
            clk     => clk,
            reset   => reset,
            start   => dct_start,
            data_in => dct_input_buf,
            done    => dct_done,
            dct_out => dct_out_matrix
        );
     
     process(clk)
     begin
        if rising_edge(clk) then
            if reset = '1' then
                coeff_counter  <= 0;
                coeff_valid    <= '0';
                block_done     <= '0';
                
            elsif dct_done = '1' then
                if coeff_counter = 63 then
                    coeff_counter <= 0;
                    block_done    <= '1';
                else 
                    coeff_counter <= coeff_counter + 1;
                    block_done    <= '0';
                end if;
                
                output_u  <= coeff_counter / 8;
                output_v  <= coeff_counter mod 8;
                dct_coeff <= std_logic_vector(dct_out_matrix(output_u, output_v));
                coeff_valid <= '1';
             else
                coeff_valid <= '0';
                block_done  <= '0';
             end if;
         end if;
     end process;
     
     coeff_u <= std_logic_vector(to_unsigned(output_u, 3));
     coeff_v <= std_logic_vector(to_unsigned(output_v, 3));

end rtl;
