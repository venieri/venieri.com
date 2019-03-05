from wagtail.contrib.modeladmin.options import (
    ModelAdmin, modeladmin_register)
from django.utils.html import format_html
from .models import Book, ArtPage, EventPage


class BookAdmin(ModelAdmin):
    model = Book
    menu_label = 'Book'  # ditch this to use verbose_name_plural from model
    menu_icon = 'pilcrow'  # change as required
    menu_order = 200  # will put in 3rd place (000 being 1st, 100 2nd)
    add_to_settings_menu = False  # or True to add your model to the Settings sub-menu
    exclude_from_explorer = False # or True to exclude pages of this type from Wagtail's explorer view
    list_display = ('title', 'author')
    list_filter = ('author',)
    search_fields = ('title', 'author')

# Now you just need to register your customised ModelAdmin class with Wagtail
modeladmin_register(BookAdmin)



class EventAdmin(ModelAdmin):
    date_hierarchy = 'date'
    model = EventPage
    menu_label = 'Event'  # ditch this to use verbose_name_plural from model
    menu_icon = 'pilcrow'  # change as required
    menu_order = 400  # will put in 3rd place (000 being 1st, 100 2nd)
    add_to_settings_menu = False  # or True to add your model to the Settings sub-menu
    exclude_from_explorer = False # or True to exclude pages of this type from Wagtail's explorer view
    list_display = ('date', 'title', 'venue', 'categories',  'get_image')
    list_filter = ( 'date', 'categories','tags','date',)
    search_fields = ( 'title',   'venue', 'body')
    ordering = ['-date']

    def get_image(self, obj):
        _image = obj.main_image()
        if _image:
            return format_html('<img src="{}" />'.format(_image.get_rendition('fill-75x75-c100').url))
    get_image.short_description = 'image'

# Now you just need to register your customised ModelAdmin class with Wagtail
modeladmin_register(EventAdmin)

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
        _image = obj.get_image()
        if _image:
            return format_html('<img src="{}" />'.format(_image.get_rendition('fill-75x75-c100').url))
    get_image.short_description = 'image'

# Now you just need to register your customised ModelAdmin class with Wagtail
modeladmin_register(ArtAdmin)

