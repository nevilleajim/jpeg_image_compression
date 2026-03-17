-- Company:
-- Engineer:
-- Create Date: 01/20/2026 05:21:47 PM
-- Design Name:
-- Module Name: top_module_jpeg_compression_tb - rtl
-- Project Name:
-- Target Devices:
-- Tool Versions:
-- Description:
-- Dependencies:
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;
use STD.TEXTIO.ALL;
use IEEE.STD_LOGIC_TEXTIO.ALL;
use work.dct_package.ALL;
use work.jpeg_type_pkg.ALL;
-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
entity top_module_jpeg_compression_tb is
-- Port ( );
end top_module_jpeg_compression_tb;
architecture rtl of top_module_jpeg_compression_tb is
    signal clk          : std_logic := '0';
    signal reset        : std_logic := '1';
    signal R            : std_logic_vector(7 downto 0) := (others => '0');
    signal G            : std_logic_vector(7 downto 0) := (others => '0');
    signal B            : std_logic_vector(7 downto 0) := (others => '0');
    signal p_valid      : std_logic := '0';
    signal i_valid      : std_logic := '0';
    signal start        : std_logic := '0';
--    signal quant_block  : block8x8;
--    signal block_in     : block64;
   
    signal zigzag_valid : std_logic;
    signal done         : std_logic;
    signal zigzag_out   : block64;
    signal data_loaded  : std_logic := '0';
   
    constant Width      : integer := 8;
    constant Height     : integer := 8;
    constant PIXELS     : integer := Width * Height;
    
    type pixel_array is array (0 to PIXELS-1) of std_logic_vector(7 downto 0);
--    signal red_data, green_data, blue_data : pixel_array;
    
    component top_module_jpeg_compression
    port (
        clk : in std_logic;
        reset : in std_logic;
       
        R : in std_logic_vector(7 downto 0);
        G : in std_logic_vector(7 downto 0);
        B : in std_logic_vector(7 downto 0);
        
        p_valid : in std_logic;
        i_valid : in std_logic;
       
        start : in std_logic;
-- quant_block : in block8x8;
-- block_in : in block64;
        zigzag_valid : out std_logic;
        done : out std_logic;
        zigzag_out : out block64
    );
    end component;
    begin
    U_TOPMODULE: top_module_jpeg_compression
    port map (
        clk => clk,
        reset => reset,
        R => R,
        G => G,
        B => B,
        p_valid => p_valid,
        i_valid => i_valid,
        start => start,
        zigzag_valid => zigzag_valid,
        done => done,
        zigzag_out => zigzag_out
    );
   
    reset_proc: process
    begin
        reset <= '1';
        wait for 20ns;
       
        reset <= '0';     
        wait;
    end process reset_proc;
   
    clock_proc: process
    begin
        while true loop
            clk <= '0';
            wait for 5ns;
           
            clk <= '1';
            wait for 5ns;
        end loop;
    end process clock_proc;
   
    stim_process: process
    variable L          : line;
    variable value_int  : integer;
    variable r_var      : pixel_array;
    variable g_var      : pixel_array;
    variable b_var      : pixel_array;
    file red_file       : text open read_mode is "C:/Users/hp/Documents/FGPA/mini_project/python_implementation/red_channel.txt";
    file green_file     : text open read_mode is "C:/Users/hp/Documents/FGPA/mini_project/python_implementation/green_channel.txt";
    file blue_file      : text open read_mode is "C:/Users/hp/Documents/FGPA/mini_project/python_implementation/blue_channel.txt";
    file zigzag_file    : text open write_mode is "C:/Users/hp/Documents/FGPA/mini_project/python_implementation/zigzag_output.txt";
   
    begin
        for i in 0 to PIXELS-1 loop
            readline(red_file, L); read(L, value_int);
            r_var(i)    := std_logic_vector(to_unsigned(value_int, 8));
        end loop;
        for i in 0 to PIXELS-1 loop
            readline(green_file, L); read(L, value_int);
            g_var(i)    := std_logic_vector(to_unsigned(value_int, 8));
        end loop;
        for i in 0 to PIXELS-1 loop
            readline(blue_file, L); read(L, value_int);
            b_var(i)    := std_logic_vector(to_unsigned(value_int, 8));
        end loop;
        
        wait until reset = '0';
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        
        i_valid     <= '1';
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        
        outer: loop
            for j in 0 to PIXELS-1 loop
                R       <= r_var(j);
                G       <= g_var(j);
                B       <= b_var(j);
                p_valid <= '1';
                wait until rising_edge(clk);
                exit outer when done = '1';
            end loop;
        end loop outer;
        
        p_valid     <= '1';
        while done /= '1' loop
            for j in 0 to PIXELS-1 loop
                R       <= r_var(j);
                G       <= g_var(j);
                B       <= b_var(j);
                p_valid <= '1';
                wait until rising_edge(clk);
                exit when done = '1';
            end loop;
        end loop;
        
        p_valid <= '0';
        i_valid <= '0';
        wait until rising_edge(clk);
        
        for i in 0 to 63 loop
            write(L, to_integer(signed(zigzag_out(i))));
            writeline(zigzag_file, L);
        end loop;
        
        report "JPEG Block Completed";
        wait;
    end process stim_process;
end rtl;