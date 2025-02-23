#!/bin/bash

input_dir="/gpfs/data/bergstrom/natalie/nat_fox/output/"

output_dir="/gpfs/data/bergstrom/natalie/nat_fox/output"
mkdir -p "$output_dir/slurmout"
# Loop over each .txt file in the input directory
for txt_file in "$input_dir"/*.txt; do
	echo "text file" $txt_file
	# Extract the base name, stripping out both '.merged' and '.bam' extensions if present
	base_name=$(basename "$txt_file" | sed 's/_rmdup//')

	echo "base name:" $base_name
 	# Define output file paths
 	output_file="${output_dir}/filtereddepth.${base_name}"
	echo "output file:" $output_file
	  # Check if output file already exists
  	if [[ -e "$output_file" ]]; then
    		echo "Output file $output_file already exists. Skipping..."
    		continue
	fi
	
echo "Mean Depth: $meandepth"

sbatch --job-name="filter_depth${base_name}" \
        	--error "$output_dir/extract_data/${base_name}.validate.e" \
        	--output "$output_dir/extract_data/${base_name}.validate.o" \
        	--time=4-0 \
        	--mem=16G \
         	--cpus-per-task=4 \
         	--partition=compute-64-512 \
			--wrap="meandepth=$(awk 'NR==2 {print $7}' $txt_file > $output_file)"
		
			
#do i need to put output on the wrap line?
break
done

# Extract the meandepth value from the file (assuming data is in the first line)
# Output the meandepth
