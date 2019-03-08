from django.db import models

from django import forms
from django.db import models
from modelcluster.contrib.taggit import ClusterTaggableManager
from modelcluster.fields import ParentalKey, ParentalManyToManyField
from taggit.models import TaggedItemBase
from wagtail.admin.edit_handlers import FieldPanel, InlinePanel, MultiFieldPanel
from wagtail.core.fields import RichTextField
from wagtail.core.models import Orderable, Page
from wagtail.images.edit_handlers import ImageChooserPanel
from wagtail.search import index
from wagtail.snippets.models import register_snippet
from wagtailmetadata.models import MetadataPageMixin


class ArtPageTag(TaggedItemBase):
    content_object = ParentalKey(
        'ArtPage',
        related_name='tagged_items',
        on_delete=models.CASCADE
    )



class ProjectIndexPage(MetadataPageMixin, Page):
    intro = RichTextField(blank=True)

    content_panels = Page.content_panels + [
        FieldPanel('intro', classname="full")
    ]

    def get_context(self, request):
        # Update context to include only published posts, ordered by reverse-chron
        context = super().get_context(request)
        project_pages = self.get_children().live().order_by('-projectpage__date')
        context['project_pages'] = project_pages
        return context


class ProjectPage(MetadataPageMixin, Page):
    date = models.DateField("Post date")
    body = RichTextField(blank=True)
    # tags = ClusterTaggableManager(through=EventPageTag, blank=True)
    # categories = ParentalManyToManyField('events.EventCategory', blank=True)

    search_fields = Page.search_fields + [
        index.SearchField('body'),
    ]

    content_panels = Page.content_panels + [
        MultiFieldPanel([
            FieldPanel('date'),
            # FieldPanel('tags'),
            # FieldPanel('categories', widget=forms.CheckboxSelectMultiple),
        ], heading="Event information"),
        FieldPanel('body'),
        InlinePanel('gallery_images', label="Gallery images"),
        InlinePanel('art', label="art"),
    ]

    def main_image(self):
        gallery_item = self.gallery_images.first()
        if gallery_item:
            return gallery_item.image
        else:
            return None

    def get_meta_image(self):
        return self.main_image()


class ProjectPageGalleryImage(Orderable):
    page = ParentalKey(ProjectPage, on_delete=models.CASCADE, related_name='gallery_images')
    image = models.ForeignKey(
        'images.CustomImage', on_delete=models.CASCADE, related_name='+'
    )
    caption = models.CharField(blank=True, max_length=250)

    panels = [
        ImageChooserPanel('image'),
        FieldPanel('caption'),
    ]


class ArtIndexPage(MetadataPageMixin, Page):
    intro = RichTextField(blank=True)

    content_panels = Page.content_panels + [
        FieldPanel('intro', classname="full")
    ]

    def get_context(self, request):
        # Update context to include only published posts, ordered by reverse-chron
        context = super().get_context(request)
        art_pages = self.get_children().live().order_by('-artpage__date')
        context['art_pages'] = art_pages
        tags = set()
        years = set()
        for a in ArtPage.objects.all():
            for t in a.tags.all():
                tags.add(t)
            years.add(a.date)
        context['tag_list'] = tags
        context['year_list'] = years
        return context


class ArtPage(MetadataPageMixin, Page):
    project = ParentalKey(ProjectPage, blank=True, null=True, on_delete=None, related_name='art')
    date = models.PositiveIntegerField("Date")
    tags = ClusterTaggableManager(through='ArtPageTag', blank=True)
    material = models.CharField(max_length=250)
    size = models.CharField(max_length=250)
    body = RichTextField(blank=True)

    categories = ParentalManyToManyField('work.ArtCategory', blank=True)
    edition = models.BooleanField(default=False)
    edition_size = models.PositiveIntegerField(default=1)
    location = models.CharField(blank=True, max_length=250)
    events = ParentalManyToManyField('events.EventPage', blank=True, null=True)

    search_fields = Page.search_fields + [
        index.SearchField('material'),
        index.SearchField('size'),
        index.SearchField('location'),
        index.SearchField('body'),
        index.SearchField('date'),
    ]

    content_panels = Page.content_panels + [
        FieldPanel('project'),
        FieldPanel('categories', widget=forms.CheckboxSelectMultiple),
        FieldPanel('date'),
        FieldPanel('tags'),
        FieldPanel('material'),
        FieldPanel('size'),
        FieldPanel('body'),

        MultiFieldPanel([
            FieldPanel('edition'),
            FieldPanel('edition_size'),

        ], heading="Edition information"),
        MultiFieldPanel([
            FieldPanel('events', widget=forms.CheckboxSelectMultiple),

        ], heading="Events"),
        FieldPanel('location'),
        InlinePanel('gallery_images', label="Gallery images"),
    ]

    def __getattr__(self, name):
        if name.startswith('get_image_'):
            indx = int(name[len('get_image_'):])
            return self.get_image(indx)
        raise AttributeError('Unkown attribute %s' % name)

    def get_message(self):
        if self.title:
            return self.title
        else:
            return self.self.gallery_images.first().caption

    def get_image(self, indx=0):
        gallery_item = self.gallery_images.all()[indx]
        return gallery_item.image

    def image(self):
        return format_html('<img src="{}" />'.format(self.get_image().get_rendition('fill-75x75-c100').url))

    def get_meta_image(self):
        return self.get_image()


class ArtPageGalleryImage(Orderable):
    page = ParentalKey(ArtPage, on_delete=models.CASCADE, related_name='gallery_images')
    image = models.ForeignKey(
        'images.CustomImage', on_delete=models.CASCADE, related_name='+'
    )
    caption = models.CharField(blank=True, max_length=250)

    panels = [
        ImageChooserPanel('image'),
        FieldPanel('caption'),
    ]



@register_snippet
class ArtCategory(models.Model):
    name = models.CharField(max_length=255)
    icon = models.ForeignKey(
        'images.CustomImage', null=True, blank=True,
        on_delete=models.SET_NULL, related_name='+'
    )

    panels = [
        FieldPanel('name'),
        ImageChooserPanel('icon'),
    ]

    search_fields = [
        index.SearchField('name', partial_match=True),
    ]

    def __str__(self):
        return self.name

    class Meta:
        verbose_name_plural = 'art categories'


