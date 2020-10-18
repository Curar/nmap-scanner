#!/bin/bash
#
# Skrypt skanujący z użyciem Nmap
# By Wojtek 2020

echo -e "\e[32m=========================================\e[0m"
echo -e "\e[32m  _   _                                  \e[0m"       
echo -e "\e[33m | \ | | :) by Curar 2020                \e[0m"      
echo -e "\e[32m |  \| |_ __ ___   __ _ _ __             \e[0m"  
echo -e "\e[32m | | | | |_ | _ \ / _| | |_ \   - OSINT  \e[0m"
echo -e "\e[32m | |\  | | | | | | (_| | |_) |           \e[0m"
echo -e "\e[32m |_| \_|_| |_| |_|\__|_| |__/            \e[0m"
echo -e "\e[33m                       | |       HELLOW! \e[0m"
echo -e "\e[32m                       |_|               \e[0m"
echo -e "\e[32m=========================================\e[0m"

echo ""
echo ""
echo -e "\e[33mDZIEŃ DOBRY\e[0m"
sleep 5
clear

# Definicja zmiennych używanych w skrypcie
nmap_s="nmap"
nmap_g="nmap -sS -sU -v -O"
wynik_s="wynik.txt"
data="`date`"

# Defincja funkcji używanych w skrypcie
function pauza() {
	echo -e "\e[33m********************************************\e[0m"
	echo -e "\e[33m  Skanowanie celu $ADRES_IP zakończone      \e[0m"
        echo -e "\e[33m********************************************\e[0m"
	echo ""	
	read -p "Naduś klawisz ENTER aby kontynować ..."
	}

if grep -qi Arch /etc/issue 
	then
		echo -e "\e[32mWykryłem ,że masz Arch Linux\e[0m"
		if ! (nmap && sudo) > /dev/null; then {
			echo "Widzę, że masz zainstalowany program Nmap i SUDO"
		}
		else {
			echo "Aby skrypt działał musisz zainstalować wymagane pakiety : Nmap i SUDO"
			echo "Zaloguj się jako root : su -"
			
			echo "Wykonj polecenie : pacman -Sy nmap sudo"
			exit
		}
		fi
	elif grep -qi Debian /etc/issue
	then
		echo -e "\e[32mWykryłem ,że masz Debiana\e[0m"
		if ! (nmap && sudo) > /dev/null; then {
			echo "Widzę, że masz zainstalowany program Nmap i SUDO"
		}
		else {
			echo "Aby skrypt działał musisz zainstalować wymagane pakiety : Nmap i SUDO"
			echo "Zaloguj się jako root : su -"
			
			echo "Wykonj polecenie : apt install nmap sudo"
			exit
		}
		fi
	elif grep -qi Fedora /etc/issue
	then
		echo -e "\e[32mWykryłem ,że masz Fedorę\e[0m"	
		if ! (nmap && sudo) > /dev/null; then {
			echo "Widzę, że masz zainstalowany program Nmap i SUDO"
		}
		else {
			echo "Aby skrypt działał musisz zainstalować wymagane pakiety : Nmap i SUDO"
			echo "Zaloguj się jako root : su -"
			
			echo "Wykonj polecenie : dnf install nmap sudo"
			exit
		}
		fi
	elif grep -qi Gentoo /etc/issue
	then
		echo -e "\e[32mWykryłem ,że masz Gentoo\e[0m"
		if ! (nmap && sudo) > /dev/null; then {
			echo "Widzę, że masz zainstalowany program Nmap i SUDO"
		}
		else {
			echo "Aby skrypt działał musisz zainstalować wymagane pakiety : Nmap i SUDO"
			echo "Zaloguj się jako root : su -"
			
			echo "Wykonj polecenie : emerge nmap sudo"
			exit
		}
		fi
	else
		echo -e "\e[32mWykryłem ,że masz `cat /etc/os-release`\e[0m"
		if ! (nmap && sudo) > /dev/null; then {
			echo "Widzę, że masz zainstalowany program Nmap i SUDO"
		}
		else {
			echo "Aby skrypt działał musisz zainstalować wymagane pakiety : Nmap i SUDO"
			exit
		}
		fi
fi

sleep 5

while :
do {
	clear
	echo -e "\e[33mUWAGA !!! Aby zakończyć naduś Ctrl+c\e[0m"
	echo -e "\e[32mPodaj adres IPv4 np. 127.0.0.1 lub domenę np. nmap.org :\e[0m"
	read ADRES_IP

	echo -e "\e[32mJakie skanowanie przeprowadzić ? :\e[0m"
	select WYBOR in SZYBKIE GLEBOKIE
		do
			case $WYBOR in
				"SZYBKIE") 	
				echo -e "\e[32m Pracujesz jako :\e[0m"; whoami 
				echo -e "\e[32m Rozpoczynam skanowanie SZYBKIE dla adresu/domeny : $ADRES_IP\e[0m"
				if (($EUID)); then {
				echo -e "\e[32m Wykryłem, że nie pracujesz jako root włączę nmap poprzez polecenie sudo ! może być wymagane podanie hasła :\e[0m"
				echo "Data skanowania: $data" > $wynik_s
				echo "Skanowałeś następujący cel : $ADRES_IP" >> $wynik_s 
				sudo $nmap_s $ADRES_IP >> $wynik_s
				cat $wynik_s
				echo -e "\e[32mWynik skanowania zapisałem w pliku $wynik_s\e[0m"
				}
				else {			
				echo "Data skanowania: $data" > $wynik_s
				echo "Skanowałeś następujący cel : $ADRES_IP" >> $wynik_s 
				sudo $nmap_s $ADRES_IP >> $wynik_s
				$nmap_s $ADRES_IP >> $wynik_s
				cat $wynik_s	
				echo -e "\e[32mWynik skanowania zapisałem w pliku $wynik_s\e[0m"
				}
				fi
			;;
			"GLEBOKIE")
				echo -e "\e[32m Pracujesz jako :\e[0m"; whoami 
				echo -e "\e[32m Rozpoczynam skanowanie GŁĘBOKIE dla adresu/domeny : $ADRES_IP\e[0m"	
				if (($EUID)); then {	
				echo -e "\e[32m Wykryłem, że nie pracujesz jako root włączę nmap poprzez polecenie sudo ! może być wymagane podanie hasła :\e[0m"
				echo "Data skanowania: $data" > $wynik_s
				echo "Skanowałeś następujący cel : $ADRES_IP" >> $wynik_s 	
				sudo $nmap_g $ADRES_IP >> $wynik_s
				cat $wynik_s
				echo -e "\e[32mWynik skanowania zapisałem w pliku $wynik_s\e[0m"
				}
				else {
				echo "Data skanowania: $data" > $wynik_s
				echo "Skanowałeś następujący cel : $ADRES_IP" >> $wynik_s 
				$nmap_g $ADRES_IP >> $wynik_s
				cat $wynik_s
				echo -e "\e[32mWynik skanowania zapisałem w pliku $wynik_s\e[0m"
				}
				fi			
			;;
	*) echo "Brak wyboru !"
	esac
	break
done
}
echo -e "\e[33mPrzypominam aby zakończyć naduś Ctrl+c\e[0m"
echo -e "\e[32mBy Curar :) 2020 r.\e[0m"
#sleep 10
pauza
done

