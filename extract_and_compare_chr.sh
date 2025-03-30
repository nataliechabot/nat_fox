#!/bin/bash

input_dir="/gpfs/data/bergstrom/natalie/nat_fox/output"
# old version was #/gpfs/data/bergstrom/paula/fox_repo/no_longer_used/data/marked_duplicates


output_dir="/gpfs/data/bergstrom/natalie/nat_fox/output"
mkdir -p "$output_dir/slurmout"


# Loop over each .bam file in the input directory
for txt_file in "$input_dir"/*_bothChr.txt; do
	echo "input text file" "$txt_file"
	#input_file=$txt_file
	# Extract the base name, strip '.txt' extensions if present
	base_name=$(basename "$txt_file" | sed 's/\.txt$//')
	#s/_rmdup//; s/\.bam$//
	echo "base name:" $base_name
 	# Define output file paths
 	#output_file1="${output_dir}/bothchrtrial.${base_name}.csv"
	output_file="${output_dir}/all_samples_sex_info.csv"
	echo "output file:" $output_file
	  # Check if output file already exists
  	#if [[ -e "$output_file1" ]]; then
    #		echo "Output file $output_file1 already exists. Skipping..."
    #		continue
	#fi
	sampleID="$base_name"
	#path="$txt_file"
	chrX_content=$(echo | awk 'NR==2 {print $7}' $txt_file)
	chr1_content=$(echo | awk 'NR==4 {print $7}' $txt_file) 
	echo "chr1_content: $chr1_content" 
	echo "chrX_content: $chrX_content"

	#Ensure both variables are numeric
			if [[ ! "$chr1_content" =~ ^[0-9]+(\.[0-9]+)?$ ]] || [[ ! "$chrX_content" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then \
				echo "Error: Non-numeric value found in one of the files"
		
				exit 1
			fi
	# Perform the division using bc for floating-point precision
		ratio=$(echo "scale=2; $chrX_content / $chr1_content" | bc)
		echo "Result ratio: $ratio"
	# Set the threshold and compare the result
				#	threshold=0.7
				#	result_comparison=$(echo "$ratio > $threshold" | bc)

				#	if [[ $result_comparison -eq 1 ]]; then
				#		echo "Female"
				#	else
				#		echo "Male"
				#	fi
				#	-o "$output_file"
	#Set the threshold and compare the result
					threshold=.7
				#	result_comparison=$(echo "$result > $threshold" | bc)

					if [[ $ratio > $threshold ]]; then
						echo "Female"
					else
						echo "Male"
					fi
				#	-o "$output_file"
	#awk 'NR==2 || NR==4 {print $7}' "$txt_file" >> "$output_file"

	#Submit a Slurm job using --wrap
 	#sbatch --job-name="extract_and_compare${base_name}" \
     #   	--error "$output_dir/slurmout/${base_name}.validate.e" \
      #  	--output "$output_dir/slurmout/${base_name}.validate.o" \
       # 	--time=4-0 \
        #	--mem=16G \
         #	--cpus-per-task=4 \
         #	--partition=compute-64-512 \
         #	--wrap="awk 'NR==1 || NR==2 || NR==4 {print $7}' "$txt_file" >> "$output_file""

break 
done

#
#awk 'NR==2 {print $7}' $output_file1 >> Chr_compare_results.csv
#awk 'NR==2 {print $7}' $output_file1 >> Chr_compare_results.csv \
#samtools coverage -r chr1 $bam_file -o $output_file2 \
			#awk 'NR==2 {print $7}' $output_file2 >> Chr_compare_results.csv
			##awk 'NR==2 || NR==4 {print $7}' $output_file2 >> Chr_compare_results.csv
#awk -F',' 'NR==2 || NR==4 {print $7}' $output_file1 >> extract_results.csv