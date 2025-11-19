# VarValCodeHarmonisation
We share here the R-code for generating _corrected versions of px-files_, i.e files used for open data-dissemination. The corrected px-files only contain harmonised variable names, variable values and variable value codes instead of the multiple and non-standard ones created by multiple experts during the production processes.

The code (_correcting_px_files_pub.R_) relies on two preparatory steps:

(i) the input created by the data scrapper [pxmap](https://github.com/hansharaldss/pxmap/) which consists of an overview of all variable names/values/codes found in all px-files published by Statistics Iceland

(ii) a dictionary/database (described in _description_dictionary.md_ and created using the script _build_db_from_pxmap.R_) which is pairing the unique, harmonised variable variable names/variable values/variable value codes with all possible ones found by the scrapper. The database is continuously improved and updated and it is not the object of the current repository.

This work is part of a larger project (101156693--2023-IS-GEOS) and partly funded by Eurostat.
