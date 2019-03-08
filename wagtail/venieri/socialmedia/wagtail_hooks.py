from wagtail.contrib.modeladmin.options import (
    ModelAdmin, modeladmin_register)

from .models import Job


class JobAdmin(ModelAdmin):
    model = Job
    menu_label = 'Jobs'  # ditch this to use verbose_name_plural from model
    menu_icon = 'mail'  # change as required
    menu_order = 600  # will put in 3rd place (000 being 1st, 100 2nd)
    add_to_settings_menu = False  # or True to add your model to the Settings sub-menu
    exclude_from_explorer = False  # or True to exclude pages of this type from Wagtail's explorer view
    list_display = ('scheduled_for', 'block', 'status', 'target', 'caption')
    list_filter = ('scheduled_for', 'block', 'target',)
    search_fields = ('caption',)


# Now you just need to register your customised ModelAdmin class with Wagtail
modeladmin_register(JobAdmin)

from wagtail.admin import widgets as wagtailadmin_widgets
from wagtail.core import hooks


@hooks.register('register_page_listing_buttons')
def page_listing_buttons(page, page_perms, is_parent=False):
    yield wagtailadmin_widgets.PageListingButton(
        'A page listing button',
        '/goes/to/a/url/',
        priority=10
    )


from wagtail.core import hooks
from wagtail.admin.menu import MenuItem


@hooks.register('register_admin_menu_item')
def register_frank_menu_item():
    return MenuItem('Frank', '/pages/events', classnames='icon icon-folder-inverse', order=10000)


@hooks.register('register_page_listing_buttons')
def page_custom_listing_buttons(page, page_perms, is_parent=False):
    yield wagtailadmin_widgets.ButtonWithDropdownFromHook(
        'More actions',
        hook_name='my_button_dropdown_hook',
        page=page,
        page_perms=page_perms,
        is_parent=is_parent,
        priority=50
    )


from wagtail.admin.search import SearchArea


@hooks.register('register_admin_search_area')
def register_frank_search_area():
    return SearchArea('Frank', '/pages/events', classnames='icon icon-folder-inverse', order=10000)
