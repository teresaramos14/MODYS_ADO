#!/bin/bash
#SBATCH -p ledley-q 
#SBATCH --chdir=/home/alumno19/resultados_eager/
#SBATCH -J eager 
#SBATCH --cpus-per-task=40 
#SBATCH --error=nextflow_%j.err

time nextflow run nf-core/eager -r 2.5.0 -profile docker \
--input '/home/alumno19/bin/FASTQ/ERR1014019.fastq.gz' \
--single_end \                       #IonTorrent solo secuencia en una direccion
--fasta '/home/alumno19/trabajo_def_igv/h19.fasta' \ #Genoma referencia
--qualitymax 64 \                    #ajuste de Phred
--skip_adapterremoval true \         #Saltamos el paso de eliminar adaptadores de Illumina
--clip_min_read_quality 20 \         #Minimo de calidad de base para cortar
--post_ar_trim_front 50 \            #Cortar las 50 últimas bases para quedarnos con aproximadamente 250 reads
--mapper bwamem \                    #Utilizar BWA-MEM
--run_bam_filtering \                #Activa el filtrado de la calidad de mapeo, longitudes de lectura, etc
--bam_mapping_quality_threshold 20 \ #Calidad de mapeo minima para el filtro de lecturas
--bam_filter_minreadlength 50 \      #Longitud minim de lectura que se conserva despues del mapeo
--run_genotyping true \              #Activa el genotipado en los ficheros BAM
--genotyping_tool ug \               #Genotipado usando GATK UnifiedGenotyper
--genotyping_source raw \    
--run_vcf2genome true \              #Crea un fasta de secuencia de conceso basanddo en el VCF de GATK y la referencia original (solo SNP)
--vcf2genome_minq 20 \               #Profundida minima requerida
--vcf2genome_minc 10 \		     #Calidad minima de genotipado a llamar
--run_multivcfanalyzer true \        #Crea una tabla de valores SNP
--write_allele_frequencies true \    #Incluye frecuencias alelicas en la tabla SNP
--min_genotype_quality 30 \
--min_base_coverage 10 \
--min_allele_freq_het 0.3 \
--max_memory '32.GB' \
--max_time '24h' \
--max_cpus 40
--java_opts 'Xmx16g'
