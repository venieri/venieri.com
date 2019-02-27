import os


from django.http import HttpResponseRedirect, HttpResponse
from django.shortcuts import render_to_response, render
from django.views.generic import View, ListView, DetailView

from . import models





class PageView(View):
    def seo(self, context):
        current_page = context['current_page']
        return {
            'title': current_page.title,
            'description': current_page.description_155,
            'image': 'http://mykonosbiennale.org/static/images/mykonos-biennale-logo.png',
            'url': current_page.get_absolute_url(),
            'description_155': current_page.description_155,
            'description_200': current_page.description_200,
            'description_300': current_page.description_300,
        }
    def get(self, request, slug):
        page = models.Page.objects.get(slug=slug)
        self.build_path = os.path.join(slug,'index.html')
        context = {'current_page':page, 'pages': models.Page.menubar()}
        context['seo'] = self.seo(context)
        return render_to_response(page.template, context)


class ArtView(DetailView):
    pass

class EventView(DetailView):
    model = models.Event
    context_object_name = 'event'
    template_name = 'event_detail.html'

    def get_context_data(self, **kwargs):
        context = super(EventView, self).get_context_data(**kwargs)
        context['meta'] = self.get_object().as_meta(self.request)
        return context



class EventListView(ListView):
    model = models.Event
    template_name = 'event_list.html'  # Default: <app_label>/<model_name>_list.html
    context_object_name = 'events'  # Default: object_list
    paginate_by = 6
    queryset = models.Event.objects.all()  # De

class ProjectListView(ListView):
    model = models.Project
    template_name = 'project_list.html'  # Default: <app_label>/<model_name>_list.html
    context_object_name = 'projects'  # Default: object_list
    # paginate_by = 6
    queryset = models.Project.objects.all()  # De


class ProjectView(DetailView):
    model = models.Project
    context_object_name = 'project'
    template_name = 'project_detail2.html'

    def get_context_data(self, **kwargs):
        context = super(ProjectView, self).get_context_data(**kwargs)
        # context['meta'] = self.get_object().as_meta(self.request)
        return context