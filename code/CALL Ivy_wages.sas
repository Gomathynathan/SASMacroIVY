/********************************************************************************************************/
/*       NAME: CALL IVY.SAS                                         				  	*/
/*      TITLE: Calling IVY macro with an example 		*/
/*     AUTHOR: Gomathy Parvathinathan, MS, Stanford University                                          		*/
/*		   OS: Windows 7 Ultimate 64-bit							*/
/*	 Software: SAS 9.4										*/
/*       DATE: July 15 2024                                       					*/
/*DESCRIPTION: This program shows how to call the IVY.sas macro					*/
/********************************************************************************************************/

proc import datafile="..\data\educ_wages.csv" dbms=csv out=wages ;
run;
proc contents data=wages;
run;

data wages_1;
set wages;
married_1=(married=1);
drop var1 married;
run; 
proc contents data=wages_1;run;

/************************************************************************************************************
* Now, let's set up parameters below
*************************************************************************************************************/

%include ".\IVY.sas";
%let datain=" "; 				/*Location of permanent SAS dataset. Leave it blank, if your dataset is in the work library*/	
%let dataout="..\results";				/*Location of one-pager report will be saved*/												
%let dataset=wages_1;					/*Name of the dataset*/	;				
%let relevancereportname=wages_relevance;				/*Name of the report for relevance assumption
						  If you leave it blank, this program will give a name as "Relevance assumption Report" */
%let instrument= nearc4;   /*Instrument variable name. It could be more than 1 variable too*/;
%let endovar=educ;     /*Endogenous variable name */;

%let instrumentname=distance;
%let isendo_binary="no";  /* Is endognous variable binary? .Answer "yes" or "no" as appropriate       */;
%let numvar=  age exper expersq ;   /*Numerical variable names  */;
%let catvar=  black married_1;  /*Categorical variable names. Each categorical variable should be of 2 levels only.For example: if there are 3 different illness say illness<=1,  1 to3 illness, and >3 illness.
Then 3 categorical variables to be created each with 2 levels :0 and 1 for illness<=1, illness between 1 and 3, and illness>3 */;

%let exclusionreportname=wages_Exclusion;  /*Name of the report for exclusion assumption
 If you leave it blank, this program will give a name as "Exclusion assumption Report" */;


  
%let outcome=lwage;  /*Outcome variable names  */;


%let estimatesreport=wages Estimates report /*Name of the report for the estimates from bootstrapped sample.
If you leave it blank, this program will give a name as "Estimates Report" */;




%relevance_assumption;

%Exchange_assumption;

%bootstrap;


