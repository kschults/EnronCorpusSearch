import os
import shutil

outdir = 'emails'
indir = 'inemails'

outdirpath = os.path.join(os.getcwd(), outdir)

seen = 0

for dirname, dirnames, filenames in os.walk(indir):
    for filename in filenames:
        outpath = os.path.join(outdirpath, str(seen))
        shutil.copy(os.path.join(dirname, filename), outpath)
        seen += 1