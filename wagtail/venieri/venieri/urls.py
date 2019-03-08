from django.conf import settings
from django.conf.urls import include, url
from django.contrib import admin

from wagtail.admin import urls as wagtailadmin_urls
from wagtail.core import urls as wagtail_urls
from wagtail.documents import urls as wagtaildocs_urls
from wagtail.contrib.sitemaps.views import sitemap
from django.views.generic.base import RedirectView

from search import views as search_views

urlpatterns = [
    url(r'^django-admin/', admin.site.urls),

    url(r'^admin/', include(wagtailadmin_urls)),
    url(r'^documents/', include(wagtaildocs_urls)),
    url('^sitemap\.xml$', sitemap),
    url(r'^search/$', search_views.search, name='search'),
    # url(r'^/', RedirectView.as_view(url='pages/events/')),
    # For anything not caught by a more specific rule above, hand over to
    # Wagtail's page serving mechanism. This should be the last pattern in
    # the list:
    url(r'^pages/', include(wagtail_urls)),

    # Alternatively, if you want Wagtail pages to be served from a subpath
    # of your site, rather than the site root:
    #    url(r'^pages/', include(wagtail_urls)),
]

# from wagtail_feeds.feeds import BasicFeed, BasicJsonFeed, ExtendedFeed, ExtendedJsonFeed
# urlpatterns += [
# url(r'^blog/feed/basic$', BasicFeed(), name='basic_feed'),
# url(r'^blog/feed/extended$', ExtendedFeed(), name='extended_feed'),
#
# # JSON feed
# url(r'^blog/feed/basic.json$', BasicJsonFeed(), name='basic_json_feed'),
# url(r'^blog/feed/extended.json$', ExtendedJsonFeed(), name='extended_json_feed'),
# ]

if settings.DEBUG:
    from django.conf.urls.static import static
    from django.contrib.staticfiles.urls import staticfiles_urlpatterns

    # Serve static and media files from development server
    urlpatterns += staticfiles_urlpatterns()
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
