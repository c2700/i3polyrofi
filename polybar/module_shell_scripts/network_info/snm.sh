bits_increments(){
	local a=$1
	local b=0
	case $a in
		1) b=128 ;;
		2) b=64 ;;
		3) b=32 ;;
		4) b=16 ;;
		5) b=8 ;;
		6) b=4 ;;
		7) b=2 ;;
		8) b=1 ;;
	esac 
	echo "$b"
}

A=0
B=0
C=0
D=0
snm="$A.$B.$C.$D"
snm_slash_notation=0

declare -A snm_array
snm_array[0]="$snm"

for (( i=0; i<=4; i++ ))
do
	if [[ $snm_slash_notation -eq 32 ]]
	then
		break
	fi

	for (( p=1; p<=8; p++ ))
	do
		if [[ $snm_slash_notation -eq 32 ]]
		then
			break
		fi

		if [[ $A -lt 255 ]]
		then
			a=$(bits_increments $p)
			A=$((A+a))
		elif [[ $A -eq 255 ]] && [[ $B -lt 255 ]]
		then
			b=$(bits_increments $p)
			B=$((B+b))
		elif [[ $A -eq 255 ]] && [[ $B -eq 255 ]] && [[ $C -lt 255 ]]
		then
			c=$(bits_increments $p)
			C=$((C+c))
		elif [[ $A -eq 255 ]] && [[ $B -eq 255 ]] && [[ $C -eq 255 ]] && [[ $D -lt 255 ]]
		then
			d=$(bits_increments $p)
			D=$((D+d))
		fi
		
		snm="$A.$B.$C.$D"
		snm_slash_notation=$((snm_slash_notation+1))
		snm_array[$snm_slash_notation]="$snm"

	done
done

