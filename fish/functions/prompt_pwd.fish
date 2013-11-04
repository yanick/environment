function prompt_pwd --description 'Print the current working directory, shortend to fit the prompt'
	echo $PWD | sed -e "s|^$HOME|~|" 
end
