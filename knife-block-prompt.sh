#bash knife-block pronpt support

#Show the currently selected knife in your knife-block in your bash prompt

#Requires bash 3.2+ due to the use of $BASH_REMATCH

#Not tested with other shells, if you would like this to work with your
#favourite shell please request and I will consider writing it.

#To install:

#	1. Copy this file to somewhere eg. ~/.knife-block-prompt.sh
#	2. Add the following to your ~/.bashrc:
#		source ~/.knife-block-prompt.sh
#	3. Change your PS1 to call _knife-block_ps1 as command substitution:
#		PS1='$(_knife-block_ps1)\u@\h \w $ '
		
_knife-block_ps1 () {
	#Preserve exit
	local exit=$?

	#Get contents of symlink
	knifesymlink="$(readlink ${HOME}/.chef/knife.rb)"

	#If not a symlink or some other error then do nothing
	[ -z $knifesymlink ] && return $exit

	#Extract current knife
	[ -n "`$SHELL -c 'echo $ZSH_VERSION'`" ] && setopt KSH_ARRAYS BASH_REMATCH
	[[ $knifesymlink =~ ${HOME}/\.chef/knife-(.*)\.rb ]]
	currentknife=${BASH_REMATCH[1]}
	
	echo $currentknife
	return $exit
}
