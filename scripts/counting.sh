#! /bin/bash

for myfile in `ls /home/roberto/JOYN/Transcriptome/Bam/*bam`; do
    echo "Processing library" $myfile
    short=$(echo $myfile | cut -d"." -f 1 | cut -d"/" -f 7 | sed 's/Aligned//g')
    echo "Sample prefix" $short
    htseq-count ${myfile} /home/roberto/JOYN/Transcriptome/DB/Annotation/Araport11_GTF_genes_transposons.Mar172021.gtf -s no > /home/roberto/JOYN/Transcriptome/Counts/${short}.txt

done



