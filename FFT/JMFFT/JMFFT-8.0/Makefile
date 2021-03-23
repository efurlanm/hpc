############################ -*- Mode: Makefile -*- ###########################
## Makefile --- Construction de la bibliotheque JMFFT
##
## Auteur          : Jalel Chergui (CNRS/IDRIS) <Jalel.Chergui@idris.fr>
## Créé le         : Tue Dec  8 18:18:21 1998
## Dern. mod. par  : Jalel Chergui (CNRS/IDRIS) <Jalel.Chergui@idris.fr>
## Dern. mod. le   : Thu May 13 14:18:49 2004
###############################################################################

# SHELL = /bin/ksh

all: jmfft
jmfft:
	@echo
	@echo "*********** Construction de libjmfft.a ***********"
	@echo
	(cd src ; make && mv libjmfft.a ../lib/.)
