from django.db import models
from modelcluster.contrib.taggit import ClusterTaggableManager
from modelcluster.fields import ParentalKey
from taggit.models import TaggedItemBase
from wagtail.admin.edit_handlers import FieldPanel, InlinePanel, MultiFieldPanel
from wagtail.core.fields import RichTextField
from wagtail.core.models import Orderable, Page
from wagtail.images.edit_handlers import ImageChooserPanel
from wagtail.search import index

class ArtPageTag(TaggedItemBase):
    content_object = ParentalKey(
        'ArtPage',
        related_name='tagged_items',
        on_delete=models.CASCADE
    )


class EventPageTag(TaggedItemBase):
    content_object = ParentalKey(
        'EventPage',
        related_name='tagged_items',
        on_delete=models.CASCADE
    )


class EventIndexPage(Page):
    intro = RichTextField(blank=True)

    content_panels = Page.content_panels + [
        FieldPanel('intro', classname="full")
    ]

    def get_context(self, request):
        # Update context to include only published posts, ordered by reverse-chron
        context = super().get_context(request)
        eventpages = self.get_children().live().order_by('-eventpage__date')
        context['eventpages'] = eventpages
        return context


class EventPage(Page):
    date = models.DateField("Post date")
    intro = models.CharField(max_length=250)
    body = RichTextField(blank=True)
    tags = ClusterTaggableManager(through=EventPageTag, blank=True)
    # categories = ParentalManyToManyField('events.EventCategory', blank=True)
    location = models.CharField(blank=True, max_length=250)
    venue = models.CharField(blank=True, max_length=250)

    search_fields = Page.search_fields + [
        index.SearchField('intro'),
        index.SearchField('body'),
    ]

    content_panels = Page.content_panels + [
        MultiFieldPanel([
            FieldPanel('date'),
            FieldPanel('tags'),
            # FieldPanel('categories', widget=forms.CheckboxSelectMultiple),
        ], heading="Event information"),
        FieldPanel('intro'),
        FieldPanel('location'),
        FieldPanel('venue'),
        FieldPanel('body'),
        InlinePanel('gallery_images', label="Gallery images"),
    ]

    def main_image(self):
        gallery_item = self.gallery_images.first()
        if gallery_item:
            return gallery_item.image
        else:
            return None


class EventPageGalleryImage(Orderable):
    page = ParentalKey(EventPage, on_delete=models.CASCADE, related_name='gallery_images')
    image = models.ForeignKey(
         'images.CustomImage', on_delete=models.CASCADE, related_name='+'
     )
    caption = models.CharField(blank=True, max_length=250)

    panels = [
        ImageChooserPanel('image'),
        FieldPanel('caption'),
    ]


class EventTagIndexPage(Page):

    def get_context(self, request):

        # Filter by tag
        tag = request.GET.get('tag')
        blogpages = EventPage.objects.filter(tags__name=tag)

        # Update template context
        context = super().get_context(request)
        context['eventpages'] = blogpages
        return context


class BioPage(Page):
    content_panels = Page.content_panels + [
        InlinePanel('gallery_images', label="Gallery images"),
    ]

    def get_context(self, request):
        # Update template context
        context = super().get_context(request)
        context['solo_shows'] =  EventPage.objects.filter(tags__name='solo show').order_by('-date')
        context['group_shows'] = EventPage.objects.filter(tags__name='group show').order_by('-date')
        return context

    def __getattr__(self, name):
        if name.startswith('get_image_'):
            indx = int(name[len('get_image_'):])
            return self.get_image(indx)
        raise AttributeError('Unkown attribute %s' % name)

    def get_image(self, indx=0):
        gallery_item = self.gallery_images.all()[indx]
        return gallery_item.image

class BioPageGalleryImage(Orderable):
    page = ParentalKey(BioPage, on_delete=models.CASCADE, related_name='gallery_images')
    image = models.ForeignKey(
         'images.CustomImage', on_delete=models.CASCADE, related_name='+'
     )
    caption = models.CharField(blank=True, max_length=250)

    panels = [
        ImageChooserPanel('image'),
        FieldPanel('caption'),
    ]


class ProjectIndexPage(Page):
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


class ProjectPage(Page):
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
    ]

    def main_image(self):
        gallery_item = self.gallery_images.first()
        if gallery_item:
            return gallery_item.image
        else:
            return None


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


class ArtIndexPage(Page):
    intro = RichTextField(blank=True)

    content_panels = Page.content_panels + [
        FieldPanel('intro', classname="full")
    ]

    def get_context(self, request):
        # Update context to include only published posts, ordered by reverse-chron
        context = super().get_context(request)
        art_pages = self.get_children().live().order_by('-artpage__date')
        context['art_pages'] = art_pages
        return context

class ArtPage(Page):
    date = models.PositiveIntegerField("Date")
    tags = ClusterTaggableManager(through='ArtPageTag', blank=True)
    material = models.CharField(max_length=250)
    size = models.CharField(max_length=250)
    body = RichTextField(blank=True)

    # categories = ParentalManyToManyField('events.EventCategory', blank=True)
    edition = models.BooleanField(default=False)
    edition_size = models.PositiveIntegerField(default=1)
    location = models.CharField(blank=True, max_length=250)


    search_fields = Page.search_fields + [
        index.SearchField('material'),
        index.SearchField('size'),
        index.SearchField('location'),
        index.SearchField('body'),
        index.SearchField('date'),
    ]

    content_panels = Page.content_panels + [
        FieldPanel('date'),
        FieldPanel('tags'),
        FieldPanel('material'),
        FieldPanel('size'),
        FieldPanel('body'),
        MultiFieldPanel([
            FieldPanel('edition'),
            FieldPanel('edition_size'),

            # FieldPanel('categories', widget=forms.CheckboxSelectMultiple),
        ], heading="Edition information"),
        FieldPanel('location'),
        InlinePanel('gallery_images', label="Gallery images"),
    ]

    def __getattr__(self, name):
        if name.startswith('get_image_'):
            indx = int(name[len('get_image_'):])
            return self.get_image(indx)
        raise AttributeError('Unkown attribute %s' % name)

    def get_image(self, indx=0):
        gallery_item = self.gallery_images.all()[indx]
        return gallery_item.image

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


#
# @register_snippet
# class EventCategory(models.Model):
#     name = models.CharField(max_length=255)
#     icon = models.ForeignKey(
#         'home.CustomImage', null=True, blank=True,
#         on_delete=models.SET_NULL, related_name='+'
#     )
#
#     panels = [
#         FieldPanel('name'),
#         ImageChooserPanel('icon'),
#     ]
#
#     def __str__(self):
#         return self.name
#
#     class Meta:
#         verbose_name_plural = 'event categories'