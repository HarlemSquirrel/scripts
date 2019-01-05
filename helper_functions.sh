# Function to print in specified color
colorprintf () {
	case $1 in
		"black") tput setaf 0;;
		"red") tput setaf 1;;
		"green") tput setaf 2;;
		"orange") tput setaf 3;;
		"blue") tput setaf 4;;
		"purple") tput setaf 5;;
		"cyan") tput setaf 6;;
		"gray" | "grey") tput setaf 7;;
		"white") tput setaf 8;;
		"default") tput setaf 9;;
	esac
	printf "$2";
	tput sgr0
}
