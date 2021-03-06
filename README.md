[![MIT License][license-shield]][license-url]
![Issues][issues-url]
![Languages][languages-url]
![Commit][last-commit]

# RNAseq-Arabidopsis-Axenic
RNAseq analysis associated to the article: "Fill the blank"

![Experiment design](images/Ara.png)

Sequence data associated with this repository will be publicly available at NCBI Bioproject: [PRJNA725487][BioProject] (Temporary relase date: 2022-01-01)

## Experimental Design

### Libraries:
- Arabidopsis axenic under California Soil  (3 reps)
- Arabidopsis axenic under Iowa Soil        (3 reps)
- Arabidopsis axenic under Michigan Soil    (3 reps)
- Arabidopsis holoxenic under California Soil  (3 reps)
- Arabidopsis holoxenic under California Soil  (3 reps)
- Arabidopsis holoxenic under California Soil  (3 reps)
- Arabidopsis grown under MS (1 rep)

## Methods

### Quality control
Every library was evaluated using [fastQC][fastqc] and visually examined

```bash
#Inside the fastq folder 
fastqc *
```

### Trimming
The first 11bp were trimmed from each library  
Software used: [TrimGalore][trimg]

```bash
#Trim the first 10 nucleotides of every library
trim_galore --hardtrim3 40 --gzip --fastqc -o ../cleanFastq/ *
```

### Mapping
We used the splicing aware mapper [STAR][star]  
Reference genome: TAIR10  (Download from [Phytozome][phyto])  
Annotation files: Araport11 (Download from [Phytozome][phyto]) 

#### Generating genome indexes
Create an STAR index using the reference genome and the GFF3 files
```bash
#create a directory to store the index files
mkdir STAR_index

#create the index with and overhang of 39 (read size after trimming = 40bp) and genomeSA index adjusted to Arabidopsis small genome size.
STAR --runThreadN 3 --runMode genomeGenerate --genomeDir STAR_index/ --genomeFastaFiles Athaliana_447_TAIR10.fa --sjdbGTFfile Annotation/Athaliana_447_Araport11.gene_exons.gff3 --sjdbOverhang 39 --genomeSAindexNbases 12
```
#### Mapping the RNAseq reads back to the genome 
For a single fastq file

```bash
STAR --runThreadN 2 --genomeDir ../DB/STAR_index/ --readFilesCommand gunzip -c --readFilesIn ../cleanFastq/AC1_AACCAG_L001_R1_001.40bp_3prime.fq.gz --alignIntronMin 30 --alignIntronMax 7000 ???outFilterIntronMotifs RemoveNoncanonicalUnannotated --outFilterMultimapNmax 20 --outFileNamePrefix ./AC1 --outSAMtype BAM SortedByCoordinate --outReadsUnmapped ./
```
For batch processing all the fastq files check the [Mapping Script][mapping]

### Counting
We used the HTseq count library using default settings

For a single bam file
```bash
htseq-count ../Bam/AC1Aligned.sortedByCoord.out.bam ../DB/Annotation/Athaliana_447_Araport11.gene_exons.gff3 --idattr Parent -s no > AC1.txt
```
For batch processing all the bam files check the [Counting Script][counting] 

### Normalization and DGE

Differential gene expression was performed using [DESEQ2][DSlink]       
All the code can be found as an R notebook [here][Rnotebook_main]  
   


## Contact:

Roberto Lozano - rlozano.fi@gmail.com 



<!-- Markdown link & img dfn's -->
[fastQC]: https://www.bioinformatics.babraham.ac.uk/projects/fastqc/
[trimg]: https://github.com/FelixKrueger/TrimGalore
[star]: https://github.com/alexdobin/STAR
[phyto]: https://phytozome.jgi.doe.gov/pz/portal.html#!bulk?org=Org_Athaliana
[mapping]: scripts/mapping.sh
[counting]: script/counting.sh
[BioProject]: https://www.ncbi.nlm.nih.gov/sra/PRJNA725487
[DSlink]: https://genomebiology.biomedcentral.com/articles/10.1186/s13059-014-0550-8
[Rnotebook_main]: script/
[license-shield]: https://img.shields.io/github/license/tc-mustang/RNAseq-Arabidopsis-Axenic?style=for-the-badge
[license-url]: https://github.com/tc-mustang/RNAseq-Arabidopsis-Axenic/blob/main/LICENSE
[issues-url]: https://img.shields.io/github/issues/tc-mustang/RNAseq-Arabidopsis-Axenic?style=for-the-badge
[languages-url]: https://img.shields.io/github/languages/count/tc-mustang/RNAseq-Arabidopsis-Axenic?style=for-the-badge
[last-commit]: https://img.shields.io/github/last-commit/tc-mustang/RNAseq-Arabidopsis-Axenic?color=orange&style=for-the-badge
