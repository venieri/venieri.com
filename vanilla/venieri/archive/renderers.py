from django_medusa.renderers import StaticSiteRenderer


from . import models

class HomeRenderer(StaticSiteRenderer):
    def get_paths(self):
        return frozenset([
            "",
            #"bio",
            #"/work",
            #'projects',
            #'virtual-world'
            #"/sitemap.xml",
        ])

class BioRenderer(StaticSiteRenderer):
    def get_paths(self):
        return frozenset([
            "bio",
            "/work/",
            #'projects',
            #'virtual-world'
            #"/sitemap.xml",
        ])


class EventRenderer(StaticSiteRenderer):
    def get_paths(self):
        paths = ["/event/", ]
        items = models.Event.objects.filter(is_visible=True).order_by('-start_date')
        for item in items:
            paths.append(item.get_absolute_url())
        return paths

class ArtRenderer(StaticSiteRenderer):
    def get_paths(self):
        paths = ["/art/", ]
        items = models.Art.objects.filter(is_visible=True)
        for item in items:
            paths.append(item.get_absolute_url())
        return paths

class ProjectRenderer(StaticSiteRenderer):
    def get_paths(self):
        paths = ["/art/", ]
        items = models.Project.objects.filter(is_visible=True)
        for item in items:
            paths.append(item.get_absolute_url())
        return paths

renderers = [
            HomeRenderer, BioRenderer,
            # EventRenderer
            # ,ArtRenderer, ProjectRenderer
            ]