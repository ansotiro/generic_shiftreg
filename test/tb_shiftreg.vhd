----------------------------------------------------------------------------------
--                 ________  __       ___  _____        __
--                /_  __/ / / / ___  / _/ / ___/______ / /____
--                 / / / /_/ / / _ \/ _/ / /__/ __/ -_) __/ -_)
--                /_/  \____/  \___/_/   \___/_/  \__/\__/\__/
--
----------------------------------------------------------------------------------
--
-- Author(s):   ansotiropoulos
--
-- Design Name: generic_shiftreg
-- Module Name: tb_shiftreg
--
-- Description: Testbench for generic SHIFTREG
--
-- Copyright:   (C) 2016 Microprocessor & Hardware Lab, TUC
--
-- This source file is free software; you can redistribute it and/or modify
-- it under the terms of the GNU Lesser General Public License as published
-- by the Free Software Foundation; either version 2.1 of the License, or
-- (at your option) any later version.
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;
use std.textio.all;


entity tb_shiftreg is
end tb_shiftreg;

architecture behavior of tb_shiftreg is

component SHIFTREG
generic (
    W       : integer := 8;
    N       : integer := 4
);
PORT(
    CLK     : in  std_logic;
    RST     : in  std_logic;
    EN      : in  std_logic;
    D       : in  std_logic_vector(7 downto 0);
    Q       : out std_logic_vector(7 downto 0)
);
end component;

procedure printf_slv (dat : in std_logic_vector (7 downto 0); file f: text) is
    variable my_line : line;
begin
    write(my_line, CONV_INTEGER(dat));
    write(my_line, string'(" -   ("));
    write(my_line, now);
    write(my_line, string'(")"));
    writeline(f, my_line);
end procedure printf_slv;

file file_q : text open WRITE_MODE is "out/test_d.out";

constant CLK_period : time := 10 ns;

signal CLK  : std_logic := '0';
signal RST  : std_logic := '0';
signal EN   : std_logic := '0';
signal D    : std_logic_vector(7 downto 0) := (others => '0');
signal Q    : std_logic_vector(7 downto 0) := (others => '0');
signal data : std_logic_vector(7 downto 0) := (others => '0');


begin

SH: SHIFTREG
generic map (
    W   => 8,
    N   => 4
)
port map (
    CLK => CLK,
    RST => RST,
    EN  => EN,
    D   => D,
    Q   => Q
);

CLKP :process
begin
    CLK <= '0';
    wait for CLK_period/2;
    CLK <= '1';
    wait for CLK_period/2;
end process;


TRACE: process (Q)
begin
    printf_slv(Q, file_q);
end process;


SIMUL: process
begin

wait until rising_edge(CLK);

RST <= '0';
wait for 100 ns;

RST <= '1';
wait for 100 ns;

data <= "00000001";
RST <= '0';
EN  <= '0';
D   <= data;
wait for 100 ns;

for J in 1 to 80 loop
    for I in 1 to 6 loop
        data <= data + 1;
        EN  <= '1';
        D   <= data;
        wait for CLK_period;
    end loop;
    for I in 1 to 3 loop
        data <= data;
        EN  <= '0';
        D   <= data;
        wait for CLK_period;
    end loop;
end loop;


wait;
end process;

end;