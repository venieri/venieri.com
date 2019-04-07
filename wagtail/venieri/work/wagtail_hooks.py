from wagtail.contrib.modeladmin.options import (
    ModelAdmin, modeladmin_register)
from django.utils.html import format_html
from .models import ArtPage


class ArtAdmin(ModelAdmin):
    model = ArtPage
    menu_label = 'Art'  # ditch this to use verbose_name_plural from model
    menu_icon = 'pilcrow'  # change as required
    menu_order = 410  # will put in 3rd place (000 being 1st, 100 2nd)
    add_to_settings_menu = False  # or True to add your model to the Settings sub-menu
    exclude_from_explorer = False # or True to exclude pages of this type from Wagtail's explorer view
    list_display = ('title', 'get_image')
    list_filter = ('project', 'categories', 'tags','date',)
    search_fields = ('title', 'date')
    ordering = ['-date']

    def get_image(self, obj):
        return ''
        _image = obj.get_image()
        if _image:
            return format_html('<img src="{}" />'.format(_image.get_rendition('fill-75x75-c100').url))
    get_image.short_description = 'image'

# Now you just need to register your customised ModelAdmin class with Wagtail
modeladmin_register(ArtAdmin)

