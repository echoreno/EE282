#Project analysis proposal
==========================

#Introduction

The Global Ocean Ship-based Hydrographic Investigations Program (GO-Ship) is an international  
effort aiming to link microbial biodiversity with ecosystem functioning in marine  
environments. To do so, eight cruises have collected and published a dataset of 971 ocean  
surface water metagenomes and the corresponding physical and chemical variables coming from the   
Atlantic, Pacific and Indian Ocean (Larkin et al., 2021). As a result, different articles have  
started to be published which evaluate the biogeography of bacterial communities and their  
relation to ocean nutrient  limitation (Larkin et al., 2022; Ustick et al., 2022).  In this  
project, I am aiming to extract and summarize the marine fungi-related data coming from the  
cruise AMT-28 2018 belonging to GO-Ship, in a first approach to explore basic ecological  
questions regarding the taxonomic and functional diversity of marine fungi in the afore  
mentioned dataset.  

#Dataset

The dataset belonging to the AMT-28 2018 consist of 64 metagenomes obtained from a transect that 
crosses the Atlantic Ocean from South America to Europe. These metagenomes have been already  
processed and stored as unigenes in the catalog of Global Microbial Gene Catalog v1.0 (GMGC). In
particular, three metadata files containing different information can be downloaded directly in 
the online page of the [catalog](https://gmgc.embl.de/):

1. GMGC10.gene-environment.tsv.gz: it contains unigenes uploaded by multiple researchers to the 
catalog, and the different environments from which they were obtained. The unigenes of interest 
are those present in "marine" environment, which were obtained from the cruise AMT-28 2018.
2. GMGC10.taxonomy.tsv.gz: it shows the unigenes from different environments and the taxa to  
which they are assigned. 
3. GMGC10emapper2.annotations.tsv.gz: it contains the unigenes from different environments and  
their functional annotation.

#Analysis  

The proposed analysis broadly consists on two steps:

1. Extraction of the data of interest.
2. Summary of the data.

The first step to extract the data from the combined 64 metagenomes is to identify and obtain  
the unigenes from the "marine" environment in the GMGC10.gene-environment.tsv.gz. Subsequently, 
the marine unigenes specific for fungi will be extracted. The Phyton libraries "pandas" and  
"nunpy" will be used to select the data of interest from the mentioned database. Once that  
marine fungi unigenes are identified, they will be extracted from the two remaining databases  
with the R library "dplyr" (function leftjoin).  

To summarize the data it is proposed to plot the relative abundance of different fungal taxons  
based on the number of different genes present in each taxon. In addition, a histogram of the  
most abundant genes related to nutrient cycling will be provided. Both plots are going to be  
obtained either with the R library "ggplot2" or Python library "matplotlib". Due to the large  
amount of data in the combined 64 metagenomes, and the process of learning the programming  
language Python, this work will provide a first approach to explore the taxonomic and functional 
diversity of marine fungi from the samples collected by the cruise AMT-18 in the Atlantic Ocean.  


#References

1. Larkin, A.A., Garcia, C.A., Garcia, N. et al. (2021). High spatial resolution global ocean  
metagenomes from Bio-GO-SHIP repeat hydrography transects. Sci Data, 8: 107.  
https://doi.org/10.1038/s41597-021-00889-9
2. Larkin, A.A., Hagstrom, G.I., Brock, M.L. et al. (2022). Basin-scale biogeography of  
Prochlorococcus and SAR11 ecotype replication. ISME J. https://doi.org/10.1038/s41396-022-01332-6
3. Ustick, L.J, Larkin, A.A., Garcia, C.A., et al. (2021). Metagenomic analysis reveals  
global-scale patterns of ocean nutrient limitation. Science, 372(6539):287-291. https://doi.org/10.1126/science.abe6301






