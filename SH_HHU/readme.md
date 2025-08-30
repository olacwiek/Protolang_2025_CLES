# Open vs. closed semantic spaces

This respository contains matering for replicating the analyses reported on in the paper "Understanding the limits of experiments in language evolution research: Inferences from closed- vs. open-ended semantic paradigms".

The repository is organized as follows:

- data_annotated: This folder contains the annotated data. The data were coded for the "correctness" of the participants' answers on a four-point Likert scale: 0 - meaning is very different (not related or only very distantly related); 1 - meaning is only partly similar; 2 - meaning is very similar but not identical; 3 - same meaning and same phrasing. Some sheets were coded by annotators crowdsourced via Prolific ("Sheets for coders"), others were annotated by members of the project team.
    - final_decisions: This folder contains the annotations that all coders agreed upon after discussion of mismatches / unclear cases.
    - helpers: This folder contains some helper files created by the scripts in the "scripts" folder (see below).
- data_raw: 
    - Ape study participants answers: This folder contains the raw data obtained from the participants who took part in the ape gesture study.
    - Vocalization study participants answers: This folder contains the raw data obtained from the participants who took part in the vocalizations study.
- data_conceptnet: Cosine similarity data obtained from [ConceptNet](https://conceptnet.io/) (Speer et al. 2017).
- scripts: R scripts for data wrangling and analysis.
- WordNet: An analysis using [WordNet](https://wordnet.princeton.edu/) not included in the final paper. See WordNet analysis.pdf for the details of the analysis.



## References

Robyn Speer, Joshua Chin, and Catherine Havasi. 2017. "ConceptNet 5.5: An Open Multilingual Graph of General Knowledge." In proceedings of AAAI 31. 