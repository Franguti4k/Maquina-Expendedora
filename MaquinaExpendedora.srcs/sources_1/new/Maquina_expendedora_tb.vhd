----------------------------------------------------------------------------------
-- Company: Universidad Nebrija
-- Engineer: Francisco Javier Gutiérrez Gallego
-- 
-- Create Date: 20.12.2023 19:31:14
-- Design Name: 
-- Module Name: Maquina_expendedora_tb - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;


entity Maquina_expendedora_tb is
end Maquina_expendedora_tb;

architecture Behavioral of Maquina_expendedora_tb is
signal CLOCK_TB, RESET_TB : STD_LOGIC;
    signal COIN_IN_TB : STD_LOGIC_VECTOR(2 downto 0);
    signal COIN_OUT_TB : STD_LOGIC_VECTOR(2 downto 0);
    signal LATA_TB, EMPTY_TB : STD_LOGIC;

    constant CLOCK_PERIOD : time := 10 ns;

    component MaquinaExpendedora
        Port ( CLOCK : in STD_LOGIC;
               RESET : in STD_LOGIC;
               COIN_IN : in STD_LOGIC_VECTOR(2 downto 0);
               COIN_OUT : out STD_LOGIC_VECTOR(2 downto 0);
               LATA : out STD_LOGIC;
               EMPTY : out STD_LOGIC);
    end component;

begin
DUT : MaquinaExpendedora
        port map (
        CLOCK =>CLOCK_TB, 
        RESET => RESET_TB, 
        COIN_IN => COIN_IN_TB,
        COIN_OUT => COIN_OUT_TB,
        LATA => LATA_TB,
        EMPTY => EMPTY_TB
        );

   process
    begin
       CLOCK_TB <= '0';
       wait for CLOCK_PERIOD / 2;
       CLOCK_TB <= '1';
       wait for CLOCK_PERIOD / 2;
    end process;

   process
    begin
        RESET_TB <= '0';
        wait for CLOCK_PERIOD * 2;
        RESET_TB <= '1';
        wait for CLOCK_PERIOD * 2;
        RESET_TB <= '0';
        wait;
   end process;
   process
    begin
        wait for CLOCK_PERIOD*3;
         COIN_IN_TB <= "000";  
        wait for CLOCK_PERIOD*2;
        --Prueba 1
        COIN_IN_TB <= "001";  
        wait for CLOCK_PERIOD/2;
        COIN_IN_TB <= "000";  
        wait for CLOCK_PERIOD/2;
        COIN_IN_TB <= "001";  
        wait for CLOCK_PERIOD/2;
        COIN_IN_TB <= "000";  
        wait for CLOCK_PERIOD/2;
        COIN_IN_TB <= "000";  
        wait for CLOCK_PERIOD*2;
        --Prueba 2
        COIN_IN_TB <= "010";  
        wait for CLOCK_PERIOD/2;
        COIN_IN_TB <= "000";  
        wait for CLOCK_PERIOD/2;
        COIN_IN_TB <= "000";  
        wait for CLOCK_PERIOD*2;
        --Prueba 3
        COIN_IN_TB <= "001";  
        wait for CLOCK_PERIOD/2;
        COIN_IN_TB <= "000";  
        wait for CLOCK_PERIOD/2;
        COIN_IN_TB <= "010";  
        wait for CLOCK_PERIOD/2;
        COIN_IN_TB <= "000";  
        wait for CLOCK_PERIOD/2;
        COIN_IN_TB <= "000";  
        wait for CLOCK_PERIOD*2;
        --Prueba 4
        COIN_IN_TB <= "101";
        wait for CLOCK_PERIOD/2; 
        COIN_IN_TB <= "000";  
        wait for CLOCK_PERIOD/2; 
        COIN_IN_TB <= "000";  
        wait for CLOCK_PERIOD*2;
        --Prueba 5
         COIN_IN_TB <= "001";  
        wait for CLOCK_PERIOD/2;
        COIN_IN_TB <= "000";  
        wait for CLOCK_PERIOD/2;
        COIN_IN_TB <= "101";  
        wait for CLOCK_PERIOD/2;
        COIN_IN_TB <= "000";  
        wait for CLOCK_PERIOD/2;
        COIN_IN_TB <= "000";  
        wait for CLOCK_PERIOD*2;
        --AHORA LA MAQUINA EXPENDEDORA ESTA VACIA
        --VAMOS A PROBAR QUE DEVUELVE LAS MONEDAS INTRODUCIDAS
        
        --MONEDA DE 1€
        COIN_IN_TB <= "001";  
        wait for CLOCK_PERIOD/2;
        
        --MONEDA DE 2€
        COIN_IN_TB <= "010";  
        wait for CLOCK_PERIOD/2;
        
        --BILLETE DE 5€
        COIN_IN_TB <= "101";
        wait for CLOCK_PERIOD/2; 
        COIN_IN_TB <= "000";  
        wait;
    end process;

end Behavioral;
