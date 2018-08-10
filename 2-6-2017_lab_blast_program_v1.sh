#!/bin/bash

#	This script will run the ncbi-blast/2.4.0+ suite with a template file for general lab use
#	The destination folder has to be created first (name folder, and date sub-folder)

#	The first read in $1 will be the working folder created for the current blast search (no / symbol at end)
#	The second read in $2 will be the name of the template file
#	The third read in $3 will be the number of threads for the blast searches

cd "$1"

#	Make variables from template csv file

lastName=$(cat "$2" | grep "your_last_name" | awk -F, '{print $2}')								#	lab member's last name
todayData=$(cat "$2" | grep "today_date" | awk -F, '{print $2}')								#	date of blast
blastType=$(cat "$2" |  grep "blast_type" | awk -F, '{print $2}')								#	blast flavor
shortBlast=$(cat "$2" | grep "short_query_sequence" | awk -F, '{print $2}')						#	short blast (yes or no)
if [ "$shortBlast" == "yes" ]; then
	blastSubType="blastn-short"
else
	blastSubType=$(cat "$2" |  grep "blast_type" | awk -F, '{print $2}')
fi
eValue=$(cat "$2" | grep "e_value" | awk -F, '{print $2}' | sed 's/"//g')						#	chosen e-value cut-off
queryFileV1=$(cat "$2" | grep "query_file" | awk -F, '{print $2}')								#	full query file name
queryFileV2=$(cat "$2" | grep "query_file" | awk -F, '{print $2}' | sed 's/\.fa//g')				#	shortened query file name for outfile name use
dataBaseV1=$(cat "$2" | grep "database_to_search" | awk -F, '{print $2}')						#	full database file name
dataBaseV2=$(cat "$2" | grep "database_to_search" | awk -F, '{print $2}' | sed 's/\.fa//g')		#	shortened database file name for outfile name use

#	Make output files (both csv and txt)

touch holder.csv																																			#	temp output csv file
touch holder_v2.csv																																			#	temp output csv file
outFileNameV1=$(echo $todayData.$lastName.$queryFileV2.query.$dataBaseV2.db.$blastType.csv | sed 's/\./_/g' | sed 's/_csv/\.csv/g' | sed 's/ //g')			#	csv outfile name (tabular format)
outFileNameV2=$(echo $todayData.$lastName.$queryFileV2.query.$dataBaseV2.db.$blastType.txt | sed 's/\./_/g' | sed 's/_txt/\.txt/g' | sed 's/ //g')			#	txt outfile name (standard blast web output format)



#	Run blast searches

module unuse /opt/rit/spack-modules/lmod/linux-rhel7-x86_64/Core
module use /opt/rit/modules
module load ncbi-blast/2.4.0+


#	Run csv output blast

$blastType -task $blastSubType -evalue $eValue -query $1/$queryFileV1 -out holder.csv -db /home/bigdata/mhunt/rpwise-lab/general_lab_use/blast_databases/$dataBaseV1 -outfmt "10 qseqid sseqid qlen slen qstart qend sstart send pident nident length mismatch gapopen evalue bitscore stitle" -num_threads "$3"

#	Add variable ​coverage to output csv.  The general formulas are shown below:

#	​coverage = max(q_coverage, s_coverage)

#	q_coverage​ = 100*((abs(qstart - qend) + 1) / qlen)

#	s_coverage​ = 100*((abs(​s​start - ​s​end) + 1) / ​s​len)

touch coverage.txt

filename="holder.csv"
filelines=`cat $filename`


IFS=$'\n'
for line in $filelines ; do
	q_coverage=$(echo -e "$line" | awk -F, '{ print (100*(sqrt(($5 - $6)^2)+1)/$3)}')
	s_coverage=$(echo -e"$line" | awk -F, '{ print (100*(sqrt(($7 - $8)^2)+1)/$4)}')
	maxCoverage=$(awk -v var1="$q_coverage" -v var2="$s_coverage" 'BEGIN { if (var1 > var2) print var1; else print var2 }')
	echo -e "$maxCoverage" >> coverage.txt
	
done
unset IFS

#	Paste coverage file to right side of csv blast file


paste -d"," holder.csv coverage.txt > holder_v2.csv	

#	Move max_coverage column from last to second to last position, for ease of reading if not using nr or nt databases

if [ "$dataBaseV1" != "nr_2-7-2017/nr.fa" ] || [ "$dataBaseV1" != "nt_2-8-2017/nt.fa" ]; then
	cat holder_v2.csv | awk -F, 'BEGIN { OFS = "," } {print $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$NF,$16}' > "$outFileNameV1"
	rm holder_v2.csv
else
	mv holder_v2.csv "$outFileNameV1"
fi


#	Run txt output blast

$blastType -task $blastSubType -evalue $eValue -query $1/$queryFileV1 -out $outFileNameV2 -db /home/bigdata/mhunt/rpwise-lab/general_lab_use/blast_databases/$dataBaseV1 -outfmt "0" -num_threads "$3"


sed -i '1i qseqid,sseqid,qlen,slen,qstart,qend,sstart,send,pident,nident,length,mismatch,gapopen,evalue,bitscore,max_coverage,stitle ' $outFileNameV1		#	Add a header to the csv file

#	Remove temp files

rm holder.csv
rm coverage.txt

