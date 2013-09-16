#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import sys
import glob
import commands

from fabric.api import run, sudo, local, env
from fabric.contrib import django

env.hosts         = []
env.key_filename  = []
env.user          = ''
env.password      = ''

def insert_coding_utf8():
  """  """

  # '# -*- coding: utf-8 -*-'
  return True


