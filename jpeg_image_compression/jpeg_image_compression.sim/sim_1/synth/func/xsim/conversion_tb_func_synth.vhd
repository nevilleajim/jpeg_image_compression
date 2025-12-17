-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2018.3.1 (win64) Build 2489853 Tue Mar 26 04:20:25 MDT 2019
-- Date        : Wed Dec 17 13:55:12 2025
-- Host        : DESKTOP-I7K0TLI running 64-bit major release  (build 9200)
-- Command     : write_vhdl -mode funcsim -nolib -force -file
--               C:/Users/hp/Documents/FGPA/mini_project/jpeg_image_compression/jpeg_image_compression.sim/sim_1/synth/func/xsim/conversion_tb_func_synth.vhd
-- Design      : top_level
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xc7z020clg484-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity top_level is
  port (
    clk : in STD_LOGIC;
    reset : in STD_LOGIC;
    R : in STD_LOGIC_VECTOR ( 7 downto 0 );
    G : in STD_LOGIC_VECTOR ( 7 downto 0 );
    B : in STD_LOGIC_VECTOR ( 7 downto 0 );
    p_valid : in STD_LOGIC;
    i_valid : in STD_LOGIC;
    dct_coeff : out STD_LOGIC_VECTOR ( 15 downto 0 );
    coeff_u : out STD_LOGIC_VECTOR ( 2 downto 0 );
    coeff_v : out STD_LOGIC_VECTOR ( 2 downto 0 );
    coeff_valid : out STD_LOGIC;
    block_done : out STD_LOGIC
  );
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of top_level : entity is true;
  attribute DATA_WIDTH : integer;
  attribute DATA_WIDTH of top_level : entity is 8;
  attribute LINE_LENGTH : integer;
  attribute LINE_LENGTH of top_level : entity is 256;
end top_level;

architecture STRUCTURE of top_level is
begin
block_done_OBUF_inst: unisim.vcomponents.OBUFT
     port map (
      I => '0',
      O => block_done,
      T => '1'
    );
\coeff_u_OBUF[0]_inst\: unisim.vcomponents.OBUF
     port map (
      I => '0',
      O => coeff_u(0)
    );
\coeff_u_OBUF[1]_inst\: unisim.vcomponents.OBUF
     port map (
      I => '0',
      O => coeff_u(1)
    );
\coeff_u_OBUF[2]_inst\: unisim.vcomponents.OBUF
     port map (
      I => '0',
      O => coeff_u(2)
    );
\coeff_v_OBUF[0]_inst\: unisim.vcomponents.OBUF
     port map (
      I => '0',
      O => coeff_v(0)
    );
\coeff_v_OBUF[1]_inst\: unisim.vcomponents.OBUF
     port map (
      I => '0',
      O => coeff_v(1)
    );
\coeff_v_OBUF[2]_inst\: unisim.vcomponents.OBUF
     port map (
      I => '0',
      O => coeff_v(2)
    );
coeff_valid_OBUF_inst: unisim.vcomponents.OBUF
     port map (
      I => '0',
      O => coeff_valid
    );
\dct_coeff_OBUF[0]_inst\: unisim.vcomponents.OBUF
     port map (
      I => '0',
      O => dct_coeff(0)
    );
\dct_coeff_OBUF[10]_inst\: unisim.vcomponents.OBUF
     port map (
      I => '0',
      O => dct_coeff(10)
    );
\dct_coeff_OBUF[11]_inst\: unisim.vcomponents.OBUF
     port map (
      I => '0',
      O => dct_coeff(11)
    );
\dct_coeff_OBUF[12]_inst\: unisim.vcomponents.OBUF
     port map (
      I => '0',
      O => dct_coeff(12)
    );
\dct_coeff_OBUF[13]_inst\: unisim.vcomponents.OBUF
     port map (
      I => '0',
      O => dct_coeff(13)
    );
\dct_coeff_OBUF[14]_inst\: unisim.vcomponents.OBUF
     port map (
      I => '0',
      O => dct_coeff(14)
    );
\dct_coeff_OBUF[15]_inst\: unisim.vcomponents.OBUF
     port map (
      I => '0',
      O => dct_coeff(15)
    );
\dct_coeff_OBUF[1]_inst\: unisim.vcomponents.OBUF
     port map (
      I => '0',
      O => dct_coeff(1)
    );
\dct_coeff_OBUF[2]_inst\: unisim.vcomponents.OBUF
     port map (
      I => '0',
      O => dct_coeff(2)
    );
\dct_coeff_OBUF[3]_inst\: unisim.vcomponents.OBUF
     port map (
      I => '0',
      O => dct_coeff(3)
    );
\dct_coeff_OBUF[4]_inst\: unisim.vcomponents.OBUF
     port map (
      I => '0',
      O => dct_coeff(4)
    );
\dct_coeff_OBUF[5]_inst\: unisim.vcomponents.OBUF
     port map (
      I => '0',
      O => dct_coeff(5)
    );
\dct_coeff_OBUF[6]_inst\: unisim.vcomponents.OBUF
     port map (
      I => '0',
      O => dct_coeff(6)
    );
\dct_coeff_OBUF[7]_inst\: unisim.vcomponents.OBUF
     port map (
      I => '0',
      O => dct_coeff(7)
    );
\dct_coeff_OBUF[8]_inst\: unisim.vcomponents.OBUF
     port map (
      I => '0',
      O => dct_coeff(8)
    );
\dct_coeff_OBUF[9]_inst\: unisim.vcomponents.OBUF
     port map (
      I => '0',
      O => dct_coeff(9)
    );
end STRUCTURE;
