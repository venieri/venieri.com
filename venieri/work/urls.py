from django.urls import path

from . import views

urlpatterns = [
    # path('', views.index, name='index'),

    path(r'art/<slug:slug>/', views.ArtView.as_view(), name='art'),
    path(r'event/<slug:slug>/', views.EventView.as_view(), name='event'),
    path(r'events/', views.EventListView.as_view(), name='events'),
    path(r'project/<slug:slug>/', views.ProjectView.as_view(), name='project'),
    path(r'projects/', views.ProjectListView.as_view(), name='projects'),
    path(r'page/<slug:slug>/', views.PageView.as_view(), name='page'),
]