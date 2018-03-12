##
## Makefile for automakefile in /home/Starkiller/ADM_automakefile_2016
## 
## Made by Benoit Bouton
## Login   <Starkiller@epitech.net>
## 
## Started on  Tue Jun 27 00:26:49 2017 Benoit Bouton
## Last update Tue Jun 27 10:04:30 2017 Benoit Bouton
##

SRC	=	src/automakefile.sh

NAME	=	automakefile

all:
	cp $(SRC) $(NAME)
clean:
	rm -f $(NAME)

fclean:
	rm -f $(NAME)

re:	clean all
