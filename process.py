import os
import json
import hashlib

indir = 'emails'
outdir = 'index'
outdirpath = os.path.join(os.getcwd(), outdir)

NUM_DICTS = 10

dicts = [dict() for i in range(NUM_DICTS)]

def process_email(email_id, email):
    def hash_to_int(word):
        sha1 = hashlib.sha1(word)
        digest = sha1.hexdigest()
        number = int(digest[:10], 16) #Use only the first half so we can fit the result in a C type
        return to_int64(number)

    seen_words = set()
    for line in email:
        for word in line.split():
            if word in seen_words:
                continue
            seen_words.add(word)
            dictnum = hash_to_int(word) % NUM_DICTS
            emails = dicts[dictnum].get(word, None)
            if emails is None:
                emails = []
            emails.append(email_id)
            dicts[dictnum][word] = emails
        
    

for dirname, dirnames, filenames in os.walk(indir):
    for filename in filenames:
        filepath = os.path.join(dirname, filename)
        with open(filepath, 'r') as email:
            process_email(filename, email)
        break
    break

written = 0
for d in dicts:
    outname = 'dict' + str(written)
    outfilename = os.path.join(outdirpath, outname)
    with open(outfilename, 'w') as out:
        out.write(json.dumps(d))
        written += 1