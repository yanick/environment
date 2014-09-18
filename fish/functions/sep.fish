function sep
	set_color d75f00
	perl -E'say "\n--- 8< ", "-" x ( `tput cols` - 8 )'
	set_color normal

end
