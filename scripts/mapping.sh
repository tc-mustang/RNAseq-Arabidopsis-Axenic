#! /bin/bash

for myfile in `ls /home/roberto/JOYN/Transcriptome/cleanFastq`; do
    echo "Processing library" $myfile
    short=$(echo $myfile | cut -d"_" -f 1)
    echo "Sample prefix" $short
    STAR --runThreadN 2 --genomeDir /home/roberto/JOYN/Transcriptome/DB/STAR_index --readFilesCommand gunzip -c --readFilesIn /home/roberto/JOYN/Transcriptome/cleanFastq/${myfile} --alignIntronMin 30 --alignIntronMax 7000 –outFilterIntronMotifs RemoveNoncanonicalUnannotated --outFilterMultimapNmax 20 --outFileNamePrefix /home/roberto/JOYN/Transcriptome/Bam/${short} --outSAMtype BAM SortedByCoordinate --outReadsUnmapped /home/roberto/JOYN/Transcriptome/Bam/

done



