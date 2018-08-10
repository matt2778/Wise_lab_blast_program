# Wise_lab_blast_program
Convenient local blast tool for non-bioinformaticists in the Wise lab


## INPUT FILES

**1.	Fasta file with sequences of interest**

	Please make sure fasta file is formatted correctly as shown below:
	
>MLOC_12866_gRNA1A
GAAGGAGCACGACGACAACGAGG
>MLOC_12866_gRNA1T
GAAGGAGCACGACGACAACGTGG
>MLOC_12866_gRNA1C
GAAGGAGCACGACGACAACGCGG
>MLOC_12866_gRNA1G
GAAGGAGCACGACGACAACGGGG
>MLOC_12866_gRNA2A
GCTGAATCCACGCATATTGAAGG

	Note that each entry has a sequence description line starting with a ">" character.  Make sure to keep the description 
	to one line only.  Follow the sequence description line immediately with the sequence of interest.  Do not add a space 
	between the sequence description line and the sequence, or between entries, as these will result in errors
	
	Be sure to add the file extention .fa to your fasta file (not .fasta)


**2.	Filled out template file**

	Make a new folder with today's date in your lab blast isilon folder.  For example:
	
	rpwise-lab/general_lab_use/Wise_lab_blast_output/Antony/3-9-2017
	


	Make a copy of the template file from box (lab_blast_template.csv) in the new folder with today's date
	
	Fill out the template blast file with the following information:
	
	-	Your last name
	-	Today's date (please use dashes e.g. 3-9-2017, not "/" as this will cause an error)
	-	Blast type (blastn, blastp, or blastx)
	-	E-value cutoff in either 1e-5 or 0.00001 format (this will limit the blast program returns to matches that meet or are lower than this value)
	-	Query file: the name of the fasta file you will use to search a target database
	-	Database to search: Paste the name of the database you wish to search from the Database_list.csv list file on box (please use the file 
		name e.g. 1-26-2016_Blumeria_SS_mirdeep-p_combined_sRNA_predictions.fa not the label e.g. Blumeria sRNAs)

	Re-name and save the template file with your last name followed by the date (With NO SPACES).  For example:
	
	Chapman_3-9-2017_1.csv



## RUNNING THE SCRIPT

**1.	Logging into speedy server**

	The script 2-6-2017_lab_blast_program_v1.sh is run from a the terminal program accessed on Mac or linux computers.  
  Open up a terminal and log into the speedy server:

ssh your_isu_netID@speedy.ent.iastate.edu
your_isu_password

	Change directories to the folder that contains the 2-6-2017_lab_blast_program_v1.sh script
	
**2.	Running the script**

	The 2-6-2017_lab_blast_program_v1.sh program requires four pieces of information to run:
		-	The name of the script (2-6-2017_lab_blast_program_v1.sh)
		-	The folder containing your fasta file and template file
		-	The name of your template file
		-	The number of processors used to run the blast program (between 1 and 5)
	
	An example of a correct line with the necessary commands:
	
./2-6-2017_lab_blast_program_v1.sh /home/mhunt/Mla6_Bln1_Rar3_panel_smRNA_seq_exp_20239_July2014/data/blast_out/lab_blast/Tests/3-7-2017 Hunt_test5_3-8-2017.csv 5



## OUTPUT FILES

	The 2-6-2017_lab_blast_program_v1.sh script creates two output files upon successfull completion
	
**1.	A csv format file with the following column labels:**

label			description

qseqid			Query Seq-id: the provided sequence identifier in the input fasta file
sseqid			Subject Seq-id: the sequence identifier of the matched database sequence
qlen			Nucleotide length of the query sequence
slen			Nucleotide length of the subject (database match) sequence
qstart			Start of alignment in query
qend			End of alignment in query
sstart			Start of alignment in subject (database match)
send			End of alignment in subject (database match)
pident			Percentage of identical matches
nident			Number of identical matches
length			Alignment length
mismatch		Number of mismatches
gapopen			Number of gap openings
evalue			Expected value
bitscore		Bit score
max_coverge		Maximum match coverage in either query or subject.  In other words the maximum coverage % of the match
stitle			Subject Title (database match sequence identifier)



**2.	A txt file that contains the traditional web blast output** 

	Please be aware of the size of the txt file, as larger searches can result in VERY large files 
  (>1 Gb) and may be too large to open directly on a computer.  Ask a lab bioinformatician for help filtering
  your file in these cases
