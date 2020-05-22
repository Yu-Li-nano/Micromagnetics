'''
This python code is for mumax3 [1] lovers/beginners who don't want to 
be bother with codings of batch processing.

Advantages of this code:
1. Run many mumax3 simulations (10+) by only one-line command;
2. Run mumax3 simulations without input of full filenames;
3. Filename including wildcards is supported even in Windows OS.

~~~~~~~  One-minute tutorial  ~~~~~~~
1. If you want to run from .py source code, you need:
        python 3.x (I'm using python 3.7)
        pip install argparse

    You may also use the pre-complied .exe version.

2. Copy this file into the folder which contains "*.mx3" files,
    or add filepath into environment variables.

3. In the folder, you have many mumax3 files with filenames include
    "keywords", for example:
        keywords_1.mx3, keywords_2.mx3, keywords_3.mx3, ..., keywords_n.mx3
    or
        aa_keywords.mx3, bb_keywords.mx3, cc_keywords.mx3, ..., nn_keywords.mx3
    or even
        aa_keywords_1.mx3, bb_keywords_2.mx3, cc_keywords_3.mx3, ..., nn_keywords_4.mx3
   
    You can just type:
        Python4mumax3 keywords
    which is identical to run:
        mumax3 -cache="T:/cache" *keywords*.mx3

    Then it will build a list of the files *keywords*.mx3, and run them one by one.

    *** Tip: space in keywords is supported by using double quotation marks, eg.
        Python4mumax3 "key words"

[1] https://mumax.github.io
'''
import os
import argparse
import warnings
import glob
from time import time
import sys
warnings.filterwarnings("ignore") # ignore the warnings

parser = argparse.ArgumentParser(description='search for "*.mx3" ')
parser.add_argument('keywords_args',default= '*',nargs='?',
    help='input the "keywords" to run "*keywords*.mx3", \
    leave it blank to run all "*.mx3" files')
args = parser.parse_args()
keywords_args=args.keywords_args

if __name__ == '__main__':
    time_start = time() # time @ simulations start
    files = glob.glob("*%s*.mx3" %keywords_args) # search "*.mx3" in the folder
    Mumax_cache = "T:/cache" # path of the Mumax3 cache folder
    # use cache folder will save the time of building demag kernal, if you 
    # turn on the demag field and run lots of codes with the same gridsize and PBC
    command='mumax3 -cache=%s' %Mumax_cache
    if len(files): # if there are "*.mx3" files in the folder 
        for ii in range(0,len(files)):
            command=command+' '+'"'+files[ii]+'"'
        os.system(command)
        # generate a mini report of the results
        print('------------------------Mission complete------------------------')
        print('\n')
        print('Mumax3 filename(s):')
        for i in range(0,len(files)):
            print(files[i])
        # In case you were busying with other work and forgot your mumax jobs
        print('Folder path: %s' %os.getcwd())
        time_end = time()  # time @ simulations finish
        tt = time_end - time_start
        print('Total runtime: %1.1f s' %tt)
        os.system('pause')
        if sys.platform == 'win32':
            os.system('explorer "%s"' %os.getcwd()) # for windows system open the folder path
    else:
        print('No file to run, please try it next time...')
    