#!/usr/bin/env python3

import pandas as pd
import matplotlib.pyplot as plt
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("--assembly", required=True)
parser.add_argument("--clusters", required=True)
parser.add_argument("--sample", required=True)
args = parser.parse_args()

assembly_file_name = args.assembly
cluster_file_name = args.clusters
sample_name = args.sample

def load_protein_names(assembly_file):
    
    protein_id_to_name_dict = {}
    
    with open(assembly_file, 'r') as f:
        current_protein_id = None
        for line in f:
            line = line.strip()
            if line.startswith('>'):
                parts = line[1:].split()
                current_protein_id = parts[0]
                protein_name = ' '.join(parts[1:]) if len(parts) > 1 else current_protein_id
                protein_id_to_name_dict[current_protein_id] = protein_name
    
    return protein_id_to_name_dict

protein_id_to_name_dict = load_protein_names(assembly_file_name)

# Get copy numbers of each paralog
cluster_df = pd.read_csv(cluster_file_name, sep='\t', header=None, names=['cluster_id', 'protein_id'])
copy_number_df = cluster_df.groupby('cluster_id').size().reset_index(name='count')
copy_number_df = copy_number_df.sort_values(by='count', ascending=False)
copy_number_df['protein_name'] = copy_number_df['cluster_id'].map(protein_id_to_name_dict)
copy_number_df = copy_number_df.rename(columns={'cluster_id': 'protein_id'})

# Export summary copy number data to a TSV file
df_to_export = copy_number_df[['protein_id', 'protein_name', 'count']]
export_file_name = f"{sample_name}_paralog_copy_numbers.tsv"
df_to_export.to_csv(export_file_name, sep='\t', index=False)

# Plot the top 20 paralogs
plt.figure(figsize=(10, 6))
plt.barh(copy_number_df['protein_name'].head(20), copy_number_df['count'].head(20), color='skyblue')
plt.xlabel('Copy Number')
plt.title(f'Top 20 Paralogs in {sample_name}')
plt.gca().invert_yaxis()
plt.tight_layout()
plt.savefig(f"{sample_name}_top_paralogs.png", dpi=300)
