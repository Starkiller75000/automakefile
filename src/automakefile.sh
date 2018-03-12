#!/bin/sh
if [ $# -ne 1 ]
then
    echo "Usage : automakefile <file.conf>"
    exit 84
else
    if [ -f $1 ]
    then

	#Definition of Variables
	EXEC=`cat $1 | grep -w "EXEC" | cut -d ";" -f2`
	PROJECT_DIR=`cat $1 | grep -w "PROJECT_DIR" | cut -d ";" -f2`
	CC=`cat $1 | grep -w "CC" | cut -d ";" -f2`
	SOURCES_DIR=`cat $1 | grep -w "SOURCES_DIR" | cut -d ";" -f2`
	CFLAGS=`cat $1 | grep -w "CFLAGS" | cut -d ";" -f2`
	LDFLAGS=`cat $1 | grep -w "LDFLAGS" | cut -d ";" -f2`
	HEADERS_DIR=`cat $1 | grep -w "HEADERS_DIR" | cut -d ";" -f2`
	LIBS_DIR=`cat $1 | grep -w "LIBS_DIR" | cut -d ";" -f2`
	BCK_DIR=`cat $1 | grep -w "BCK_DIR" | cut -d ";" -f2`
	ZIP=`cat $1 | grep -w "ZIP" | cut -d ";" -f2`
	ZIPFLAGS=`cat $1 | grep -w "ZIPFLAGS" | cut -d ";" -f2`
	UNZIP=`cat $1 | grep -w "UNZIP" | cut -d ";" -f2`
	UNZIPFLAGS=`cat $1 | grep -w "UNZIPFLAGS" | cut -d ";" -f2`

	#Check du dossier du projet
	if [ -z $PROJECT_DIR ];then
	    exit 84
	elif [ ! -d $PROJECT_DIR ];then
	    printf "\033[31mThe directory $PROJECT_DIR doesn't exist.\n\033[0m"
	    exit 84
	fi

	#Check Makefile
	if [ -f $PROJECT_DIR/Makefile ];then
	    printf "\033[31mA project named Makefile already exist in the directory root.\n"
	    read -p 'Replace the old Makefile? (Y/N):' answer
	    case $answer in
		o|O|y|Y) printf "\033[35mSuppression of the old Makefile.\n"
			 rm $PROJECT_DIR/Makefile;;
		*)
		    echo -e "\033[0m"
		    exit 0;;
	    esac
	elif [ -d $PROJECT_DIR/Makefile ];then
	    print "\033[31mA directory named \"Makefile\" already exist in the directory root.\n"
	    exit 84
	fi

	#Creation of DirectorY
	if [ -z $SOURCES_DIR ]; then
	    SOURCES_DIR="src"
	    printf "\033[34mcreation of the Folder $SOURCES_DIR in the $PROJECT_DIR directory.\n"
	    mkdir -p $PROJECT_DIR/$SOURCES_DIR
	else
	    mkdir -p $PROJECT_DIR/$SOURCES_DIR
	fi
	
	if [ -z $HEADERS_DIR ]; then
	    HEADERS_DIR="include"
	    printf "\033[34mcreation of the Folder $HEADER_DIR in the $PROJECT_DIR directory.\n"
	    mkdir -p $PROJECT_DIR/$HEADERS_DIR
	else
	    mkdir -p $PROJECT_DIR/$HEADERS_DIR
	fi

	if [ -z $BCK_DIR ]; then
	    BCK_DIR="backup"
	    printf "\033[34mCreation of the folder $BCK_DIR in the $PROJECT_DIR directory.\n"
	    mkdir -p $PROJECT_DIR/$BCK_DIR
	else
	    mkdir -p $PROJECT_DIR/$BCK_DIR
	fi

	if [ -z $LIBS_DIR ]; then
	    LIBS_DIR="libs"
	    printf "\033[34mCreation of the folder $LIBS_DIR in the $PROJECT_DIR directory.\n"
	    mkdir -p $PROJECT_DIR/$LIBS_DIR
	else
	    mkdir -p $PROJECT_DIR/$LIBS_DIR
	fi

	if [ -z $EXEC ]; then
	    EXEC="a.out"
	fi

	src="SRC\t= \t\0134\n"
	while IFS='' read -r line || [[ -n "$line" ]]
	do
	    files=(${line//;/ })
	    if [ ${files[0]: -2} == '.c' ]
	    then
		src+="\t\t$SOURCES_DIR/${files[0]} \0134\n"
	    fi
	done < "$1"
	echo -e $src > $PROJECT_DIR/Makefile

	#Corps du Makefile
	function makefile ()
	{
	    echo -e "\nOBJ\t=\t\$(SRC:.c=.o)\n" >> $PROJECT_DIR/Makefile
	    echo -e "CFLAGS\t+=\t"$CFLAGS "-I$HEADERS_DIR\n" >> $PROJECT_DIR/Makefile
	    echo -e "LDFLAGS\t+=\t"$LDFLAGS"-L$LIBS_DIR\n" >> $PROJECT_DIR/Makefile
	    echo -e "NAME\t=\t"$EXEC"\n" >> $PROJECT_DIR/Makefile
	    echo -e "CC\t=\t"$CC"\n" >> $PROJECT_DIR/Makefile
	    echo -e "ZIP\t=\t"$ZIP"\n" >> $PROJECT_DIR/Makefile
	    echo -e "ZIPFLAGS\t=\t"$ZIPFLAGS"\n" >> $PROJECT_DIR/Makefile
	    echo -e "UNZIP\t=\t"$UNZIP"\n" >> $PROJECT_DIR/Makefile
	    echo -e "UNZIPFLAGS\t=\t"$UNZIPFLAGS"\n" >> $PROJECT_DIR/Makefile
	    echo -e "ECHO\t=\techo -e\n" >> $PROJECT_DIR/Makefile
	    echo -e "VER\t=\t1.0\n" >> $PROJECT_DIR/Makefile
	    echo -e "all:\t\$(NAME)\n" >> $PROJECT_DIR/Makefile
	    echo -e "\$(NAME):\t\$(OBJ)\n" >> $PROJECT_DIR/Makefile
	    echo -e "\t\$(CC) -o \$(NAME) \$(OBJ) \n" >> $PROJECT_DIR/Makefile
	    echo -e "clean:" >> $PROJECT_DIR/Makefile
	    echo -e "\trm -f \$(OBJ)" >> $PROJECT_DIR/Makefile
	    echo -e "\trm -f *.gcno\n" >> $PROJECT_DIR/Makefile
	    echo -e "fclean: clean" >> $PROJECT_DIR/Makefile
	    echo -e "\trm -f \$(NAME)\n" >> $PROJECT_DIR/Makefile
	    echo -e "re: fclean clean all\n" >> $PROJECT_DIR/Makefile
	    echo -e ".PHONY: re fclean clean all\n" >> $PROJECT_DIR/Makefile
	    echo -e "archive:" >> $PROJECT_DIR/Makefile
	    echo -e "\t\$(ZIP) \$(ZIPFLAGS)" $BCK_DIR"/back-\$(VER).tar \$(SRC)" >> $PROJECT_DIR/Makefile
	    echo -e "\t@\$(ECHO) '$BCK_DIR/back-\$(VER).tar file generated.'" >> $PROJECT_DIR/Makefile
	    echo -e "revert:" >> $PROJECT_DIR/Makefile
	    echo -e "\t\$(UNZIP) \$(UNZIPFLAGS)" $BCK_DIR"/back-\$(VER).tar" >> $PROJECT_DIR/Makefile
	    echo -e "delete:" >> $PROJECT_DIR/Makefile
	    echo -e "\trm -f" $BCK_DIR"/back-\$(VER).tar" >> $PROJECT_DIR/Makefile
	    echo -e "num:" >> $PROJECT_DIR/Makefile
	    echo -e "\t@\$(ECHO) \$(VER)" >> $PROJECT_DIR/Makefile
	}
	echo -e "\033[33mGenerating Makefile..."
	makefile
    else
	echo -e "\033[31mPlz enter give me a valid file\033[0m"
	exit 84
    fi
fi
echo  -e "\033[32mMakefile Generated\033[0m"
