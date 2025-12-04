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


For this:

    1. create a new conda environment on the same machine you intend to run the workflow:
        conda create -n gtdbtk
    2. change into this env
        conda activate gtdbtk
    3. install the tool:
        conda install -c bioconda gtdbtk=2.3.2


When installation completes a message like the following can be seen:

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


Use the automatic version with the shell script.
Provide the path of the downloaded database in config/config.yaml via the gtdbtk_db keyword.

## PlasClass & PlasFlow
Both packages can not be installed via conda without trouble.

### PlasClass
The PlasClass package was small enough to have been included in this git repo in the pkgs folder.

### PlasFlow (deprecated; not currently included)
PlasFlow still works very nicely and offers some functionality other packages don't,
but it is not maintained anymore and extremely cumbersome to install.
Inclusion as package was also not a good option partly due to its size (65-85Mb).
Therefore it is currently not an active part of the workflow. For potential future
reintegration or additional usage:

Plasflow installation:

    conda create -n plasflow python=3.5
    conda install -c bioconda perl-bioperl perl-getopt-long
    conda install -c anaconda pandas=0.18
    git clone https://github.com/smaegol/PlasFlow.git

When installing tensorflow mind potential issues with same source tree as python.
It is not recommend to clone the plasflow repo into the packages folder, 
since this would require removal of plasflow .git to avoid conflicts.
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
