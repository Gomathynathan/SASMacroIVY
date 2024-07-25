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

%let exclusionreportname=wages_Exchange;  /*Name of the report for Exchangeability assumption
 If you leave it blank, this program will give a name as "Exclusion assumption Report" */;


  
%let outcome=lwage;  /*Outcome variable names  */;


%let estimatesreport=wages Estimates report /*Name of the report for the estimates from bootstrapped sample.
If you leave it blank, this program will give a name as "Estimates Report" */;


/*  First step is to check for relevance assumption:Here we check if there is a strong association between exposure and the chosen instrument(s).
We decide it based on the P-value of estimates for the instrument(s). The estimates are reported in a pdf with file name given in the above fileds.*/;

%relevance_assumption;  

/*  Once the relevance assumption is satisfied, we check for exchangeability  assumption: The instrument is not associated with other confounders.
The predicted probabilitis of the instrument is calculated, and divided into 5 quinitles. The standardized absolute mean difference (SMD) is calculated 
among each pair of quintiles (Q1 vs Q2, Q1 vsQ3, and so on), and the maximum of absolute standardized mean difference (SMD) among the pairs is reported 
in a pdf with file name given in the above fileds. SMD < 0.2 is considered good, <0.4 is OK, and >0.5 is not good for IV.  */;

%Exchange_assumption;

/*  Once both assumptions are satisfied, exclusion assumption is to be checked: The instrument (z) is not associated with outcome (y) unless 
it is through exposure (u). It requires subject matter expertise.
When all the assumptions are satisfied,we build the 2SRI( 2 stage residual inclusion) models, bootstrap the samples with 1000 replicates.
The estimates and 95CI from the bootstrapped samples are calculated, and reported in a pdf with file name given in the above fileds.
*/;

%bootstrap;


