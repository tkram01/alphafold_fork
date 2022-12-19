#!/bin/bash

fasta=$1
outfolder=AF_models_dropout/ 
#UPDATE the DOWNLOAD_DIR to the location of the AF databases:
DOWNLOAD_DIR=/proj/wallner-b/share/alphafold_data/
AF_path=/proj/wallner-b/apps/alphafoldv.2.2.0/
std_flags="
--db_preset=full_dbs
--uniclust30_database_path=$DOWNLOAD_DIR/uniclust30/UniRef30_2021_06/UniRef30_2021_06
--bfd_database_path=$DOWNLOAD_DIR/bfd/bfd_metaclust_clu_complete_id30_c90_final_seq.sorted_opt
--pdb_seqres_database_path=$DOWNLOAD_DIR/pdb_seqres/pdb_seqres.txt
--uniprot_database_path=$DOWNLOAD_DIR/alphafold_data/uniprot/uniprot.fasta
"

#echo $std_flags
#exit

#Create the MSAs and template search for the $fasta and stop
#python run_alphafold.py $std_flags --model_preset multimer --fasta_paths $fasta --output_dir AF_models_dropout/ --seq_only
#wait until finish, since this is not using GPU it can be performed on CPU only cluster.
#wait

#Alternatively, the MSA will be created by the first run before the inference starts
#generate 10x200 models using v1 & v2 using dropout and templates
python $AF_path/run_alphafold.py $std_flags --model_preset multimer_all --fasta_paths $fasta --output_dir $outfolder/ --nstruct 200 --dropout=True

#generate 10x200 models using v1 & v2 using dropout and notemplates, the --suffix ensures the model names are different since outfolder is the same
python$AF_path/ run_alphafold.py $std_flags --model_preset multimer_all --fasta_paths $fasta --output_dir $outfolder/ AF_models_dropout/ --nstruct 200 --dropout=True --no_templates --suffix no_templates

#generate 5x200 models using v1 using dropout, notemplates, recycles 21, the --suffix ensures the model names are different since outfolder is the same
python $AF_path/run_alphafold.py $std_flags --model_preset multimer_v1 --fasta_paths $fasta --output_dir $outfolder/ --nstruct 200 --dropout=True --no_templates --max_recycles 21 --suffix no_templates_r21

#generate 5x200 models using v2 using dropout, notemplates, recycles 9, the --suffix ensures the model names are different since outfolder is the same
python $AF_path/run_alphafold.py $std_flags --model_preset multimer_v2 --fasta_paths $fasta --output_dir $outfolder/ --nstruct 200 --dropout=True --no_templates --max_recycles 9 --suffix no_templates_r9

#get the score for all models and return a sorted scorefile.
python $AF_path/scores_from_json.py $fasta $outfolder/ > $outfolder/scores.sc



