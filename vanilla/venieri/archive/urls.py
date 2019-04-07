from django.urls import path
from django_distill import distill_path
from django.contrib.sitemaps.views import sitemap

from . import views
from . import models
from . import sitemaps

# def get_index():
#     # The index URI path, '', contains no parameters, named or otherwise.
#     # You can simply just return nothing here.
#     return None
#
# def get_all_events():
#     # This function needs to return an iterable of dictionaries. Dictionaries
#     # are required as the URL this distill function is for has named parameters.
#     # You can just export a small subset of values here if you wish to
#     # limit what pages will be generated.
#     for event in models.Event.objects.filter(is_visible=True):
#         yield {'slug': event.slug}
#
# def get_all_art():
#     # This function needs to return an iterable of dictionaries. Dictionaries
#     # are required as the URL this distill function is for has named parameters.
#     # You can just export a small subset of values here if you wish to
#     # return
#     # limit what pages will be generated.
#
#     for event in models.Art.objects.filter(is_visible=True):
#         yield {'slug': event.slug}
#
# def get_all_project():
#     # This function needs to return an iterable of dictionaries. Dictionaries
#     # are required as the URL this distill function is for has named parameters.
#     # You can just export a small subset of values here if you wish to
#     # limit what pages will be generated.
#     for project in models.Project.objects.filter(is_visible=True):
#         yield {'slug': project.slug}

# urlpatterns = [
#     # path('', views.index, name='index'),
#     distill_path(r'',
#                  views.EventListView.as_view(),
#                  name='events',
#                  distill_func=get_index,
#                  distill_file='index.html'
#                  ),
#     # path(r'art/<slug:slug>/', views.ArtView.as_view(), name='art'),
#     distill_path(r'event/<slug:slug>',
#          views.EventDetailView.as_view(),
#          name='event',
#          distill_func=get_all_events
#          ),
#
#     distill_path(r'bio/', views.BioView.as_view(), name='bio',
#         distill_func = get_index,
#         distill_file = 'bio/index.html'
#     ),
#     distill_path(r'work/', views.ArtListView.as_view(), name='work',
#         distill_func = get_index,
#     distill_file = 'work/index.html'
#     ),
#     distill_path(r'art/<slug:slug>', views.ArtDetailView.as_view(), name='art-work',
#          distill_func=get_all_art),
#     distill_path(r'virtual-world/', views.VirtualWorldView.as_view(), name='virtual-world',
#                  distill_func=get_index,
#                  distill_file='virtual-world/index.html'
#                  ),
#     #path(r'projects', views.ProjectsView.as_view(), name='projects'),
#     # path(r'project/<slug:slug>/', views.ProjectView.as_view(), name='project'),
#     distill_path(r'projects/', views.ProjectListView.as_view(), name='projects',
#         distill_func = get_index
#     ),
#     distill_path(r'project/<slug:slug>', views.ProjectDetailView.as_view(), name='project',
#                  distill_func=get_all_project),
# ]

urlpatterns = [
    path(r'', views.EventPagedView.as_view(), name='events'),
    path(r'events/<int:page>', views.EventPagedView.as_view(), name='events'),
    path(r'event/<slug:slug>', views.EventDetailView.as_view(), name='event'),
    path(r'bio/', views.BioView.as_view(), name='bio'),
    path(r'work/', views.ArtListView.as_view(), name='work'),
    path(r'art/<slug:slug>', views.ArtDetailView.as_view(), name='art-work'),
    path(r'virtual-world/', views.VirtualWorldView.as_view(), name='virtual-world'),
    path(r'projects/', views.ProjectListView.as_view(), name='projects'),
    path(r'project/<slug:slug>/', views.ProjectDetailView.as_view(), name='project'),
    path('sitemap.xml', sitemap, {'sitemaps': sitemaps.maps},
         name='django.contrib.sitemaps.views.sitemap')
   ]