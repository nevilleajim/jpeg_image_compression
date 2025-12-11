----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/21/2025 01:03:43 PM
-- Design Name: 
-- Module Name: conversion_tb - rtl
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
use STD.TEXTIO.ALL;
use IEEE.STD_LOGIC_TEXTIO.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity conversion_tb is
--  Port ( );
end conversion_tb;

architecture rtl of conversion_tb is

    signal R, G, B   : std_logic_vector(7 downto 0) := (others => '0');
    signal Cb, Cr, Y : std_logic_vector(7 downto 0);
    signal clk       : std_logic := '0';
    signal reset     : std_logic := '0';
    signal p_valid   : std_logic := '0';
    signal i_valid   : std_logic := '0';
    
    constant LOW_CYCLE  : integer := 8;
    constant HIGH_CYCLE : integer := 8;
    
    constant Width  : integer := 8;
    constant Height : integer := 8;
    constant PIXELS : integer := Width * Height;

    type pixel_array is array (0 to PIXELS-1) of std_logic_vector(7 downto 0);
    signal red_data, green_data, blue_data : pixel_array;
    
    file red_file   : text open read_mode is "C:/Users/hp/Documents/FGPA/mini_project/python_implementation/red_channel.txt";
    file green_file : text open read_mode is "C:/Users/hp/Documents/FGPA/mini_project/python_implementation/green_channel.txt";
    file blue_file  : text open read_mode is "C:/Users/hp/Documents/FGPA/mini_project/python_implementation/blue_channel.txt";
    
    component rgb_to_ycbcr_converter 
        port(
            clk     : in std_logic;
            reset   : in std_logic;
            R       : in std_logic_vector(7 downto 0);
            G       : in std_logic_vector(7 downto 0);
            B       : in std_logic_vector(7 downto 0);
            p_valid : in std_logic;
            i_valid : in std_logic;
            Y       : out std_logic_vector(7 downto 0);
            Cb      : out std_logic_vector(7 downto 0);
            Cr      : out std_logic_vector(7 downto 0)
        );
    end component;
    
begin

    DUT : rgb_to_ycbcr_converter
        port map(
            clk     => clk,
            reset   => reset,
            R       => R,
            G       => G,
            B       => B,
            p_valid => p_valid,
            i_valid => i_valid,
            Y       => Y,
            Cb      => Cb,
            Cr      => Cr
        );
     
     clk_process : process
        begin
            clk <= '0';
            wait for 10ns;
            
            clk <= '1';
            wait for 10ns; 
            
     end process clk_process;
      
     reset_process : process
        begin
            reset <= '1';
            wait until rising_edge(clk);
            
            reset <= '0';          
            wait;
     
     end process reset_process;

    read_files_proc : process
        variable L : line;
        variable value_int : integer;
    begin
        for i in 0 to PIXELS-1 loop
            if endfile(red_file) then
                exit;
            end if;
            readline(red_file, L);
            read(L, value_int);
            red_data(i) <= std_logic_vector(to_unsigned(value_int, 8));
        end loop;

        for i in 0 to PIXELS-1 loop
            if endfile(green_file) then
                exit;
            end if;
            readline(green_file, L);
            read(L, value_int);
            green_data(i) <= std_logic_vector(to_unsigned(value_int, 8));
        end loop;

        for i in 0 to PIXELS-1 loop
            if endfile(blue_file) then
                exit;
            end if;
            readline(blue_file, L);
            read(L, value_int);
            blue_data(i) <= std_logic_vector(to_unsigned(value_int, 8));
        end loop;

        report "Image data successfully loaded.";
        wait;
    end process read_files_proc;

     
     stim_process : process
        begin
            wait until rising_edge(clk);
            
            for k in 1 to 5 loop
                p_valid <= '0';
                wait until rising_edge(clk);
            end loop;
            
            p_valid <= '0';
            i_valid <= '1';
            wait until rising_edge(clk);
               
            i_valid <= '1';
            
            for i in 0 to 3 loop
                p_valid <= '1';
                for i in 0 to PIXELS-1 loop  
                    for j in 1 to HIGH_CYCLE loop 
                        p_valid <= '1';                 
                        if p_valid = '1' then
                            R <= red_data(i);
                            G <= green_data(i);
                            B <= blue_data(i);
                        end if;        
                    wait until rising_edge(clk);
                end loop;
                
                for j in 1 to LOW_CYCLE loop
                    p_valid <= '0';
                    wait until rising_edge(clk);
                end loop;
                end loop;
            end loop;
            
            i_valid <= '0';
            p_valid <= '0';
            
            wait;
            
     end process stim_process; 

end rtl;
