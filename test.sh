ip a > baza_ip.txt
grep -o 'inet [[:digit:]]\+.[[:digit:]]\+.[[:digit:]]\+.[[:digit:]]' baza_ip.txt > baza2_ip.txt
grep -o '[[:digit:]]\+.[[:digit:]]\+.[[:digit:]]\+.[[:digit:]]' baza2_ip.txt > baza3_ip.txt
readarray -t menu < baza3_ip.txt
		for i in "${!menu[@]}"; do
			menu_list[$i]="${menu[$i]%% *}"
		done
		echo -e "\e[32mWykryte adresy IPv4 :\e[0m"
		select wybor in "${menu_list[@]}" "EXIT"; do
		case "$wybor" in
			"EXIT")
			clear
			break
			;;
			*)
			echo "You chose : $wybor"
			;;
		esac
		break
		done
