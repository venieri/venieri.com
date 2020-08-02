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


from django.forms.utils import flatatt
from django.shortcuts import render
from django.utils.html import format_html
from wagtail.admin import widgets


class SelectablePageButton(widgets.PageListingButton):
    def __init__(self, label, url, classes=set(), **kwargs):
        super().__init__('[]', url, classes=classes, **kwargs)

    def render(self):
        attrs = {'href': self.url, 'class': ' '.join(sorted(self.classes))}
        attrs.update(self.attrs)
        return format_html('<input type="checkbox" >') #, flatatt(attrs), self.label)

    def __str__(self):
        return self.render()

    def __repr__(self):
        return '<Button: {}>'.format(self.label)



@hooks.register('register_page_listing_buttons')
def page_listing_buttons(page, page_perms, is_parent=False):
    if  is_parent:
        yield wagtailadmin_widgets.ButtonWithDropdownFromHook(
            'Actions',
            hook_name='my_button_dropdown_hook',
            page=page,
            page_perms=page_perms,
            is_parent=is_parent,
            priority=1
        )
    else:
        yield SelectablePageButton(
        'Select',
        '/goes/to/a/url/',
            classes=set('selectable'),
        priority=1
    )


@hooks.register('my_button_dropdown_hook')
def page_custom_listing_more_buttons(page, page_perms, is_parent=False):
    if page_perms.can_move():
        yield wagtailadmin_widgets.Button('Move', '', priority=10)
    if page_perms.can_delete():
        yield wagtailadmin_widgets.Button('Delete', '', priority=30)
    if page_perms.can_unpublish():
        yield wagtailadmin_widgets.Button('Unpublish', '', priority=40)

from wagtail.core import hooks
from wagtail.admin.menu import MenuItem


@hooks.register('register_admin_menu_item')
def register_frank_menu_item():
    return MenuItem('Frank', '/pages/events', classnames='icon icon-folder-inverse', order=10000)


# @hooks.register('register_page_listing_buttons')
# def page_custom_listing_buttons(page, page_perms, is_parent=False):
#     yield wagtailadmin_widgets.ButtonWithDropdownFromHook(
#         'More actions',
#         hook_name='my_button_dropdown_hook',
#         page=page,
#         page_perms=page_perms,
#         is_parent=is_parent,
#         priority=50
#     )


from wagtail.admin.search import SearchArea


@hooks.register('register_admin_search_area')
def register_frank_search_area():
    return SearchArea('Frank', '/pages/events', classnames='icon icon-folder-inverse', order=10000)
