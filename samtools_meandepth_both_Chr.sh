#!/bin/bash
#input and output directories
#change output directory
#run one session
#create slurm output

module load samtools/1.21

input_dir="/gpfs/data/bergstrom/paula/fox_repo/our_genomes/eager_results/deduplication/"
# old version was #/gpfs/data/bergstrom/paula/fox_repo/no_longer_used/data/marked_duplicates


output_dir="/gpfs/data/bergstrom/natalie/nat_fox/output"
mkdir -p "$output_dir/slurmout"
reference="/gpfs/data/bergstrom/ref/fox/mVulVul1/bwa/mVulVul1.fa"

#loop over each folder in input directory
for folder in "$input_dir"; do

	# Loop over each .bam file in the input directory
	for bam_file in "$input_dir"/*_rmdup.bam; do
		echo "bam file" $bam_file
		# Extract the base name, stripping out both '.merged' and '.bam' extensions if present
		base_name=$(basename "$bam_file" | sed 's/_rmdup//; s/\.bam$//')

		echo "base name:" $base_name
		# Define output file paths
		#output_file1="${output_dir}/bothchrtrial.${base_name}.csv"
		output_file="${output_dir}/$base_name.bothChr.txt"
		echo "output file:" $output_file
		# Check if output file already exists
		#if [[ -e "$output_file1" ]]; then
		#		echo "Output file $output_file1 already exists. Skipping..."
		#		continue
		#fi
	#samtools coverage -r chrX /gpfs/data/bergstrom/paula/fox_repo/no_longer_used/data/marked_duplicates/F12232.mdup.bam
	#samtools coverage -r chr1 /gpfs/data/bergstrom/paula/fox_repo/no_longer_used/data/marked_duplicates/F12232.mdup.bam  
	#samtools view -h -b -r chrX $bam_file -o $output_file

		#Submit a Slurm job using --wrap
		sbatch --job-name="filter_x_${base_name}" \
				--error "$output_dir/slurmout/${base_name}.validate.e" \
				--output "$output_dir/slurmout/${base_name}.validate.o" \
				--time=4-0 \
				--mem=16G \
				--cpus-per-task=4 \
				--partition=compute-64-512 \
				--wrap="samtools coverage -r chrX $bam_file >> $output_file && samtools coverage -r chr1 $bam_file >> $output_file"
						
						#awk 'NR==1 || NR==2 || NR==4 {print $7}' $output_file1 >> extract_results.csv

break 
done
#awk 'NR==2 {print $7}' $output_file1 >> Chr_compare_results.csv
#awk 'NR==2 {print $7}' $output_file1 >> Chr_compare_results.csv \
#samtools coverage -r chr1 $bam_file -o $output_file2 \
			#awk 'NR==2 {print $7}' $output_file2 >> Chr_compare_results.csv
			##awk 'NR==2 || NR==4 {print $7}' $output_file2 >> Chr_compare_results.csv
#awk -F',' 'NR==2 || NR==4 {print $7}' $output_file1 >> extract_results.csv