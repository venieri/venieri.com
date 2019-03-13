from django.utils.html import format_html
from wagtail.contrib.modeladmin.options import (
    ModelAdmin, modeladmin_register)
from wagtail.core import hooks
from wagtail.core.models import Orderable, Page
from .models import EventPage


class EventAdmin(ModelAdmin):
    model = EventPage
    menu_label = 'Event'  # ditch this to use verbose_name_plural from model
    menu_icon = 'pilcrow'  # change as required
    menu_order = 400  # will put in 3rd place (000 being 1st, 100 2nd)
    add_to_settings_menu = False  # or True to add your model to the Settings sub-menu
    exclude_from_explorer = False  # or True to exclude pages of this type from Wagtail's explorer view
    list_display = ('start_date', 'title', 'venue', 'categories', 'get_image')
    list_filter = ('start_date', 'categories', 'tags',)
    search_fields = ('title', 'venue', 'body')
    ordering = ['-start_date']

    def get_image(self, obj):
        _image = obj.main_image()
        if _image:
            return format_html('<img src="{}" />'.format(_image.get_rendition('fill-75x75-c100').url))

    get_image.short_description = 'image'


# Now you just need to register your customised ModelAdmin class with Wagtail
modeladmin_register(EventAdmin)




@hooks.register('before_serve_page')
def before_serve_page_function(page, request, args, kwargs):
    if page.slug =='home':
        page = Page.objects.get(slug='lydia-venieri')
        return page.specific.serve(request, *args, **kwargs)
