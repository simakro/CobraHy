# rule prokka_expected_ref:
#     input:
#         # asm="results/{experiment}/{barcode}/medaka_{assembler}/consensus.fasta",
#         asm="results/{experiment}/{barcode}/circl_fixstart/medaka_{assembler}_pilon3/medaka_{assembler}_pilon3.oriented.fasta",
#         prot_file=get_ref_proteins
#     output:
#         protgbk_dir=directory("results/{experiment}/{barcode}/prokka_medaka_{assembler}_protgbk_exp"),
#         protg_tsv="results/{experiment}/{barcode}/prokka_medaka_{assembler}_protgbk_exp/{experiment}_{barcode}_{assembler}_prokka_protgbk_exp.tsv"
#     params:
#         genus=get_prokka_genus,
#         # species=get_prokka_species
#     log:
#         "logs/{experiment}/{barcode}/prokka_medaka_{assembler}_exp.log"
#     conda:
#         "envs/prokka.yaml"
#     shell:
#         # "prokka --kingdom Bacteria --genus {params.genus} --species {params.species} {input.asm} --usegenus --outdir {output.genusdb_dir} --prefix {wildcards.experiment}_{wildcards.barcode}_{wildcards.assembler}_prokka_genusdb --force && " 
#         "prokka --proteins {input.prot_file} {input.asm} --outdir {output.protgbk_dir} --prefix {wildcards.experiment}_{wildcards.barcode}_{wildcards.assembler}_prokka_protgbk_exp --force 2>&1 > {log}"
# 
# rule circlator_all:
#     input:
#         asm = "results/{experiment}/{barcode}/{assembly}.fasta",
#         ont_reads = "results/{experiment}/{barcode}/{experiment}_{barcode}_all_sqfilt.fasta"
#     output:
#         "results/{experiment}/{barcode}/circl_all/{assembly}.oriented.fasta"#,
#         # directory("results/{experiment}/{barcode}/circlator")
#     params:
#         # out_prefix = "results/{experiment}/{barcode}/circl_all/{assembly}.oriented"
#         out_dir = directory("results/{experiment}/{barcode}/circl_all")
#     conda:
#         "envs/circlator.yaml"
#     log:
#         "logs/{experiment}/{barcode}/{assembly}/circlator_all.log"
#     shell:
#         "circlator all {input.asm} {input.ont_reads} {params.out_dir} 2>&1 > {log}"
# 
# 
# rule plasflow:
#     input:
#         asm = "results/{experiment}/{barcode}/medaka_{assembler}_pilon3/medaka_{assembler}_pilon3.fasta"
#     output:
#         # "results/{experiment}/{barcode}/circl_fixstart/{assembly}.oriented.fasta"#,
#         # directory("results/{experiment}/{barcode}/medaka_{assembler}_pilon3_gtdbtk")
#         "results/{experiment}/{barcode}/medaka_{assembler}_pilon3_plasflow/medaka_{assembler}_pilon3_plasflow.tsv"
#     params:
#         # out_prefix = "results/{experiment}/{barcode}/circl_fixstart/{assembly}.oriented"
#         # genome_dir = "results/{experiment}/{barcode}/medaka_{assembler}_pilon3",
#         # out_dir= "results/{experiment}/{barcode}/medaka_{assembler}_pilon3_gtdbtk"
#     conda:
#         "envs/plasflow.yaml"
#     log:
#         "logs/{experiment}/{barcode}/medaka_{assembler}_pilon3/plasflow.log"
#     shell:
#         # "curr_env=$(conda info --env | grep '*' | rev | cut -d' ' -f1 | rev) && "
#         # "python $curr_env/lib/python3.5/site-packages/PlasFlow/PlasFlow.py --input {input} --output {output} 2>&1 > {log}"
#         "python pkgs/PlasFlow/PlasFlow.py --input {input} --output {output} 2>&1 > {log}"


# potential tools for adapter clipping/trimming: Scythe, Trimmomatic, cutadapt
# adapter clipping tested and discarded: trim_galore (wrapping cutadapt together with fastqc)

# potential tools for quality trimming: Sickle, Trimmomatic, 

# rule clip_adapters_scythe:
#     input:
#         "results/{experiment}/{barcode}/ilmn_fastqc/fastqc_complete.flag", # this is not required as input for fastqc, but supplies the necessary wildcards and ensures 
#         ilmn_reads=get_ilmn_reads
#     output:
#     params:
#         outdir="results/{experiment}/{barcode}/trim_scythe",
#         adapters=""
#     conda:
#         "envs/scythe.yaml"
#     shell:
#         "scythe -a {params.adapters} -o {input.ilmn_reads}"
#         # "fastqc {input.ilmn_reads} -o {params.outdir}"


# rule homopolish: # Reference guided/based polishing without read information and may conceal variants! Assumes close homology (hence the name) between ref and sample.
#     input:
#         asm="results/{experiment}/{barcode}/medaka_{assembler}/consensus.fasta",
#         # ref="resources/KP202868.1_Murid_herpesvirus_8_isolate_Berlin.fa"
#         ref= "resources/{experiment}/{reference}"
#     output:
#         outdir = directory("results/{experiment}/{barcode}/homopolish_medaka_{assembler}"),
#         outfile= "results/{experiment}/{barcode}/homopolish_medaka_{assembler}/consensus_homopolished.fasta"
#     log:
#         "logs/{experiment}/{barcode}/medaka_{assembler}_homopolish.log"
#     threads:
#         16
#     conda:
#         "envs/homopolish.yaml"
#     shell:
#         "homopolish polish -a {input.asm} -l {input.ref} -m R9.4.pkl -o {output.outdir} -t {threads} 2>&1 > {log}"