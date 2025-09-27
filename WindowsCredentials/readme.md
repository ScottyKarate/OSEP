## PEN-300



##### SAM credentials

***theory***: 

Local Windows credentials are stored in the Security Account Manager (SAM) database as password hashes using the NTLM hashing format, which is based on the MD4 algorithm.

We can reuse acquired NTLM hashes to authenticate to a different machine, as long as the hash is tied to a user account and password registered on that machine.

Although it is rare to find matching local credentials between disparate machines, the built-in default-named Administrator account is installed on all Windows-based machines.  


***Attack***:  

1) Create shadow copy:          wmic shadowcopy call create Volume='C:\'
2) Locate Shadow copy:          vssadmin list shadows
