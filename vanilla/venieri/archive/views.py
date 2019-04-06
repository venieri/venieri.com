from django.views.generic import DetailView, ListView, TemplateView
from meta.views import MetadataMixin
#from bakery.views import BuildableDetailView, BuildableListView, BuildableTemplateView


from . import models


class SEO(object):
    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['meta'] = self.get_object().as_meta(self.request)
        print('context', context)
        return context


class EventDetailView(SEO, DetailView):
    model = models.Event
    context_object_name = 'event'
    template_name = 'event_detail.html'


class EventListView(MetadataMixin, ListView):
    title = 'Lydia Venieri'
    description = 'The website of the greek artist, Lydia Venieri'
    image = 'http://venieri.com/venieri/Lydia_Venieri/Lydia_Venieri_files/shapeimage_1.png'
    url = '/'
    template_name = 'event_list.html'  # Default: <app_label>/<model_name>_list.html
    context_object_name = 'events'  # Default: object_list
    paginate_by = 6
    queryset = models.Event.get_visible()  # De

    def get_context_data(self, **kwargs):
        context = super(EventListView, self).get_context_data(**kwargs)
        print('context', context)
        return context


class BioView(MetadataMixin, TemplateView):
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
        context['internet_art'] = models.Art.objects.filter(tags__name='art/internet')
        context['theatres'] = models.Art.objects.filter(tags__name='theatre')
        return context

class VirtualWorldView(MetadataMixin, TemplateView):
    title = 'Lydia Venieri\'s Virtual World'
    description = 'The virtual world of Lydia Venieri'
    image = 'http://venieri.com/Virtual_World/images/ilydia.gif'
    url = '/virtual-world'
    template_name = 'virtual_world.html'
    build_path = 'virtual-world/index.html'


class ProjectListView(MetadataMixin, ListView):
    title = 'Lydia Venieri\'s Projects'
    description = 'Lydia Venieri Project page'
    image = 'http://venieri.com/venieri/Bio_files/droppedImage_5.jpg'
    url = '/projects'

    context_object_name = 'project'
    template_name = 'project_list.html'  # Default: <app_label>/<model_name>_list.html
    context_object_name = 'projects'  # Default: object_list
    # paginate_by = 6
    queryset = models.Project.objects.filter(is_visible=True)  # De


class ProjectDetailView(DetailView):
    template_name = 'project_detail.html'
    model = models.Project

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['meta'] = self.get_object().as_meta(self.request)
        return context


class ArtListView(MetadataMixin, ListView):
    title = 'Lydia Venieri\'s work'
    description = 'Lydia Venieri art'
    image = 'http://venieri.com/venieri/Bio_files/droppedImage_5.jpg'
    url = '/work'
    context_object_name = 'art'
    template_name = 'art_list.html'
    queryset = models.Art.objects.filter(is_visible=True)  # De

    def get_context_data(self, **kwargs):
            context = super(ArtListView, self).get_context_data(**kwargs)
            tags = set()
            for art in self.queryset:
                for tag in art.tags.all():
                    tags.add(tag)
            context['tags'] = tags
            return context


class ArtDetailView(DetailView):
    template_name = 'art_detail.html'
    model = models.Art

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['meta'] = self.get_object().as_meta(self.request)
        return context