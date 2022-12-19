#!/usr/bin/env python

import os
import json
import pathlib
import sys
import glob

fasta=sys.argv[1]
output_dir_base=sys.argv[2]

fasta_names = pathlib.Path(fasta).stem
output_jsons = os.path.join(output_dir_base, fasta_name,'result*.pkl.json')

for jsons in glob.glob(output_jsons):
    with open(jsons,'rb') as f:
        d=json.load(f)
        #        print(jsons,d)
        model=jsons.replace('result','unrelaxed').replace('.pkl.json','.pdb')
        print(model,d['ranking_confidence'])
    
