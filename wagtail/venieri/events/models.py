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

from wagtailschemaorg.models import PageLDMixin
from wagtailschemaorg.utils import extend, image_ld


class EventPageTag(TaggedItemBase):
    content_object = ParentalKey(
        'EventPage',
        related_name='tagged_items',
        on_delete=models.CASCADE
    )


class EventIndexPage(MetadataPageMixin, Page):
    intro = RichTextField(blank=True)

    content_panels = Page.content_panels + [
        FieldPanel('intro', classname="full")
    ]

    def get_context(self, request):
        # Update context to include only published posts, ordered by reverse-chron
        context = super().get_context(request)
        eventpages = self.get_children().live().order_by('-eventpage__start_date')
        context['eventpages'] = eventpages
        return context

    def get_meta_image(self):
        return None


class EventPage(PageLDMixin, MetadataPageMixin, Page):
    date = models.DateField("Post date")
    intro = models.CharField(max_length=250)
    body = RichTextField(blank=True)
    tags = ClusterTaggableManager(through=EventPageTag, blank=True)
    categories = ParentalManyToManyField('events.EventCategory', blank=True)
    location = models.CharField(blank=True, max_length=250)
    venue = models.CharField(blank=True, max_length=250)

    search_fields = Page.search_fields + [
        index.SearchField('intro'),
        index.SearchField('body'),
        index.SearchField('location'),
        index.SearchField('venue'),
        index.SearchField('categories'),
    ]

    content_panels = Page.content_panels + [
        MultiFieldPanel([
            FieldPanel('date'),
            FieldPanel('tags'),
            FieldPanel('categories', widget=forms.CheckboxSelectMultiple),
        ], heading="Event information"),
        FieldPanel('intro'),
        FieldPanel('location'),
        FieldPanel('venue'),
        FieldPanel('body'),
        InlinePanel('gallery_images', label="Gallery images"),
    ]

    def get_meta_image(self):
        return self.main_image()

    def main_image(self):
        gallery_item = self.gallery_images.first()
        if gallery_item:
            return gallery_item.image
        else:
            return None

    def get_absolute_url(self):
        return self.url

    def get_message(self):
        return "{}\n{}".format(self.title, self.intro)

    def __str__(self):
        return "{}, {}".format(self.date.year, self.title)

    def ld_entity(self):
        site = self.get_site()
        image = self.gallery_images.first()
        return extend(super().ld_entity(), {

            "@context": {
                "ical": "http://www.w3.org/2002/12/cal/ical#",
                "xsd": "http://www.w3.org/2001/XMLSchema#",
                "ical:dtstart": {
                    "@type": "xsd:dateTime"
                }
            },
            "ical:summary": self.title,
            "ical:location": "{}, {}".format(self.venue, self.location),
            "ical:dtstart": "2011-04-09T20:00:00Z",
            '@type': 'Event',
            'image': image_ld(image.image, base_url=site.root_url) if image else '',
            'organisation': 'lydia venieri',
        })


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


class BioPage(MetadataPageMixin, Page):
    content_panels = Page.content_panels + [
        InlinePanel('gallery_images', label="Gallery images"),
    ]

    def get_context(self, request):
        # Update template context
        context = super().get_context(request)
        context['solo_shows'] = EventPage.objects.filter(tags__name='solo show').order_by('-date')
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

    def get_meta_image(self):
        return self.get_image()


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


@register_snippet
class EventCategory(models.Model):
    name = models.CharField(max_length=255)
    icon = models.ForeignKey(
        'images.CustomImage', null=True, blank=True,
        on_delete=models.SET_NULL, related_name='+'
    )

    search_fields = [
        index.SearchField('name', partial_match=True),
    ]

    panels = [
        FieldPanel('name'),
        ImageChooserPanel('icon'),
    ]

    def __str__(self):
        return self.name

    class Meta:
        verbose_name_plural = 'event categories'
