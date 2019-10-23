/******************************************************************************/
/*Program: histogram_multi                                                    */
/*Author: Ting Wang                                                           */
/*Email:  twang@ucdavis.edu                                                   */
/*Institution: UCDavis                                                        */
/*Date: May 11, 2009                                                          */
/*Purpose: compute the histograms of multi-simulations for WHAM use           */
/*COMPILATION: cc -o histogram_multi  histogram_multi.c -lm                   */
/*USAGE: >histogram_multi hist_metadatafile  reaction.histogram               */
/*EXAMPLE: > $SCRIPT2/histogram_multi hist_metadatafile  reaction.histogram   */
/******************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#define MAX_SIMULATIONS 100
#define MAX_POINTS 10000
#define MAX_BIN 200

int main (
	int argc,         /* Number of args */
	char ** argv)     /* Arg list       */
{
	FILE  *fin, *fout, *fdata;
        int num, start,i,j,k,icount,mark, bin_number, count[MAX_SIMULATIONS+1][MAX_BIN+1];
        float min, max, size,value, div[MAX_BIN+1], time;
	char line[200],line_data[120], name[MAX_SIMULATIONS+1][120];
	
        if((fin = fopen(argv[1] , "r"))==NULL)
	  {printf("Input file can not be opened .\n");exit(0);}
   	if((fout = fopen(argv[2], "w"))==NULL)
	  {printf("OUT File  can not be written .\n");exit(0);}
	
	while (fgets(line,200,fin))
	{        
		if (strncmp(line,"#",1)==0)
		{   
		  /*skip this comment line */
		  k=1;
		}
		else 
		{
			
		    sscanf(line,"%d %g %g %g %d\n",&num,&min,&max,&size,&start);
		    bin_number = (max-min)/size+1;	
		    	
		   for (i =1; i<=bin_number; i++){
                     div[i]=min+size*(i-1);
                   } 
		
		fscanf(fin,"%s\n", name[k]);
		 k++;
		printf("%d\n",k);
		}

	}/* end of while fgets */

	for (i=1;i<=num;i++){
          
	  if((fdata = fopen(name[i], "r"))==NULL)
	    {printf("Simulation file %s can not be opened .\n");exit(0);}

	  for (j=1; j<=start; j++) fgets(line_data,120,fdata); /* Skip the first start lines */
        
	  for (icount =1; icount<=bin_number; icount++){ 
            count[i][icount]=0;
          }
	  while (fgets(line_data,120,fdata))
	  {
	    sscanf(line_data,"%f %f\n", &time, &value);
	    icount=1; mark=0;
	    while ((icount<=bin_number) && mark==0){
                if ((value>=div[icount]) && (value<div[icount+1])) {count[i][icount]++; mark=1;}
		icount++;
	     }
	  }
	  fclose(fdata);
	}/* end of for i<=num */

        fprintf(fout,"# %d simulations, hist_min=%13.3f, hist_max=%13.3f, %d bins\n", num, min, max, bin_number );	
        for (i=1; i<=bin_number; i++){
	  fprintf(fout,"%13.3f",div[i]);
	  for(j=1; j<=num; j++)	 {fprintf(fout,"%6d",count[j][i]); }
          fprintf(fout,"\n");
	}

        fclose(fin);
        fclose(fout);

 return(1);
}

