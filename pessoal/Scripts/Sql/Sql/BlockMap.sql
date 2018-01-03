<HTML>
<HEAD>
<TITLE>
File 95172
</TITLE>
</HEAD>
<BODY BGCOLOR="#FFFFFF" TEXT="#000000">
<PRE>
                              Oracle Corporate Support
                                 Problem Repository

1. Prob# 1019474.6  TFTS: SCRIPT TO CREATE TABLESPACE BLOCK MAP
2. Soln# 2067778.6  TALES FROM THE SCRYPT (TFTS) OVERVIEW


1. Prob# 1019474.6  TFTS: SCRIPT TO CREATE TABLESPACE BLOCK MAP

Problem ID          : 1019474.6
Affected Platforms  : Generic: not platform specific
Affected Products   : Oracle Server - Enterprise Edition V7
Affected Components : RDBMS V07.XX
Affected Oracle Vsn : V07.XX

Summary:
TFTS: SCRIPT TO CREATE TABLESPACE BLOCK MAP

+=+

 
 
 
Circulation:		** Available to Customers ** 
Script Creator:		Cary Millsap, Oracle Corporation 
Topic:			** Tales from the Scrypt ** 
Subject:		TFTS: TABLESPACE MAP BY BLOCK 
Keywords:		tablespace map block 
------------------------------------------------------------------------------- 
 
====== 
Title: 
====== 
 
Tablespace Map by Block 
 
=========== 
Disclaimer: 
=========== 
 
This script is provided for educational purposes only. It is NOT supported by 
Oracle World Wide Technical Support.  The script has been tested and appears 
to work as intended.  However, you should always test any script  
before relying on it. 
 
PROOFREAD THIS SCRIPT PRIOR TO USING IT!  Due to differences in the way text  
editors, email packages and operating systems handle text formatting (spaces,  
tabs and carriage returns), this script may not be in an executable state when  
you first receive it.  Check over the script to ensure that errors of this  
type are corrected. 
 
 
========= 
Abstract: 
========= 
 
This script provides a block-level mapping of the tables inside one or 
more tablespaces. 
 
 
============= 
Requirements: 
============= 
 
SELECT on DBA_EXTENTS and DBA_FRE_SPACE 
 
======= 
Script: 
======= 
 
----------- cut ---------------------- cut -------------- cut -------------- 
 
SET ECHO off 
REM NAME:  TFSTBMAP.SQL 
REM USAGE:"@path/tfstbmap.sql" 
REM -------------------------------------------------------------------------- 
REM REQUIREMENTS: 
REM    SELECT on DBA_EXTENTS & DBA_FREE_SPACE,  
REM -------------------------------------------------------------------------- 
REM AUTHOR:  
REM    Cary Millsap, Oracle Corporation       
REM  Copyright (c) 1991,1995 by Oracle Corporation       
REM -------------------------------------------------------------------------- 
REM PURPOSE: 
REM    The purpose of this script is to provide a block-level mapping of tables 
REM    inside one or more tablespaces. 
REM --------------------------------------------------------------------------- 
REM EXPLANATION: 
REM    Provides a block-level mapping of tables inside of a given tablespace. 
REM --------------------------------------------------------------------------- 
REM EXAMPLE: 
REM      Tablespace    File  Block Id    Size                  Segment 
REM    --------------- ---- ---------- --------  
REM    ----------------------------------  
REM    USERS  5          1        1 &lt;file hdr&gt;  
REM                                  2  5 SYSTEM.UUU  
REM                                  7        5 FRAN1.TAB_FRAN1 
REM                                 12        5 FRAN1.TAB_FRAN2 
REM                    17        2 SCOTT.UN_NAME 
REM  19        5 SCOTT.GTEMP 
REM                                 24       20 CBLAKEY.GASLOG 
REM                                 44       25 CBLAKEY.GASTMP 
REM                            69        5 CBLAKEY.GASLOG_FILL_UP_NO_PK 
REM                         74        5 JERSON.TEST 
REM     79        5 SCOTT.VCARBONN2 
REM --------------------------------------------------------------------------- 
REM DISCLAIMER: 
REM    This script is provided for educational purposes only. It is NOT  
REM    supported by Oracle World Wide Technical Support. 
REM    The script has been tested and appears to work as intended. 
REM    You should always run new scripts on a test instance initially. 
REM -------------------------------------------------------------------------- 
REM Main text of script follows: 
 
def ts          = &&1  
  
col tablespace form a15 head 'Tablespace' just c trunc  
col file_id    form       990 head 'File'     just c  
col block_id   form 9,999,990 head 'Block Id'   just c  
col blocks     form   999,990 head 'Size'       just c  
col segment    form       a38 head 'Segment'    just c trunc  
  
break -  
  on tablespace skip page -  
  on file_id skip 1  
  
select  
  tablespace_name              tablespace,  
  file_id,  
  1                         block_id,  
  1                            blocks,  
  '&lt;file hdr&gt;'                 segment  
from  
  dba_extents  
where  
  tablespace_name = upper('&ts')  
union  
select  
  tablespace_name              tablespace,  
  file_id,  
  1                            block_id,  
  1  blocks,  
  '&lt;file hdr&gt;'                 segment  
from  
  dba_free_space  
where  
  tablespace_name = upper('&ts')  
union  
select  
  tablespace_name  tablespace,  
  file_id,  
  block_id,  
  blocks,  
  owner||'.'||segment_name  segment  
from  
  dba_extents  
where  
  tablespace_name = upper('&ts')  
union  
select  
  tablespace_name  tablespace,  
  file_id,  
  block_id,  
  blocks,  
  '&lt;free&gt;'  
from  
  dba_free_space  
where  
  tablespace_name = upper('&ts')  
order by  
  1,2,3  
/  
  
undef ts  
 
 
----------- cut ---------------------- cut -------------- cut -------------- 
 
 
========= 
Examples: 
========= 
 
Tablespace    	File  	Block Id    	Size    Segment     
--------------	---- 	-------         ----------------------- 
USERS			5		1	1 &lt;file hdr&gt;  
			2		5	SYSTEM.UUU 
			7       	5 	FRAN1.TAB_FRAN1   
			12		5 	FRAN1.TAB_FRAN2 
			17		2	SCOTT.UN_NAME 
			19		5	SCOTT.GTEMP 
			24		20	CBLAKEY.GASLOG 
			44		25	CBLAKEY.GASTMP 
 			69		5	CBLAKEY.FILL_UP_NO_PK 
			74		5	JERSON.TEST 
 			79		5	SCOTT.VCARBONN2 
			84		5	BEDNAR.MARTIN1  
			89		5	CHAGA.YOU 
			94		5	CHAGA.SYS_C001757 
			99		10	CHAGA.FOO 
			109		5	SCOTT.CR_FILES  
			114		5	SCOTT.CR_FILE_DATA 
 
 


+==+

Diagnostics and References:



2. Soln# 2067778.6  TALES FROM THE SCRYPT (TFTS) OVERVIEW

Solution ID         : 2067778.6
For Problem         : 1019474.6
Affected Platforms  : Generic: not platform specific
Affected Products   : Oracle Server - Enterprise Edition V7
Affected Components : RDBMS V07.XX
Affected Oracle Vsn : V07.XX

Summary:
TALES FROM THE SCRYPT (TFTS) OVERVIEW

+=+

  
=======================  
Tales from the Scrypt   
=======================  
  
THE SCRIPT AND RELATED INFORMATION ARE CONTAINED IN THE  
PROBLEM SECTION OF THIS DOCUMENT 
 
 
=========  
Abstract:  
========= 
  
The "Tales from the Scrypt" (TFTS)series is a collection of scripts, SQL  
statements and PL/SQL functions/procedures.  It is an attempt to organize in a  
central location and single format many of the scripts that one might use in  
daily database activities.  
  
Material has been supplied by Worldwide Support analysts, Oracle instructors,  
consultants, field support personnel, Oracle users and others. It is our hope  
that this collection will continue to grow.  
   
The entries in this collection have received varying levels of testing, but in  
ALL cases, you should test these scripts yourself in a non-production  
environment before relying on them.  
  
  
  
=============================  
A Note from the Scryptmaster:  
=============================  
  
I have modified very few of these scripts and have written none for the TFTS   
archive at the time of this document.  As such, questions directed to me   
regarding the proper use of these scripts or 'why' a script was written in a  
particular manner will receive no response.  If you are an Oracle employee, 
these should be directed to one of the internal mailing lists that have 
ownership of the subject issue. If you are an Oracle customer, you might try 
posting your question on the approprirate Oracle BBS. 
 
However, I am always interested in improving/adding scripts to the series.  
If you have a modification, or would like to donate a script to be included in  
this series, please email it to me at the address below.    
  
For any script submitted, I will assume that you have given permission for  
Oracle to freely distribute it via this series.  If you are the author and  
wish credit, please include your name, clearly indicated as the author and I  
will put it in the document.   
  
I do not guarantee that all scripts submitted will be included in this series.  
  
  
Please submit material to:  
  
	Matthew R. Morris  
	Scryptmaster  
	MRMORRIS@us.oracle.com  
 
r

+==+

References:


</PRE>
</BODY>
</HTML>
