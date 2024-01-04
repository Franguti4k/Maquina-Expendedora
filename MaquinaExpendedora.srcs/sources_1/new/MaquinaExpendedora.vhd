----------------------------------------------------------------------------------
-- Company: Universidad Nebrija
-- Engineer: Francisco Javier Gutiérrez Gallego
-- 
-- Create Date: 20.12.2023 08:46:37
-- Design Name: 
-- Module Name: MaquinaExpendedora - Behavioral
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

--LIBRERIAS
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

--ENTIDAD
entity MaquinaExpendedora is
    Port ( CLOCK : in STD_LOGIC; --RELOJ
           RESET : in STD_LOGIC; --RESET
           COIN_IN : in STD_LOGIC_VECTOR(2 downto 0); -- 3 bits para tipos de moneda/billete
           COIN_OUT : out STD_LOGIC_VECTOR(2 downto 0); -- 3 bits para tipo de moneda devuelto
           LATA : out STD_LOGIC; --señal de salida que indica cuando sale una lata
           EMPTY : out STD_LOGIC); -- Señal que indica si la máquina está vacía
end MaquinaExpendedora;

--ARQUITECTURA
architecture Behavioral of MaquinaExpendedora is
    type Estado is (S0, S1, S2, S3); --estados
    signal estado_actual, estado_siguiente : Estado;

    type TipoMoneda is (NADA, UNEURO, DOSEUROS, CINCOEUROS);
    signal moneda_introducida : TipoMoneda;
    signal inventario_empty : STD_LOGIC;

    signal total_introducido, precio_lata, inventario_actual, inventario_restante : integer := 0;


begin
    process(CLOCK, RESET)
    begin
        if rising_edge(CLOCK) then
            estado_actual <= estado_siguiente;
            inventario_actual <= inventario_actual - inventario_restante;
            --RESET
            if RESET = '1' then
                estado_actual <= S0;
                precio_lata <= 2;
                inventario_actual <= 5; -- Inicialmente se cargan 5 latas
            end if;
        end if;
    end process;
    
    process(estado_actual , COIN_IN, inventario_empty) 
        begin

            case estado_actual is
                when S0 => --ESTADO 0 (INICIO)
                    if RESET = '1' then
				        if(total_introducido = 1) then
					       COIN_OUT <= "001";
				        end if;
                    end if;
                    LATA <= '0';
                    EMPTY <= '0';
                    inventario_restante <= 0;
					COIN_OUT <= "000";
					if (inventario_empty = '1') then
                        estado_siguiente <= S3;
					elsif (COIN_IN = "000") then
						estado_siguiente <= S0;
						moneda_introducida <= NADA;
						total_introducido <= total_introducido + 0;
					elsif (COIN_IN = "001") then
						estado_siguiente <= S1;
						moneda_introducida <= UNEURO;
						total_introducido <= total_introducido + 1;
					elsif (COIN_IN = "010") then
						estado_siguiente <= S2;
						moneda_introducida <= DOSEUROS;
						total_introducido <= total_introducido + 2;
					elsif (COIN_IN = "101") then
						estado_siguiente <= S2;
						moneda_introducida <= CINCOEUROS;
						total_introducido <= total_introducido + 5;
					end if;
                --ESTADO 1 (CUANDO METES 1€)
                when S1 =>
                    LATA <= '0';
                    COIN_OUT <= "000";
					if (COIN_IN = "000") then
						estado_siguiente <= S1;
						moneda_introducida <= NADA;
						total_introducido <= total_introducido + 0;
					elsif (COIN_IN = "001") then
						estado_siguiente <= S2;
						moneda_introducida <= UNEURO;
						total_introducido <= total_introducido + 1;
					elsif (COIN_IN = "010") then
						estado_siguiente <= S2;
						moneda_introducida <= DOSEUROS;
						total_introducido <= total_introducido + 2;
					elsif (COIN_IN = "101") then
						estado_siguiente <= S2;
						moneda_introducida <= CINCOEUROS;
						total_introducido <= total_introducido + 5;
					end if;
				--ESTADO 2	(EXPULSA LA LATA Y CAMBIO)
                when S2 =>
                    LATA <= '1';
                    inventario_restante <= 1;
                    if (total_introducido > precio_lata) then
                        if (total_introducido - precio_lata = 1) then 
                            COIN_OUT <= "001";
                        elsif (total_introducido - precio_lata = 3) then
                            COIN_OUT <= "011";
                        elsif (total_introducido - precio_lata = 4) then
                            COIN_OUT <= "100";
                        else
                            COIN_OUT <= "000"; 
                        end if;
                    end if;
                    total_introducido <= 0;
                        estado_siguiente <= S0;

                --ESTADO 3  (MAQUINA VACIA)
                when S3 =>
                    COIN_OUT <= COIN_IN;
                    EMPTY <= '1';
                when others =>
					LATA <= '0';
					COIN_OUT <= "000";
                    estado_siguiente <= S0;
            end case;

    end process;

    inventario_empty <= '1' when inventario_actual = 0 else '0';

end Behavioral;