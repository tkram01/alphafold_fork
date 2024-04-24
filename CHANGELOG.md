Manual editing of alphafold2 to extract the protein embeddings 
Changes were made to by-pass the expansive structure prediction and instead extract the internal representations of VHH:LIMA embeddings 
- run_alphafold.py  was modified to BY PASS RELAXATION stage
- modules.py and modules_multimer.py was modified to accept return_represenation=True 
- config.py was modified to have num_recycle =1 

