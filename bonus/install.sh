#!/bin/sh
printf "Creation of the directory...\n"
mkdir -p ~/.auto-make/
printf "Copying the files...\n"
cp automakefile ~/.auto-make/
cp makefile.conf ~/.auto-make/
cp ~/.auto-make/makefile.conf ~/.auto-make/makefile.conf.backup
printf "Instaling alias...\n"
echo -e "#AUTOMAKEFILE ALIAS" >> ~/.bashrc
echo -e "alias mconf='emacs ~/.auto-make/makefile.conf'" >> ~/.bashrc
echo -e "alias mauto='sh ~/.auto-make/automakefile ~/.auto-make/makefile.conf'" >> ~/.bashrc
echo -e "alias mreset='cp ~/.auto-make/makefile.conf.backup ~/.auto-make/makefile.conf'" >> ~/.bashrc
printf "Installation completed\n"
