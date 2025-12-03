# CobraHy
Hybrid assembly of bacterial genomes utilizing nanopore and illumina reads (COmbined Bacterial Reads Assembly)

# Installation

## Workflow
Clone repo to machine

## GTDBTK
Although CobraHy does internally create a conda environment for GTDBTK, the database download is not included,
because the file size is huge (78Gb).
Therefore a database has to be downloaded separately. The location of the DB can then be provided to the workflow
through the config.yaml.

"""
For this:
    1. create a new conda environment on the same machine you intend to run the workflow:
        conda create -n gtdbtk
    2. change into this env
        conda activate gtdbtk
    3. install the tool:
        conda install -c bioconda gtdbtk=2.3.2
"""

When installation completes a message following message can be seen:
"""
    GTDB-Tk v2.3.2 requires ~78G of external data which needs to be downloaded
    and extracted. This can be done automatically, or manually.

    Automatic:

        1. Run the command "download-db.sh" to automatically download and extract to:
            /home/user/miniforge/envs/gtdbtk/share/gtdbtk-2.3.2/db/

    Manual:

        1. Manually download the latest reference data:
            wget https://data.gtdb.ecogenomic.org/releases/release214/214.0/auxillary_files/gtdbtk_r214_data.tar.gz

        2. Extract the archive to a target directory:
            tar -xvzf gtdbtk_r214_data.tar.gz -C "/path/to/target/db" --strip 1 > /dev/null
            rm gtdbtk_r214_data.tar.gz

        3. Set the GTDBTK_DATA_PATH environment variable by running:
            conda env config vars set GTDBTK_DATA_PATH="/path/to/target/db
"""

Use the automatic version with the shell script.
Within the snakefile in rule classify_gtdbtk, in the shell directive, the first
line has to be edited to fit to the path given in (1.) e.g.:

!!!ToDo: Add GTDBTK_DATA_PATH to config to avoid editing of code in workflow!!!

"mamba env config vars set GTDBTK_DATA_PATH=/homes/user/.conda/envs/gtdbtk/share/gtdbtk-2.3.2/db && "
 would be wrong here and had to be changed to 
"mamba env config vars set GTDBTK_DATA_PATH=/home/user/mambaforge/envs/gtdbtk/share/gtdbtk-2.3.2/db && "

## PlasClass & PlasFlow
Both packages can not be installed via conda without trouble.
Therefore I decided to place them as packages into the pkgs folder.
The PlasClass package is small enough so I could include it in my github repository.
However, PlasFlow is so big (65-85Mb) that I would not want to include it.
It can be downloaded by cloning the PlasFlow repository into the pkgs folder.
To avoid stacking repo within repo, the .git folder within PlasFlow package should be removed.
!!!It is extremely important to be careful to only delete the .git in PlasFLow and not the main workflow!!!
Thus change dir into PlasFLow and run rm .git only there.

Plasflow installation:
conda create -n plasflow python=3.5
conda install -c bioconda perl-bioperl perl-getopt-long
conda install -c anaconda pandas=0.18
clone plasflow repository
HOW TO INSTALL TENSORFLOW BEST (remember issue with same source tree as python)
start with path/to/repo/PlasFlow.py

# Usage
Edit config/config.yaml according to the requirments of your experiment(s).
Create an experiment folder in workflow/data (e.g. "workflow/data/new_experiment").
Generate a Sample_Info.json file that describes each sample/barcode. Entries for fallbacks are optional and only come to bear if classification can't find a related genome.
Sample_Info.json example:
```sh
{
    "barcode01": {
        "name": "Sample1",
        "ref": "",
        "ref_fallback": "Bacterial_assembly_to_use_as_fallback_ref.fna",
        "genus_fallback": "Some_Genus",
        "species_fallback": "Some_species",
        "illumina": [
            "short-reads/A1/A1_ILLUMINA_READS_L1_1.fq.gz",
            "short-reads/A1/A1_ILLUMINA_READS_L1_2.fq.gz"
        ]
    },
    "barcode02": {
        "name": "Sample2",
        "ref": "",
        "ref_fallback": "Bacterial_assembly_to_use_as_fallback_ref.fna",
        "genus_fallback": "Some_Genus",
        "species_fallback": "Some_species",
        "illumina": [
            "short-reads/A2/A2_ILLUMINA_READS_L1_1.fq.gz",
            "short-reads/A2/A2_ILLUMINA_READS_L1_2.fq.gz"
        ]
    },
}
```

Place the required long-read (nanopore) input data (an individual folder of fastq(.gz) file/s for each barcode) into the data folder so it has the following structure: data/{experiment}/{barcodeX}.
Place the associated short-reads (illumina) in a separate sub-folder in the experiment directory so it has the following structure: data/{experiment}/short-reads/{short_reads_for_ont_bcX}.

Start pipeline with (insert desired number of threads for --cores): 
```sh
snakemake --use-conda --cores 32
```

# Create DAG graph
snakemake --dag | dot > DAG.dot
dot -Tpng DAG.dot -o DAG2.png