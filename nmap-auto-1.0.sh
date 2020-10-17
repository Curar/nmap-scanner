#!/bin/bash
#
# Skrypt skanujący z użyciem Nmap
# By Wojtek 2020

echo -e "\e[32m========================================================\e[0m"
echo -e "\e[32m  _   _                          ____      _   _       \e[0m"       
echo -e "\e[32m | \ | | :) by Curar 2020       / __ \    | | (_)      \e[0m"      
echo -e "\e[32m |  \| |_ __ ___   __ _ _ __   | |  | |___| |_ _ _ __  \e[0m"  
echo -e "\e[32m | | | | |_ | _ \ / _| | |_ \  | |  | / __| __| | |_ \ \e[0m"
echo -e "\e[32m | |\  | | | | | | (_| | |_) | | |__| \__ \ |_| | | | |\e[0m"
echo -e "\e[32m |_| \_|_| |_| |_|\__|_| |__/   \____/|___/\__|_|_| |_|\e[0m"
echo -e "\e[32m                       | |                             \e[0m"
echo -e "\e[32m                       |_|                             \e[0m"
echo -e "\e[32m========================================================\e[0m"

echo ""
echo ""
if grep -qi Arch /etc/issue 
	then
		echo -e "\e[32mWykryłem ,że masz Arch Linux\e[0m"
	elif grep -qi Debian /etc/issue
	then
		echo -e "\e[32mWykryłem ,że masz Debiana\e[0m"
	elif grep -qi Fedora /etc/issue
	then
		echo -e "\e[32mWykryłem ,że masz Fedorę\e[0m"
	elif grep -qi Gentoo /etc/issue
	then
		echo -e "\e[32mWykryłem ,że masz Gentoo\e[0m"
	else
		echo -e "\e[32mWykryłem ,że masz `cat /etc/os-release`\e[0m"
fi

# Zmienne
nmap_s="nmap"
nmap_g="nmap -sS -v -O"
wynik_s="wynik.txt"
data="`date`"

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
			echo -e "\e[32m Wynik skanowania zapisałem w pliku wynik.txt\e[0m"
			}
			else {			
			echo "Data skanowania: $data" > $wynik_s
			echo "Skanowałeś następujący cel : $ADRES_IP" >> $wynik_s 
			sudo $nmap_s $ADRES_IP >> $wynik_s
			$nmap_s $ADRES_IP >> $wynik_s
			cat $wynik_s	
			echo -e "\e[32m Wynik skanowania zapisałem w pliku wynik.txt\e[0m"
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
			echo -e "\e[32m Wynik skanowania zapisałem w pliku wynik.txt\e[0m"
			}
			else {
			echo "Data skanowania: $data" > $wynik_s
			echo "Skanowałeś następujący cel : $ADRES_IP" >> $wynik_s 
			$nmap_g $ADRES_IP >> $wynik_s
			cat $wynik_s
			echo -e "\e[32m Wynik skanowania zapisałem w pliku wynik.txt\e[0m"
			}
			fi			
		;;
	*) echo "Brak wyboru !"
	esac
	break
done
