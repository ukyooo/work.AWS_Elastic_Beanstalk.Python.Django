# -*- coding: utf-8 -*-

import os
import sys

from django.http import HttpResponse

def hello(request):
  return HttpResponse('Hello my name is fuga.')

