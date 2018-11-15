# Function to print in specified color
colorprintf () {
	case $1 in
		"red") tput setaf 1;;
		"green") tput setaf 2;;
		"orange") tput setaf 3;;
		"blue") tput setaf 4;;
		"purple") tput setaf 5;;
		"cyan") tput setaf 6;;
		"gray" | "grey") tput setaf 7;;
		"white") tput setaf 8;;
	esac
	printf "$2";
	tput sgr0
}
