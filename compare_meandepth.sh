#!/bin/bash


input_dir="/gpfs/data/bergstrom/natalie/nat_fox/output"


output_dir="/gpfs/data/bergstrom/natalie/nat_fox/output"
mkdir -p "$output_dir/slurmout"

#Figure out looping
# Loop over each .txt file in the input directory
for txt_file in "$input_dir"/filtereddepth.chr?.*.txt; do
# for for txt_file in "$input_dir"/chr*.txt; do
	echo "text file" $txt_file
	# Extract the base name, stripping out both '.merged' and '.bam' extensions if present
	base_name=$(basename "$txt_file" | sed 's/filtereddepth//; s/.chr?//')

	echo "base name:" $base_name
 	# Define output file paths
 	output_file="${output_dir}/sex_${base_name}"
	echo "output file:" $output_file
	  # Check if output file already exists
  	if [[ -e "$output_file" ]]; then
    		echo "Output file $output_file already exists. Skipping..."
    		continue
	fi


	#Submit a Slurm job using --wrap
 	sbatch --job-name="compare_chr_depth${base_name}" \
        	--error "$output_dir/slurmout/${base_name}.sex.validate.e" \
        	--output "$output_dir/slurmout/${base_name}.sex.validate.o" \
        	--time=4-0 \
        	--mem=16G \
         	--cpus-per-task=4 \
         	--partition=compute-64-512
         	--wrap="chr1_content=$(awk '{sum += $1} END {print sum}' "$input_dir"/filtereddepth.chr1.*.txt)
					chrX_content=$(awk '{sum += $1} END {print sum}' "$input_dir"/filtereddepth.chrX.*.txt)

					echo "chr1_content: $chr1_content" echo "chrX_content: $chrX_content"

					#Ensure both variables are numeric
					if [[ ! "$chr1_content" =~ ^[0-9]+(\.[0-9]+)?$ ]] || [[ ! "$chrX_content" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
						echo "Error: Non-numeric value found in one of the files"
						exit 1
					fi

					# Perform the division using bc for floating-point precision
					result=$(echo "scale=2; $chrX_content / $chr1_content" | bc)

					echo "Result: $result"

					# Set the threshold and compare the result
					threshold=0.6
					result_comparison=$(echo "$result > $threshold" | bc)

					if [[ $result_comparison -eq 1 ]]; then
						echo "Female"
					else
						echo "Male"
					fi
					-o $output_file"
break
done


