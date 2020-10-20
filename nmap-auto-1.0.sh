#!/bin/bash
#
# Skrypt skanujący z użyciem Nmap
# By Wojtek 2020
clear
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
	echo ""	
	read -p "Naduś klawisz ENTER aby kontynować ..."
	}

nmap_exist() {
	if ! [ -x "$(command -v nmap)" ]; then
  		echo 'UWAGA Nmap nie jest zainstalowany !' >&2
	fi
}

sudo_exist() {
	if ! [ -x "$(command -v sudo)" ]; then
  		echo 'UWAGA SUD nie jest zainstalowane, przerywam skrypt !' >&2
		echo "Zainstaluj wymagane pakiety czyli nmap i sudo"
		echo "Aby włączyć ponownie skrypt wydaj polecenie sh nmap-auto-1.0.sh lub ./nmap-auto-1.0.sh"
  		exit 1
	fi
}

wynik() {
	echo -e "\e[33m********************************************\e[0m"
	echo -e "\e[33m  Skanowanie celu $ADRES_IP zakończone      \e[0m"
        echo -e "\e[33m********************************************\e[0m"
}

if grep -qi Arch /etc/issue 
	then
		echo -e "\e[32mWykryłem ,że pracujemy z dystrybucją Arch Linux\e[0m"		
		nmap_exist;
	        sudo_exist;	
		elif grep -qi Debian /etc/issue
	then
		echo -e "\e[32mWykryłem ,że pracujemy z dystrybucją Debiana\e[0m"
		nmap_exist;
		sudo_exist;
	elif grep -qi Fedora /etc/issue
	then
		echo -e "\e[32mWykryłem ,że pracujemy z dystrybucją Fedora\e[0m"	
		nmap_exist;
		sudo_exist;
	elif grep -qi Gentoo /etc/issue
	then
		echo -e "\e[32mWykryłem ,że pracujemy z dystrybucją Gentoo\e[0m"
		nmap_exist;
		sudo_exist;
	else
		echo -e "\e[32mWykryłem ,że pracujemy z dystrybucją `cat /etc/os-release`\e[0m"
		nmap_exist;
		sudo_exist;
fi

sleep 5

while :
do {
	clear
	echo -e "\e[32mJakie skanowanie przeprowadzić ? :\e[0m"
	select WYBOR in 'Skanowanie - szybkie' 'Skanowanie - głębokie' 'Sprawdź dostępne interfejsy sieciowe' 'Wyjście'
		do
			case $WYBOR in
			"Skanowanie - szybkie") 	
				echo -e "\e[32mPracujesz jako :\e[0m"; whoami 
				echo -e "\e[32mPodaj adres IPv4 np. 127.0.0.1 lub domenę np. nmap.org :\e[0m"
				read ADRES_IP
				echo -e "\e[32mRozpoczynam skanowanie - szybkie dla adresu/domeny : $ADRES_IP\e[0m"
				if (($EUID)); then {
				echo -e "\e[32mWykryłem, że nie pracujesz jako root włączę nmap poprzez polecenie sudo ! może być wymagane podanie hasła :\e[0m"
				echo "Data skanowania: $data" > $wynik_s
				echo "Skanowałeś następujący cel : $ADRES_IP" >> $wynik_s 
				sudo $nmap_s $ADRES_IP >> $wynik_s
				cat $wynik_s
				echo -e "\e[32mWynik skanowania zapisałem w pliku $wynik_s\e[0m"
				wynik;
				}
				else {			
				echo "Data skanowania: $data" > $wynik_s
				echo "Skanowałeś następujący cel : $ADRES_IP" >> $wynik_s 
				sudo $nmap_s $ADRES_IP >> $wynik_s
				$nmap_s $ADRES_IP >> $wynik_s
				cat $wynik_s	
				echo -e "\e[32mWynik skanowania zapisałem w pliku $wynik_s\e[0m"
				wynik;
				}
				fi
			;;
			"Skanowanie - głębokie")
				echo -e "\e[32mPracujesz jako :\e[0m"; whoami 
				echo -e "\e[32mPodaj adres IPv4 np. 127.0.0.1 lub domenę np. nmap.org :\e[0m"
				read ADRES_IP
				echo -e "\e[32mRozpoczynam skanowanie - głębokie dla adresu/domeny : $ADRES_IP\e[0m"	
				if (($EUID)); then {	
				echo -e "\e[32mWykryłem, że nie pracujesz jako root włączę nmap poprzez polecenie sudo ! może być wymagane podanie hasła :\e[0m"
				echo "Data skanowania: $data" > $wynik_s
				echo "Skanowałeś następujący cel : $ADRES_IP" >> $wynik_s 	
				sudo $nmap_g $ADRES_IP >> $wynik_s
				cat $wynik_s
				echo -e "\e[32mWynik skanowania zapisałem w pliku $wynik_s\e[0m"
				wynik;
				}
				else {
				echo "Data skanowania: $data" > $wynik_s
				echo "Skanowałeś następujący cel : $ADRES_IP" >> $wynik_s 
				$nmap_g $ADRES_IP >> $wynik_s
				cat $wynik_s
				echo -e "\e[32mWynik skanowania zapisałem w pliku $wynik_s\e[0m"
				wynik;	
				}
				fi			
			;;
			"Sprawdź dostępne interfejsy sieciowe")
				ip a;
			;;
			"Wyjście")
				clear
				exit
			;;
	*) echo "Brak wyboru !"
	esac
	break
done
}
echo -e "\e[32mBy Curar :) 2020 r.\e[0m"
pauza
done

