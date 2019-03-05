from django.contrib import admin

# Register your models here.


from django.contrib import admin
from django.contrib.contenttypes.admin import GenericStackedInline
#from reversion.admin import VersionAdmin

# from photologue.admin import GalleryAdmin as GalleryAdminDefault
# from photologue.models import Gallery
from .models import ArtPage #, Image, Video, Event, Page, Media, Album



# class AlbumInline(GenericStackedInline ):
#     model = Album
#
# @admin.register(Album)
# class AlbumAdmin(VersionAdmin):
#     pass
#
#
# class ArtInline(admin.StackedInline):
#     model = Art
#
#
#
# class ImageInline(admin.StackedInline):
#     model = Image


@admin.register(ArtPage)
class ArtAdmin(admin.ModelAdmin):
    pass
    #inlines = [AlbumInline, ]

#
#
# @admin.register(Project)
# class ProjectAdmin(VersionAdmin):
#     inlines = [AlbumInline, ]
#
#
#
#
# from django.utils.html import format_html
#
# @admin.register(Image)
# class ImageAdmin(VersionAdmin):
#     def image_tag(self, obj):
#         if obj.image:
#             return format_html('<img src="{}" />'.format(obj.image.thumbnail['100x100'].url))
#         return ''
#     list_display = ['art','image_tag',]
#     fields = ['art', 'image', 'image_tag']
#     readonly_fields = ['image_tag']
#
#
#
#
#
# @admin.register(Video)
# class VideoAdmin(VersionAdmin):
#     pass
#
#
# @admin.register(Event)
# class EventAdmin(VersionAdmin):
#     inlines = [AlbumInline]
#     list_display = ['id','title','header','venue','location'] #, 'poster']
#     # list_editable = [ 'poster']
#     # fields = ['title', 'header', 'slug', 'tags', 'order', 'date', 'leader',  'content',  'venue', 'location', 'css', 'poster', 'album']
#     readonly_fields = ['slug']
#
# @admin.register(Page)
# class PageAdmin(VersionAdmin):
#
#     fields = ['order', 'template', 'title', 'slug', 'content', 'css', 'javascript']
#     readonly_fields = ['slug']
#
#
# @admin.register(Media)
# class MediaAdmin(VersionAdmin):
#     pass #readonly_fields = ['slug']