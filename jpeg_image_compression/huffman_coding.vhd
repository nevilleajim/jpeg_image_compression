----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/07/2025 02:13:07 PM
-- Design Name: 
-- Module Name: huffman_coding - rtl
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
use work.jpeg_type_pkg.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity huffman_coding is
  Port (
    clk          : in std_logic;
    reset        : in std_logic;
    
    start        : in std_logic;
    block_in     : in block64;
    
    stream_out   : out std_logic_vector(255 downto 0);
    valid        : out std_logic;
    finish       : out std_logic
   );
end huffman_coding;

architecture rtl of huffman_coding is

    signal last_dc_reg : integer := 0;   
    
begin
    main_proc : process(clk)
        variable acc        : std_logic_vector(255 downto 0);
        variable bit_pos    : integer range 0 to 255;
        variable v_dc_diff  : integer;
        variable v_dc_cat   : integer;
        variable v_dc_hlen  : integer;
        variable v_dc_vbits : std_logic_vector(14 downto 0);
        
        variable coeff      : integer;
        variable cat        : integer;
        variable run        : integer range 0 to 15;
        variable hlen       : integer;
        variable vbits      : std_logic_vector(14 downto 0);
        
        procedure write_bits(
            src     : in std_logic_vector;
            nbits   : in integer;
            pos     : inout integer
        ) is 
            variable ext        : unsigned(255 downto 0);
            variable shift      : integer;
        begin
            if nbits = 0 then
                return;
            end if;
            ext     := resize(unsigned(src), 256);
            shift   := pos - nbits + 1;
            
            if shift >= 0 then
                ext := shift_left(ext, shift);
            else
                ext := shift_right(ext, -shift);
            end if;
            acc     := acc or std_logic_vector(ext);
            pos     := pos - nbits;
        end procedure;
        
        begin
        if rising_edge(clk) then
            if reset = '1' then
                stream_out  <= (others => '0');
                valid       <= '0';
                finish      <= '0';
                last_dc_reg <= 0;
 
            elsif start = '1' then
 
                -- --------------------------------------------------------
                -- Initialise accumulator and bit pointer
                -- --------------------------------------------------------
                acc     := (others => '0');
                bit_pos := 255;
 
                -- --------------------------------------------------------
                -- DC coefficient (differential coding)
                -- --------------------------------------------------------
                v_dc_diff  := to_integer(block_in(0)) - last_dc_reg;
                v_dc_cat   := category(v_dc_diff);
                v_dc_hlen  := DC_LUMA_HUFF(v_dc_cat).length;
                v_dc_vbits := value_bits(v_dc_diff, v_dc_cat);
 
                -- Write Huffman code for DC category
                write_bits(DC_LUMA_HUFF(v_dc_cat).code, v_dc_hlen, bit_pos);
 
                -- Write magnitude bits (value_bits already MSB-aligned in
                -- its 15-bit result, but write_bits treats them as a plain
                -- integer so we strip the alignment and use cat as the count)
                write_bits(v_dc_vbits, v_dc_cat, bit_pos);
 
                -- --------------------------------------------------------
                -- AC coefficients (run-length / category coding)
                -- --------------------------------------------------------
                run := 0;
 
                for idx in 1 to 63 loop
                    coeff := to_integer(block_in(idx));
 
                    if coeff = 0 then
                        run := run + 1;
 
                        -- ZRL: 16 consecutive zeros ? emit ZRL code, reset run
                        if run = 16 then
                            hlen := AC_LUMA_HUFF(15, 0).length;
                            write_bits(AC_LUMA_HUFF(15, 0).code, hlen, bit_pos);
                            run := 0;
                        end if;
 
                    else
                        cat   := category(coeff);
                        vbits := value_bits(coeff, cat);
 
                        -- Huffman code for (run, cat)
                        hlen := AC_LUMA_HUFF(run, cat).length;
                        write_bits(AC_LUMA_HUFF(run, cat).code, hlen, bit_pos);
 
                        -- Magnitude bits
                        write_bits(vbits, cat, bit_pos);
 
                        run := 0;
                    end if;
                end loop;
 
                -- EOB: if there are trailing zeros, emit End-Of-Block
                if run > 0 then
                    hlen := AC_LUMA_HUFF(0, 0).length;
                    write_bits(AC_LUMA_HUFF(0, 0).code, hlen, bit_pos);
                end if;
 
                -- --------------------------------------------------------
                -- Commit results
                -- --------------------------------------------------------
                last_dc_reg <= to_integer(block_in(0));
                stream_out  <= acc;
                valid       <= '1';
                finish      <= '1';
 
            else
                -- De-assert strobes when start is not asserted
                valid  <= '0';
                finish <= '0';
 
            end if;
        end if;
    end process main_proc;           

end rtl;
