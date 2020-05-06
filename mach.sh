#!/bin/bash

###############################################################################
#
# Dieses Skript erledigt die Vorarbeit für cpp-, html-, sh-, css- , php- oder h-Dateien. 
# Indem es die dafür immer notwendigen Schlüsselwörter gleich in das Dokument schreibt.
# Weiters kan man mit den richtigen Parmeter gleich Web oder C++ Projekte anlegen.
#
###############################################################################
#
# Benützung:
#     Skriptname <Parameter> <Name1> ...
#
###############################################################################
#
#     Parameter:
#         sh - erstellt ein ausführbares Bash-Dokument mit der Dateiendung ".sh"
#
#         cpp - erstellt ein C++-source-Dokument mit der Dateiendung ".cpp"
#         h - erstellt ein C++-header-Dokument mit der Dateiendung ".h"
#
#         html - erstellt ein HTML-Dokument mit der Dateiendung ".html"
#         css - erstellt ein CSS-Dokument mit der Dateiendung ".css"
#         php - erstellt ein PHP-Dokument mit der Dateiendung ".php"
#
#         CPP - erstellt ein C++-Projekt dessen Struktur wie folgt aussieht:
#             Name1
#               |-src
#               |   |-main.cpp
#               |   |-Name2.cpp
#               |
#               |-headers
#               |   |-Name2.h
#               |
#               |-Debug
#               |   |-Makefile
#
#         WEB - erstellt ein Web-Projekt dessen Struktur wie folgt aussieht:
#             Name1
#               |-index.html
#               |
#               |-html
#               |
#               |-css
#               |   |-Name2.css
#               |
#               |-img
#               |
#               |-php
#
###############################################################################
#
#    Name (optional):
#        Beim erstellen eines CPP-Projektes:
#            Der Projektordner wird mit "Name1" benannt.
#            Die erste Klasse, die dazugehörige header- und source- Datei wird
#            mit "Name2" benannt. Das Ziel der Makefile wird mit "Name1" benannt.
#            Wenn es nur einen Namen gibt, wird "Name2" mit "Name1" ersetzt. Wenn
#            keinen Namen gibt, wird "Name1" mit "unnamed" ersetzt.
#
#        Beim erstellen eines WEB-Projektes:
#            Der Projektordner wird mit "Name1" benannt.
#            Die erste Stylesheet-Datei wird mit "Name2" benannt. Wenn es nur
#            einen Namen gibt, wird "Name2" mit "Name1" ersetzt. Wenn keinen Namen
#            gibt, wird "Name1" mit "unnamed" ersetzt.
#
#        Beim erstellen eines oder mehrerer Dokumente:
#            Das neue Dokument wird mit diesem Namen erzeugt.
#            Wenn dieser Parameter fehlt heißt das Dokument unnnamed.
#            Man kann mehrere Namen mit einem trennenden Leerzeichen angeben,
#            dann werden auch so viele gleiche Dokumente mit den jeweiligen Namen
#            erzeugt.
#            Spezialfall bei einem Html-Dokumentes:
#                Wenn "Name" als "Name1,Name2" dargestellt wird, wird "Name2.css"
#                direkt als Stylsheet eingebunden. Ansonsten bleibt der Bereich
#                für den Namen des Stylsheets frei.
#            Spezialfall bei einem Cpp-Dokumentes:
#                Wenn "Name" als "Name1,Name2" dargestellt wird, wird "Name2.h"
#                direkt als Header eingebunden.
#
###############################################################################
#
# Raeuber Hotzenplotz - 2. April 2015
#
###############################################################################

#------------------------------------------------------------------------------
# Globale Variablen:
#     Name: Dieser wird in den/die Kopfkommentare/n geschrieben.
#     Datum: Dieses              -''-
#     Skriptname: Über diese Variable wird das Skript rekursiv aufgreufen.
#------------------------------------------------------------------------------
Name=$USER
Datum=`date '+%d. %B %Y'`
if [ ${0%/*} == "." ]
then
        Skriptname="../../${0#*/}"
else
        Skriptname=$0
fi

#------------------------------------------------------------------------------
# Falls man für das Skript einen falschen Syntax verwendet hat, gibt diese Funktion
# die Information, die zwischen der dritten und 86. Zeile steht, aus und verlässt
# das Skript.
#------------------------------------------------------------------------------
ausgabeSyntaxfehler()
{
	echo -e "\nERROR: Falscher Syntax!\n"
	Hilfe=`cat $0`
	Hilfe="${Hilfe%%#-*}"
	echo "${Hilfe#*##}"
	exit -1
}

#------------------------------------------------------------------------------
# Erzeugt eine Datei mit dem Namen (inkl. Dateiendung) die der Funktion übergeben
# wurde. Falls die Dateiendung "sh" ist wird das neue Skript auch gleich ausführbar
# gemacht.
#------------------------------------------------------------------------------
erzeugeDatei()
{
        Dateiname="$1"
        Dateiendung="$2"

	if ( [ $Dateiendung == html ] || [ $Dateiendung == php ] || [ $Dateiendung == cpp ] ) && [ ${Dateiname%,*} != $Dateiname ]
	then
		kompletterName="${Dateiname%,*}.${Dateiendung}"

	else
		kompletterName="${Dateiname}.${Dateiendung}"

	fi

        if [ ! -e $kompletterName ]
        then
                touch $kompletterName
                schreibInhalt $Dateiname $Dateiendung $kompletterName

                if [ $Dateiendung == sh ]
                then
                        chmod +x $kompletterName
                fi

        else
                echo "$kompletterName existiert bereits!"

        fi
}

#------------------------------------------------------------------------------
# Schreibt den Inhalt in das Dokument
#------------------------------------------------------------------------------
schreibInhalt()
{
        Dateiname="$1"
        Dateiendung="$2"
	kompletterName="$3"
        
        case $Dateiendung in
                sh) Inhalt=`echo -e "#!/bin/bash\n\n#"`
                        Inhalt+=`printf "%80d\n" | tr ' ' '#'`
                        Inhalt=${Inhalt%0}
                        Inhalt+=`echo -e "\n# \n# $kompletterName\n#\n# ${Name} am ${Datum}\n#\n#\n"`
                        Inhalt+=`printf "%80d\n" | tr ' ' '#'`
                        Inhalt=${Inhalt%0}
                        ;;

                cpp) schreibCKommentarblock $kompletterName
			if [ ${Dateiname%,*} != $Dateiname ]
			then
				Headername=${Dateiname#*,}
				Dateiname=${Dateiname%,*}
				Inhalt=`echo -e "\n#include \"${Headername}.h\""`
				echo "${Inhalt}" >> $kompletterName
			fi

                        if [ $Dateiname == main ]
                        then
                                Inhalt=`echo -e "#include <iostream>\n\nusing namespace std;\n\nint main(int argc, char *argv[])\n{\n    \n    return 0;\n}"`
                        fi
                        ;;

                h) schreibCKommentarblock $kompletterName
                        DateinameGross=`printf "${Dateiname}" | tr '[a-z]' '[A-Z]'` 
			Inhalt=`echo -e "\n#ifndef ${DateinameGross}_H_\n#define ${DateinameGross}_H_\n\nclass ${Dateiname}\n{\npublic:\n    ${Dateiname}();\n    ~$Dateiname();\n};\n\n#endif /* ${DateinameGross}_H_ */"`
                        ;;
                
                html) schreibHtmlKommentarblock $kompletterName
			if [ ${Dateiname%,*} == $Dateiname ]
			then
				Inhalt=`echo -e "\n<!DOCTYPE html>\n<html lang=\"de\">\n\n  <head>\n    <meta charset=\"utf-8\">\n    <title>${Dateiname}</title>\n    <link href=\"styles/.css\" type=\"text/css\" rel=\"stylesheet\">\n    <link href=\"img/.ico\" type=\"image/x-icon\" rel=\"shortcut icon\">\n  </head>\n\n  <body>\n    \n  </body>\n\n</html>"`
			else
				Stylsheetname=${Dateiname#*,}
				Dateiname=${Dateiname%,*}
				Inhalt=`echo -e "\n<!DOCTYPE html>\n<html lang=\"de\">\n\n  <head>\n    <meta charset=\"utf-8\">\n    <title>${Dateiname}</title>\n    <link href=\"styles/${Stylsheetname}.css\" type=\"text/css\" rel=\"stylesheet\">\n    <link href=\"img/.ico\" type=\"image/x-icon\" rel=\"shortcut icon\">\n  </head>\n\n  <body>\n    \n  </body>\n\n</html>"`
			fi
                        ;;

                css) schreibCKommentarblock $kompletterName
                        Inhalt=`echo -e "\nbody\n{\n    \n}"`
                        ;;
                
                php) schreibHtmlKommentarblock $kompletterName
			if [ ${Dateiname%,*} == $Dateiname ]
			then
				Inhalt=`echo -e "\n<!DOCTYPE html>\n<html lang=\"de\">\n\n  <head>\n    <meta charset=\"utf-8\">\n    <title>${Dateiname}</title>\n    <link href=\"styles/.css\" type=\"text/css\" rel=\"stylesheet\">\n    <link href=\"img/.ico\" type=\"image/x-icon\" rel=\"shortcut icon\">\n  </head>\n\n  <body>\n    <?php  ?>\n  </body>\n\n</html>"`
			else
				Stylsheetname=${Dateiname#*,}
				Dateiname=${Dateiname%,*}
				Inhalt=`echo -e "\n<!DOCTYPE html>\n<html lang=\"de\">\n\n  <head>\n    <meta charset=\"utf-8\">\n    <title>${Dateiname}</title>\n    <link href=\"styles/${Stylsheetname}.css\" type=\"text/css\" rel=\"stylesheet\">\n    <link href=\"img/.ico\" type=\"image/x-icon\" rel=\"shortcut icon\">\n  </head>\n\n  <body>\n    <?php  ?>\n  </body>\n\n</html>"`
			fi
                        ;;
                
                *) ausgabeSyntaxfehler
                        ;;
        esac

	if [ $Dateiendung != cpp ] || ( [ $Dateiendung == cpp ] && [ $Dateiname == main ] )
	then
		echo "${Inhalt}" >> $kompletterName

	fi
}

#------------------------------------------------------------------------------
# schreibt einen C-Kommentarblock in die Datei.
#------------------------------------------------------------------------------
schreibCKommentarblock()
{
        kompletterName="$1"
        
        Kommentar="/"
        Kommentar+=`printf "%79d\n" | tr ' ' '*'`
        Kommentar=${Kommentar%0}
        Kommentar+=`echo -e "\n* \n* $kompletterName\n*\n* $Name am $Datum\n*\n*\n"`
        Kommentar+=`printf "%78d\n" | tr ' ' '*'`
        Kommentar=${Kommentar%0}
        Kommentar+="/"
        
        echo "${Kommentar}" > $kompletterName
}

#------------------------------------------------------------------------------
# schreibt einen Html-Kommentarblock in die Datei.
#------------------------------------------------------------------------------
schreibHtmlKommentarblock()
{
        kompletterName="$1"
        
        Kommentar="<!-- "
        Kommentar+=`printf "%75d\n" | tr ' ' '-'`
        Kommentar=${Kommentar%0}
        Kommentar+=`echo -e "\n< \n< $kompletterName\n<\n< $Name am $Datum\n<\n<\n"`
        Kommentar+=`printf "%75d\n" | tr ' ' '-'`
        Kommentar=${Kommentar%0}
        Kommentar+=" -->"
        
        echo "${Kommentar}" > $kompletterName
}

#------------------------------------------------------------------------------
# erzeugt ein C++-Projekt
#------------------------------------------------------------------------------
erzeugeCppProjekt()
{
        Name1="$1"
        Name2="$2"

        mkdir $Name1
        cd $Name1
        mkdir Debug
        cd Debug
        touch Makefile
        Inhalt=`echo -e "CC = /usr/bin/g++\nCCFLAGS = -Wall -g\nINCPATH = -I ../headers/\nOBJ = ${Name2}.o main.o\nBIN = ${Name1}\n\n../\$"`
        Inhalt+="(BIN): \$(OBJ)"
        Inhalt+=`echo -e "\n\t\$"`
        Inhalt+="(CC) \$(CCFLAGS) -o ../\$(BIN) \$(OBJ)"
        Inhalt+=`echo -e "\n\n%.o: ../src/%.cpp\n\t\$"`
        Inhalt+="(CC) \$(CCFLAGS) -c \$< \$(INCPATH)"
        Inhalt+=`echo -e "\n\nclean:\n\trm -rf \$"`
        Inhalt+="(BIN) \$(OBJ)"
        echo "${Inhalt}" > Makefile
        cd ..
        mkdir src
        mkdir headers
        cd src
	if [ $Name2 == unnamed ] || [ $Name2 == $Name1 ]
	then
		$Skriptname cpp main
	else
		$Skriptname cpp main,$Name2
	fi
	if [ $Name2 == unnamed ] || [ $Name2 == $Name1 ]
	then
		$Skriptname cpp $Name2
	else
		$Skriptname cpp $Name2,$Name2
	fi
        cd ../headers/
        $Skriptname h $Name2
        cd ../../
}

#------------------------------------------------------------------------------
# erzeugt ein WEB-Projekt
#------------------------------------------------------------------------------
erzeugeWebProjekt()
{
        Name1="$1"
        Name2="$2"

        mkdir $Name1
        cd $Name1
	if [ $Name2 == unnamed ] || [ $Name2 == $Name1 ]
	then
		$Skriptname html index
	else
		$Skriptname html index,$Name2
	fi
        mkdir html
        mkdir css
        mkdir img
        mkdir php
        cd css
        $Skriptname css $Name2
        cd ../../
}

#------------------------------------------------------------------------------
# Eigentlicher Skriptablauf:
#------------------------------------------------------------------------------
# Falls kein Parameter an das Skript übergeben wurde oder der erste Parameter falsch
# ist, wird die Funktion "ausgabeSyntaxfehler" aufgerufen und das Skript abgebrochen.
# Ansonsten wird die Variablen für die Dateiendung des zukünftigen Dokumentes befüllt.
#------------------------------------------------------------------------------
if [ $# -eq 0 ]
then
        ausgabeSyntaxfehler

else
        Dateiendung="$1"

        if [ $Dateiendung == sh ] || [ $Dateiendung == cpp ] || [ $Dateiendung == h ] || [ $Dateiendung == html ] || [ $Dateiendung == css ] || [ $Dateiendung == php ] || [ $Dateiendung == CPP ] || [ $Dateiendung == WEB ] || [ $Dateiendung == CLASS ]

        then
                if [ $Dateiendung == CPP ]
                then
                        if [ $# -ge 3 ]
                        then
                                erzeugeCppProjekt $2 $3
                                exit

                        elif [ $# -eq 2 ]
                        then
                                erzeugeCppProjekt $2 $2
                                exit

                        elif [ $# -eq 1 ]
                        then
                                erzeugeCppProjekt unnnamed unnnamed
                                exit

                        else
                                ausgabeSyntaxfehler

                        fi

                elif [ $Dateiendung == WEB ]
                then
                        if [ $# -ge 3 ]
                        then
                                erzeugeWebProjekt $2 $3
                                exit

                        elif [ $# -eq 2 ]
                        then
                                erzeugeWebProjekt $2 $2
                                exit

                        elif [ $# -eq 1 ]
                        then
                                erzeugeWebProjekt unnnamed unnnamed
                                exit

                        else
                                ausgabeSyntaxfehler

                        fi
                elif [ $Dateiendung == CLASS ]
                then
                        if [ $# -eq 2 ]
                        then
                                [ -d src ] && cd src
                                $Skriptname cpp $2,$2
                                [ -d ../headers ] && cd ../headers
                                $Skriptname h $2
                                                                
                                exit
                        else
                                ausgabeSyntaxfehler

                        fi
                fi
        else
                ausgabeSyntaxfehler
                exit

        fi

#------------------------------------------------------------------------------
# Wenn ein Name oder mehrere Namen übergeben wurde, werden alle Dokumente in einer 
# Schleife erzeugt.
#------------------------------------------------------------------------------
	if [ $# -gt 1 ]
	then
		for ((i=2; i<=$#; i++))
		do
			Dateiname=${!i}
                        erzeugeDatei $Dateiname $Dateiendung
		done

	fi

#------------------------------------------------------------------------------
# Wenn kein Name übergeben wurde, wird nur ein Dokument erzeugt.
#------------------------------------------------------------------------------
	if [ $# -eq 1 ]
	then
		Dateiname="unnamed"
                erzeugeDatei $Dateiname $Dateiendung

	fi

fi
