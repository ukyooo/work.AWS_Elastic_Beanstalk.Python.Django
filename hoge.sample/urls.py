# -*- coding: utf-8 -*-

from django.conf.urls import patterns, include, url
from django.contrib.staticfiles.urls import staticfiles_urlpatterns

# Uncomment the next two lines to enable the admin:
from django.contrib import admin
from django.contrib import admindocs
admin.autodiscover()

from hoge import settings

urlpatterns = patterns('',
    # Examples:
    # url(r'^$', 'hoge.views.home', name='home'),
    # url(r'^hoge/', include('hoge.foo.urls')),
    url(r'^$',     'hoge.views.hello', name='hoge'),
    url(r'^fuga/', 'hoge.fuga.views.hello', name='fuga'),
    url(r'^piyo/', 'hoge.piyo.views.hello', name='piyo'),

    # Uncomment the admin/doc line below to enable admin documentation:
    url(r'^admin/doc/', include('django.contrib.admindocs.urls')),

    # Uncomment the next line to enable the admin:
    url(r'^admin/', include(admin.site.urls)),
)

urlpatterns += staticfiles_urlpatterns()

