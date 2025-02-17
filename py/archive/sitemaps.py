import os
from django.conf import settings
from django.contrib.sitemaps import Sitemap
from django.contrib.sitemaps import GenericSitemap
from django.utils.timezone import now
from django.core.paginator import Paginator
from django.test.client import Client
from bakery.views import BuildableMixin

from . import models


from django.urls import reverse


class BuildableSitemapView(BuildableMixin):

    @property
    def build_method(self):
        return self.build

    def build(self):
        build_path = 'sitemap.xml'
        resp = Client().get('/'+build_path)
        path = os.path.join(settings.BUILD_DIR, build_path)
        self.prep_directory(build_path)
        self.build_file(path, resp.content)


class BaseSitemap(Sitemap):
    protocol = 'https' if settings.STATIC_SITE else 'http'



class StaticViewSitemap(BaseSitemap):
    priority = 0.5
    changefreq = 'daily'

    def items(self):
        return ['events', 'bio', 'work', 'virtual-world', 'projects']

    def location(self, item):
        return reverse(item)

class HomeViewSitemap(BaseSitemap):
    priority = 0.5
    changefreq = 'daily'

    def items(self):
        from . import views
        p = Paginator(models.Event.objects.filter(is_visible=True), views.EventPagedView._paginate_by)
        return range(2, p.num_pages+1)

    def location(self, item):
        return reverse('events', args=[item])

class EventSitemap(BaseSitemap):
    changefreq = "never"
    priority = 0.7

    def items(self):
        qs =  models.Event.objects.filter(is_visible=True)
        return qs

    def lastmod(self, obj):
        return obj.start_date


class ArtSitemap(BaseSitemap):
    changefreq = "never"
    priority = 0.5

    def items(self):
        return models.Art.objects.filter(is_visible=True)

    def lastmod(self, obj):
        return obj.year


class ProjectSitemap(BaseSitemap):
    changefreq = "never"
    priority = 0.5

    def items(self):
        return models.Project.objects.filter(is_visible=True)

    def lastmod(self, obj):
        return now()


maps = {
    'static': StaticViewSitemap,
    'art': ArtSitemap,
    'projects': ProjectSitemap,
    'event': EventSitemap,
    'events': HomeViewSitemap
}