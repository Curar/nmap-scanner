#!/bin/bash
# 
# By Curar 2020r.
#
# Skrypt skanujący z użyciem programu Nmap
# https://github.com/nmap/nmap
# https://nmap.org/
# 
#
# Write using vim editor
# https://github.com/vim/vim
# https://www.vim.org/

clear
tablica_info["0"]="
=========================================
Skrypt skanujący z użyciem programu Nmap
=========================================
 https://github.com/nmap/nmap
 https://nmap.org/
 
Write using vim editor
 
 https://github.com/vim/vim
 https://www.vim.org/
=========================================
"
tablica_logo["0"]="
=========================================
  _   _                                         
 | \ | | :) by Curar 2020                      
 |  \| |_ __ ___   __ _ _ __               
 | | | | |_ | _ \ / _| | |_ \   - OSINT  
 | |\  | | | | | | (_| | |_) |           
 |_| \_|_| |_| |_|\__|_| |__/            
                       | |       HELLOW! 
                       |_|               
=========================================
"
echo -e "\e[33m${tablica_info["0"]}\e[0m"
echo -e "\e[32m${tablica_logo["0"]}\e[0m"
echo -e "\e[33mDZIEŃ DOBRY\e[0m"
echo ""
read -p "Naduś ENTER"
clear

# Definicja zmiennych używanych w skrypcie
nmap_h="nmap -sn"
nmap_s="nmap"
nmap_g="nmap -sS -sU -v -O -p 0-"
domena_vaild="^([a-z0-9]+(-[a-z0-9]+)*\.)+[a-z]{2,}$"
IP_VAILD="^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$" 
ZAKRES_PORTY="^[0-9]+$"
wynik_s="wynik.txt"
data="`date`"
IP="`ip a | grep 'state UP' -A2 | tail -n1 | awk -F'[/ ]+' '{print $3}'`"
MASKA="`ip -o -f inet a show | awk '/scope global/ {print $4}'`"

# Defincja funkcji używanych w skrypcie
function pauza() {
	echo ""	
	read -p "Naduś klawisz ENTER aby kontynować ..."
	}

function nmap_sudo_exist() {
	if ! [ -x "$(command -v nmap)" ]; then
  		echo 'UWAGA Nmap nie jest zainstalowany !' >&2
		exit 1
	elif ! [ -x "$(command -v sudo)" ]; then
	       echo 'UWAGA SUDO nie jest zainstalowane !' >&2
       	       exit 1
	fi	       
}

function wynik() {
	echo -e "\e[33m********************************************\e[0m"
	echo -e "\e[33m  Skanowanie celu $ADRES_IP zakończone      \e[0m"
        echo -e "\e[33m********************************************\e[0m"
}

function wykryj_dystrybucje() {
if grep -qi Arch /etc/issue 
	then
		echo -e "\e[32mWykryłem ,że pracujemy z dystrybucją Arch Linux\e[0m"		
		nmap_sudo_exist;	
		elif grep -qi Debian /etc/issue
	then
		echo -e "\e[32mWykryłem ,że pracujemy z dystrybucją Debiana\e[0m"
		nmap_sudo_exist;		
	elif grep -qi Fedora /etc/issue
	then
		echo -e "\e[32mWykryłem ,że pracujemy z dystrybucją Fedora\e[0m"		
		nmap_sudo_exist;		
	elif grep -qi Gentoo /etc/issue
	then
		echo -e "\e[32mWykryłem ,że pracujemy z dystrybucją Gentoo\e[0m"	
		nmap_sudo_exist;		
	else
		echo -e "\e[32mWykryłem ,że pracujemy z dystrybucją `cat /etc/os-release`\e[0m"	
		nmap_sudo_exist;		
fi
sleep 3
}

wykryj_dystrybucje;

while :
do {
	clear
	echo -e "\e[32m${tablica_logo["0"]}\e[0m"
	echo -e "\e[32mJakie skanowanie przeprowadzić ? :\e[0m"
	opcje_wyboru=(
		"Skanowanie - szybkie" 
		"Skanowanie - głębokie" 
		"Skanowanie własnego IP"
		"Wykrywanie hostów w obecnej sieci LAN" 
		"Wykrywanie hostów w innej podsieci" 
		"Sprawdź dostępne interfejsy sieciowe" 
		"Wyjście"
	)
	select opcja in "${opcje_wyboru[@]}"
	do
			case $opcja in
			"Skanowanie - szybkie") 	
				echo -e "\e[32mPracujesz jako :\e[0m"; whoami 
				echo -e "\e[32mTwoje obecne IP : $IP\e[0m"	
				echo -e "\e[32mPodaj adres IPv4 np. 127.0.0.1 lub domenę np. nmap.org :\e[0m"
				read ADRES_IP
				# Wykrywanie adresu IP (wmiarę poprawnego)	
				if [[ $ADRES_IP =~ $IP_VAILD ]]; 
				then {
						echo -e "\e[32mRozpoczynam skanowanie - szybkie dla adresu : $ADRES_IP\e[0m"	
						if (($EUID)); then {	
						echo -e "\e[32mWykryłem, że nie pracujesz jako root włączę nmap poprzez polecenie sudo ! może być wymagane podanie hasła :\e[0m"
						echo "Data skanowania: $data" > $wynik_s
						echo "Skanowałeś następujący cel : $ADRES_IP" >> $wynik_s 	
						sudo $nmap_s $ADRES_IP >> $wynik_s
						cat $wynik_s
						echo -e "\e[32mWynik skanowania zapisałem w pliku $wynik_s\e[0m"
						wynik;
						} else {
						echo "Data skanowania: $data" > $wynik_s
						echo "Skanowałeś następujący cel : $ADRES_IP" >> $wynik_s 
						$nmap_s $ADRES_IP >> $wynik_s
						cat $wynik_s
						echo -e "\e[32mWynik skanowania zapisałem w pliku $wynik_s\e[0m"
						wynik;	
						} 
						fi
				 	}	
				elif [[ $ADRES_IP =~ $domena_vaild ]]; 
				then {	
						echo -e "\e[32mRozpoczynam skanowanie - szybkie dla domeny : $ADRES_IP\e[0m"	
						if (($EUID)); then {	
						echo -e "\e[32mWykryłem, że nie pracujesz jako root włączę nmap poprzez polecenie sudo ! może być wymagane podanie hasła :\e[0m"
						echo "Data skanowania: $data" > $wynik_s
						echo "Skanowałeś następujący cel : $ADRES_IP" >> $wynik_s 	
						sudo $nmap_s $ADRES_IP >> $wynik_s
						cat $wynik_s
						echo -e "\e[32mWynik skanowania zapisałem w pliku $wynik_s\e[0m"
						wynik;
						} else {
						echo "Data skanowania: $data" > $wynik_s
						echo "Skanowałeś następujący cel : $ADRES_IP" >> $wynik_s 
						$nmap_s $ADRES_IP >> $wynik_s
						cat $wynik_s
						echo -e "\e[32mWynik skanowania zapisałem w pliku $wynik_s\e[0m"
						wynik;	
						} 
						fi
					}
				else {
					echo -e "\e[33mPodano błędny adres IP lub domenę !\e[0m"
				}
				fi
			;;
			"Skanowanie - głębokie")
				echo -e "\e[32mPracujesz jako :\e[0m"; whoami 
				echo -e "\e[32mTwoje obecne IP : $IP\e[0m"
				echo -e "\e[32mPodaj adres IPv4 np. 127.0.0.1 lub domenę np. nmap.org :\e[0m"
				read ADRES_IP	
				# Wykrywanie adresu IP (wmiarę poprawnego)	
				if [[ $ADRES_IP =~ $IP_VAILD ]]; then {
						read -p "Podaj porty do przeskanowania z zakresu od 0 do (Max to 65535)" PORTY
						if (($PORTY <= 65535)); then {
							echo -e "\e[32mRozpoczynam skanowanie - głębokie dla adresu : $ADRES_IP\e[0m"	
							if (($EUID)); then {	
							echo -e "\e[32mWykryłem, że nie pracujesz jako root włączę nmap poprzez polecenie sudo ! może być wymagane podanie hasła :\e[0m"
							echo "Data skanowania: $data" > $wynik_s
							echo "Skanowałeś następujący cel : $ADRES_IP" >> $wynik_s 	
							echo "skanuje poleceniem : $nmap_g$PORTY $ADRES_IP"
							sudo $nmap_g$PORTY $ADRES_IP >> $wynik_s
							cat $wynik_s
							echo -e "\e[32mWynik skanowania zapisałem w pliku $wynik_s\e[0m"
							wynik;
							} else {
							echo "Data skanowania: $data" > $wynik_s
							echo "Skanowałeś następujący cel : $namp_g 0-$ADRES_IP" >> $wynik_s 
							$nmap_g$PORTY $ADRES_IP >> $wynik_s
							cat $wynik_s
							echo -e "\e[32mWynik skanowania zapisałem w pliku $wynik_s\e[0m"
							wynik;	
							} 
							fi 
						}
						else {	
							echo -e "\e[33mPodaj porty poprawnie !\e[0m"
						} fi
					
				}
				else {
					if [[ $ADRES_IP =~ $domena_vaild ]]; then {
						read -p "Podaj porty do przeskanowania z zakresu od 0 do (Max to 65535)" PORTY
						if (($PORTY <= 65535)); then {
							echo -e "\e[32mRozpoczynam skanowanie - głębokie dla domeny : $ADRES_IP\e[0m"	
							if (($EUID)); then {	
							echo -e "\e[32mWykryłem, że nie pracujesz jako root włączę nmap poprzez polecenie sudo ! może być wymagane podanie hasła :\e[0m"
							echo "Data skanowania: $data" > $wynik_s
							echo "Skanowałeś następujący cel : $ADRES_IP" >> $wynik_s 	
							echo "skanuje poleceniem : $nmap_g$PORTY $ADRES_IP"
							sudo $nmap_g$PORTY $ADRES_IP >> $wynik_s
							cat $wynik_s
							echo -e "\e[32mWynik skanowania zapisałem w pliku $wynik_s\e[0m"
							wynik;
							} else {
							echo "Data skanowania: $data" > $wynik_s
							echo "Skanowałeś następujący cel : $namp_g 0-$ADRES_IP" >> $wynik_s 
							$nmap_g$PORTY $ADRES_IP >> $wynik_s
							cat $wynik_s
							echo -e "\e[32mWynik skanowania zapisałem w pliku $wynik_s\e[0m"
							wynik;	
							} 
							fi 
						}
						else {	
							echo -e "\e[33mPodaj porty poprawnie !\e[0m"
						} fi
					} else {
					echo -e "\e[33mPodano błędny adres IP lub domenę !\e[0m"
					} fi
				} 
				fi
			;;			
			"Skanowanie własnego IP")
				if (($EUID)); then {
				echo -e "\e[32mPracujesz jako :\e[0m"; whoami 	
				echo -e "\e[32mWykryłem, że nie pracujesz jako root włączę nmap poprzez polecenie sudo ! może być wymagane podanie hasła :\e[0m"
				echo "Data skanowania: $data" > $wynik_s	
				sudo $nmap_g $IP >> $wynik_s
				cat $wynik_s
				} else {
				echo "Data skanowania: $data" > $wynik_s
				$nmap_g $IP >> $wynik_s
				cat $wynik_s
				}
				fi
			;;
			"Wykrywanie hostów w obecnej sieci LAN")
				if [[ ! -z "$MASKA" ]]; then {
					echo "Wykrywanie : $MASKA"
					$nmap_h $MASKA > $wynik_s
					cat $wynik_s
				} else {
					echo -e "\e[33mBrak adresacji na interfejsach sieciowych !\e[0m"
				} 
				fi
			;;
			"Wykrywanie hostów w innej podsieci")
				echo -e "\e[32mPracujesz jako :\e[0m"; whoami 
				echo -e "\e[32mPodaj adres IPv4 wraz z maską np. 127.0.0.1/24:\e[0m"
				read ADRES_IP
				if [[ ! -z "$ADRES_IP" ]]; then {
					echo -e "\e[32mRozpoczynam skanowanie - dla zakresu : $ADRES_IP\e[0m"
					echo "Data skanowania: $data" > $wynik_s
					echo "Skanowałeś następujący cel : $ADRES_IP" >> $wynik_s 
					$nmap_h $ADRES_IP >> $wynik_s
					cat $wynik_s
					echo -e "\e[32mWynik skanowania zapisałem w pliku $wynik_s\e[0m"
					wynik;
				} else {
					echo -e "\e[33mUWAGA ! Nie podałeś adresu IPv4 wraz z maską np. 127.0.0.1/24 !\e[0m"
				}
				fi	
			;;
			"Sprawdź dostępne interfejsy sieciowe")
				if [[ ! -z "$IP" ]]; then {
					echo -e "\e[33m========================================\e[0m"
					echo -e "\e[33mTwój adres IP : $IP\e[0m"
					echo -e "\e[33m========================================\e[0m"
					ip a
				} else {
					echo -e "\e[33mBrak adresów IP\e[0m"
				}
				fi
			;;
			"Wyjście")
				clear
				exit 1
			;;
	*) echo "Brak wyboru !"
	esac
	break
done
}
echo -e "\e[32mBy Curar :) 2020 r.\e[0m"
unset PORTY
pauza
done
