from django.conf import settings
from django.views.generic import DetailView, ListView, TemplateView
from meta.views import MetadataMixin
from bakery.views import BuildableDetailView, BuildableListView, BuildableTemplateView
from django.core.paginator import Paginator

from . import models


class SEO(object):
    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['meta'] = self.get_object().as_meta(self.request)
        print('context', context)
        return context


class EventDetailView(MetadataMixin, BuildableDetailView):
    model = models.Event
    context_object_name = 'event'
    template_name = 'event_detail.html'


class EventPagedView(MetadataMixin, BuildableListView):
    title = 'Lydia Venieri'
    description = 'The website of the greek artist, Lydia Venieri'
    image = 'http://venieri.com/venieri/Lydia_Venieri/Lydia_Venieri_files/shapeimage_1.png'
    url = '/'
    template_name = 'event_list.html'  # Default: <app_label>/<model_name>_list.html
    context_object_name = 'events'  # Default: object_list
    _paginate_by = 6
    paginate_by = None if settings.STATIC_SITE else _paginate_by
    # build_path='/'
    queryset = models.Event.objects.filter(is_visible=True)
    page = None

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        if settings.STATIC_SITE:
            page = self.page if self.page else kwargs.get('page',1)
            context['is_paginated'] = True
            context['paginator'] = Paginator(self.queryset, self._paginate_by)
            context['page_obj'] = context['paginator'].get_page(page)
            context['events'] = context['page_obj']
            print(context)
        return context

    # def get_build_path(self):
    #     context = self.get_context_data()
    #     path = super().get_build_path()
    #     if context['page_obj'].number == 2:
    #         return path
    #     else:
    #         return path+'events/{}'.format(context['page_obj'].number)

    def build_queryset(self):
        print("Building %s" % self.build_path)
        super().build_queryset()
        p = Paginator(self.queryset, self._paginate_by)
        for page in range(2, p.num_pages+1):
            self.page = page
            self.build_path = 'events/%d/index.html' % page
            super().build_queryset()


class BioView(MetadataMixin, BuildableTemplateView):
    title = 'Lydia Venieri\'s Bio'
    description = 'Lydia Venieri Bio page'
    image = 'http://venieri.com/venieri/Bio_files/droppedImage_5.jpg'
    url = '/bio'
    template_name = 'bio.html'
    build_path='bio/index.html'

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['solo_shows'] = models.Event.objects.filter(tags__name='show/solo')
        context['group_shows'] = models.Event.objects.filter(tags__name='show/group')
        context['iphone_art'] = models.Art.objects.filter(tags__name='art/iphone')
        context['internet_art'] = models.Art.objects.filter(tags__name='internet')
        context['theatres'] = models.Art.objects.filter(tags__name='theatre')
        return context

class VirtualWorldView(MetadataMixin, BuildableTemplateView):
    title = 'Lydia Venieri\'s Virtual World'
    description = 'The virtual world of Lydia Venieri'
    image = 'http://venieri.com/Virtual_World/images/ilydia.gif'
    url = '/virtual-world'
    template_name = 'virtual_world.html'
    build_path = 'virtual-world/index.html'


class ProjectListView(MetadataMixin, BuildableListView):
    title = 'Lydia Venieri\'s Projects'
    description = 'Lydia Venieri Project page'
    image = 'http://venieri.com/venieri/Bio_files/droppedImage_5.jpg'
    url = '/projects'
    build_path = 'projects/index.html'
    context_object_name = 'project'
    template_name = 'project_list.html'  # Default: <app_label>/<model_name>_list.html
    context_object_name = 'projects'  # Default: object_list
    # paginate_by = 6
    queryset = models.Project.objects.filter(is_visible=True)  # De


class ProjectDetailView(MetadataMixin, BuildableDetailView):
    template_name = 'project_detail.html'
    model = models.Project

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['meta'] = self.get_object().as_meta(self.request)
        return context


class ArtListView(MetadataMixin, BuildableListView):
    title = 'Lydia Venieri\'s work'
    description = 'Lydia Venieri art'
    image = 'http://venieri.com/venieri/Bio_files/droppedImage_5.jpg'
    url = '/work'
    context_object_name = 'art'
    template_name = 'art_list.html'
    build_path = 'work/index.html'
    queryset = models.Art.objects.filter(is_visible=True)  # De

    def get_context_data(self, **kwargs):
            context = super(ArtListView, self).get_context_data(**kwargs)
            tags = set()
            for art in self.queryset:
                for tag in art.tags.all():
                    tags.add(tag)
            context['tags'] = tags
            return context


class ArtDetailView(MetadataMixin, BuildableDetailView):
    template_name = 'art_detail.html'
    model = models.Art

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['meta'] = self.get_object().as_meta(self.request)
        return context