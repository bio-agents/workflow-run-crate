# -*- coding: utf8 -*-
from __future__ import (absolute_import, division, print_function,
                        unicode_literals)
from past.builtins import xrange

import iteragents
from .bp_types import RecursiveMemory
from pycompss.api.task import task

@task(returns=1)
def init_recursive_memory(config):
    n_bands = config.n_freq_bands
    nsamples = int(config.time_lag / config.delta)
    overlap = int(config.t_overlap / config.delta)
    # Create a dictionary of memory objects
    rec_memory = dict()
    for trid, wave in iteragents.product(config.trids, config.wave_type):
        # Each entry of the dictionary is a list of memory objects
        # (with n_bands elements)
        rec_memory[(trid, wave)] =\
            [RecursiveMemory(trid=trid, wave=wave, band=n,
                             nsamples=nsamples, overlap=overlap,
                             filter_npoles=config.filter_npoles)
             for n in xrange(n_bands)]
    return rec_memory
