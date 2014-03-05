:: --------------------------------------------------------------------
::  Convert CDR to PDF and Show PDF
::
::  Copyright (C) 2014 StXh <stxh007@gmail.com>
::
:: ---------------------------------------------------------------------

@echo off  
Set curDir=%~dp0

PATH=%curDir%;%curDir%DLLs;%PATH%
set PYTHONPATH=

set PDFFILE=cdr2pdf.pdf

call uniconvertor.cmd %1 %PDFFILE%
start %PDFFILE%