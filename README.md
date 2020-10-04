# Experiments for Sparse Parallel Training of Hierarchical Dirichlet Process Topic Models

This directory contains experiments for *Sparse Parallel Training of Hierarchical Dirichlet Process Topic Models* by A. Terenin ([@aterenin](http://github.com/aterenin)), M. Magnusson ([@MansMeg](http://github.com/MansMeg)), and L. Jonsson ([@lejon](http://github.com/lejon)), published in the 2020 Conference on Empirical Methods in Natural Language Processing.

## Running

```
java -Xmx7g -jar PCPLDA-8.0.6.jar --run_cfg=data/cfg_ap.cfg
```

## Code

  - https://github.com/lejon/PartiallyCollapsedLDA.

## Data

  - AP and CGCBIB: https://github.com/lejon/PartiallyCollapsedLDA/tree/master/src/main/resources/datasets.
  - NeurIPS and PubMed: https://archive.ics.uci.edu/ml/datasets/bag+of+words.

## Caveats

  - Due to use of parallelism, random number seeds are used **for initialization only, not for sampling**.
  - CGCBIB and AP are preprocessed to only keep documents with at least 10 tokens.
  - All samplers are in `PCPLDA-8.0.6.jar` except for the direct assignment reference implementation, which is in `mallet-ilda.jar`, and the subcluster split-merge implementation, which is copyrighted by the [authors](http://people.csail.mit.edu/jchang7/code.php) and is available [here](http://people.csail.mit.edu/jchang7/code/hdp_subclusters/hdpmm_subclusters_2014-12-07.tar.gz).