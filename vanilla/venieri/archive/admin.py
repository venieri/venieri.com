from codemirror2.widgets import CodeMirrorEditor
from django.contrib import admin
from embed_video.admin import AdminVideoMixin
from simple_history.admin import SimpleHistoryAdmin
from . import models

from  tagulous import admin as tagulous_admin


@admin.register(models.Media)
class MediaAdmin(AdminVideoMixin, admin.ModelAdmin):
    list_display = ['caption', 'image_tag']
    # inlines = [
    #     ProtfolioInline,
    # ]


    fields = ['caption','image',  'video_url', 'image_tag',]
    readonly_fields = ['image_tag']


class ArtAdmin(admin.ModelAdmin):
    list_display = ['id', 'title', 'year', 'tags', 'sd_type', 'is_visible', 'image_tag']
    # inlines = [
    #     ProtfolioInline,
    # ]
    #exclude = ('media',)
    list_filter = ('project', 'is_visible', 'tags')

    list_editable = ['title', 'sd_type','year',  'is_visible',]
    fields = ['sd_type', 'title', 'project', 'year', 'tags', 'description',  'media', 'image_tag']
    readonly_fields = ['image_tag']
    save_as = True
tagulous_admin.register(models.Art, ArtAdmin)


class EventAdmin(SimpleHistoryAdmin):
    def formfield_for_dbfield(self, db_field, **kwargs):
        if db_field.attname == "description":
            kwargs['widget'] = CodeMirrorEditor(options={'mode': 'htmlmixed', 'lineNumbers': True},
                                                modes=['css', 'xml', 'javascript', 'htmlmixed'])
        return super(EventAdmin, self).formfield_for_dbfield(db_field, **kwargs)

    list_display = ['start_date', 'slug', 'title', 'tags', 'is_visible','image_tag']
    # inlines = [
    #     ProtfolioInline,
    # ]
    #exclude = ('media',]
    list_editable = ['is_visible',]
    list_filter = ('is_visible', 'tags')
    fields = [ 'title', 'venue',  'start_date','end_date', 'is_visible', 'media', 'tags', 'description',  'image_tag']
    readonly_fields = ['image_tag']
tagulous_admin.register(models.Event, EventAdmin)



@admin.register(models.Category)
class CategoryAdmin(admin.ModelAdmin):
    pass

class ArtInline(admin.TabularInline):
    model = models.Art


@admin.register(models.Project)
class ProjectAdmin(SimpleHistoryAdmin):
    inlines = [
        ArtInline
    ]
    list_display = ['title', 'slug', 'is_visible' ]
    list_editable = ['is_visible', ]

admin.register(models.Event.tags.tag_model)

@admin.register(models.Reference)
class ReferenceAdmin(admin.ModelAdmin):
    list_display = ['publication_date','title', 'publication', 'authors', 'is_visible', 'url',]
    list_editable = ['is_visible', ]


