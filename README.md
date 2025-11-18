# VarValCodeHarmonisation
We share the R-code for generating corrected versions of px-files, i.e files used for open data-dissemination. The corrected px-files only contain harmonised variable names, variable values and variable value codes instead of the multiple and non-standard ones created by multiple experts during the production processes.

This code (_correcting_px_files_pub.R_) relies on two preparatory steps:
(i) building a dictionary/database which pairs unique variable variable names/variable values/variable value codes/  with all possible ones found in the whole collection of px-files (via the script _build_db_from_pxmap.R_). The database is continuously improved and updated and it is not the object of the current repository.
(ii) the input created by the data scrapper [pxmap](https://github.com/hansharaldss/pxmap/) which gives an overview database of  variable values' codes found in all px-files

This work is part of a larger project and partly funded by the Eurostat 2023-GEOS-IS.
