import os
import datetime
from pyquery import PyQuery as pq
import tagulous.models
from django.contrib.sites.models import Site
from autoslug import AutoSlugField
from django.urls import reverse
from django.conf import settings
from django.contrib.contenttypes.fields import GenericForeignKey, GenericRelation
from django.contrib.contenttypes.models import ContentType
from django.db import models
from django.utils.html import format_html
from embed_video.backends import detect_backend
from embed_video.fields import EmbedVideoField
from meta.models import ModelMeta
# from textblob import TextBlob
from sortedm2m.fields import SortedManyToManyField
from versatileimagefield.fields import VersatileImageField


def get_full_path(absolute_url):
   domain = Site.objects.get_current().domain
   return 'http://{domain}{path}'.format(domain=domain, path=absolute_url)


# class Tags(tagulous.models.TagTreeModel):
#     class TagMeta:
#         initial = "show/solo, show/group, photo"
#         force_lowercase = True
#         autocomplete_view = 'archive.views.tags_autocomplete'

class Category(models.Model):
    content_type = models.ForeignKey(ContentType, on_delete=models.CASCADE)
    object_id = models.PositiveIntegerField()
    content_object = GenericForeignKey('content_type', 'object_id')
    name = models.CharField(max_length=200)


def media_path(instance, filename):
    filename = 'lydia-venieri-{}.{}'.format(instance.slug, filename.split('.')[-1])
    return os.path.join('art', filename)


class Media(models.Model):
    class Meta:
        verbose_name_plural = "media"

    caption = models.CharField(max_length=200)
    slug = AutoSlugField(populate_from='caption')
    image = VersatileImageField(upload_to=media_path, blank=True, null=True)
    video_url = EmbedVideoField(blank=True, null=True)

    def __str__(self):
        return self.caption


    def is_horizontal(self):
        if self.image:
            return self.image.width > self.image.height
        return True

    def image_tag(self):
        if self.image:
            return format_html(
                '<img src="{}" />'.format(self.image.thumbnail['{}x{}'.format(*settings.ARCHIVE_IMAGE_THUMBNAIL)].url))
        elif self.video_url:
            return format_html(self.video.get_embed_code(*settings.ARCHIVE_VIDEO_THUMBNAIL))
        return

    def url(self):
        if self.image:
            return self.image.url
        elif self.video_url:
            return detect_backend(self.video_url).url

    @property
    def video(self):
        return detect_backend(self.video_url) if self.video_url else None

    @property
    def sd(self):
        return {
            "@type": 'ImageObject',
            "description": self.caption,
            "name": self.caption,
            "caption": self.caption,
            "image": self.url()
        }


class Entity(ModelMeta, models.Model):
    class Meta:
        verbose_name_plural = "entities"
        # abstract = True

    category = GenericRelation(Category)
    is_visible = models.BooleanField(default=True)
    title = models.CharField(max_length=200)
    description = models.TextField(blank=True, default='')
    slug = AutoSlugField(populate_from='get_slug')
    media = SortedManyToManyField(Media, related_name='entities', blank=True)


    tags = tagulous.models.TagField(
        force_lowercase=True,
        tree=True,
        blank=True,
    )

    def tags_list(self):
        return ''

    def __str__(self):
        return self.title


    def get_slug(self):
        return self.title

    def get_absolute_url(self):
        return reverse('{}'.format(self.__class__.__name__.lower()), kwargs={'slug': self.slug})

    @property
    def leader(self):
        if self.description:
            dom = pq(self.description)
            leader_text = dom(".leader").html()
            if leader_text:
                return leader_text
            return self.description[:200]
        return ''

    def image_tag(self):
        first = self.media.first()
        if first:
            return first.image_tag()

    def media_url(self):
        first = self.media.first()
        if first:
            return first.url()

    def media_sample(self):
        return self.media.first()


    @classmethod
    def get_visible(cls):
        return cls.objects.filter(is_visible=True)

    _metadata = {
        'title': 'title',
        'description': 'description',
        'image': 'media_url',
    }

    def sd_type(self):
        raise NotImplemented()

    @property
    def sd(self):
        return {
            "@type": self.sd_type(),
            "description": self.description,
            "name": self.title,
        }

class Project(ModelMeta, models.Model):
    is_visible = models.BooleanField(default=True)
    title = models.CharField(max_length=200)
    statement = models.TextField(blank=True, default='')
    slug = AutoSlugField(populate_from='get_slug')

    def get_slug(self):
        return self.title

    tags = tagulous.models.TagField(
        force_lowercase=True,
        tree=True,
        blank=True,
    )

    def __str__(self):
        return self.title

    def get_absolute_url(self):
        return reverse('{}'.format(self.__class__.__name__.lower()), kwargs={'slug': self.slug})

    def visible_art(self):
        return self.art_set.filter(is_visible=True)

    def media_sample(self):
        art = self.art_set.first()
        if art:
            return art.media.first()

    @classmethod
    def get_visible(cls):
        return cls.objects.filter(is_visible=True)

    _metadata = {
        'title': 'title',
        'description': 'statement',
        'image': 'media_url',
    }

    def sd_type(self):
        pass


class Art(Entity):
    class Meta:
        verbose_name_plural = "art"
        ordering = ['-year']
    SD_CreativeWork = 'CreativeWork'
    SD_Book = 'Book'
    SD_ComicStory = 'ComicStory'
    SD_DigitalDocument = 'DigitalDocument'
    SD_Drawing = 'Drawing'
    SD_Game = 'Game'
    SD_Manuscript = 'Manuscript'
    SD_Map = 'Map'
    SD_MediaObject = 'MediaObject'
    SD_Movie = 'Movie'
    SD_MusicComposition = 'MusicComposition'
    SD_MusicRecording = 'MusicRecording'
    SD_Painting = 'Painting'
    SD_Photograph = 'Photograph'
    SD_Play = 'Play'
    SD_Poster = 'Poster'
    SD_Sculpture = 'Sculpture'
    SD_ShortStory = 'ShortStory'
    SD_SoftwareApplication = 'SoftwareApplication'
    SD_Thesis = 'Thesis'
    SD_VisualArtwork = 'VisualArtwork'
    SD_WebPage = 'WebPage'
    SD_CHOICES = (
        (SD_CreativeWork,SD_CreativeWork),
        (SD_Book, SD_Book),
        (SD_ComicStory, SD_ComicStory),
        (SD_DigitalDocument, SD_DigitalDocument),
        (SD_Drawing, SD_Drawing),
        (SD_Game, SD_Game),
        (SD_Manuscript, SD_Manuscript),
        (SD_Map, SD_Map),
        (SD_MediaObject, SD_MediaObject),
        (SD_Movie, SD_Movie),
        (SD_MusicComposition, SD_MusicComposition),
        (SD_MusicRecording, SD_MusicRecording),
        (SD_Painting, SD_Painting),
        (SD_Photograph, SD_Photograph),
        (SD_Play, SD_Play),
        (SD_Poster, SD_Poster),
        (SD_Sculpture, SD_Sculpture),
        (SD_ShortStory, SD_ShortStory),
        (SD_SoftwareApplication, SD_SoftwareApplication),
        (SD_Thesis, SD_Thesis),
        (SD_VisualArtwork, SD_VisualArtwork),
        (SD_WebPage, SD_WebPage),
    )
    sd_type = models.CharField(
        max_length= (max([len(x[0]) for x in  SD_CHOICES])),
        choices=SD_CHOICES,
        default=SD_VisualArtwork,
    )
    project = models.ForeignKey('Project', null=True, blank=True, on_delete=models.DO_NOTHING)
    year = models.PositiveSmallIntegerField(default=2018)
    def get_absolute_url(self):
        return reverse('art-work', kwargs={'slug': self.slug})

    @property
    def date(self):
        return datetime.date(year=self.year, month=1, day=1)



    @property
    def sd(self):
        return {
            "@context": "http://schema.org/",
            "@type": self.sd_type,
            "url": self.get_absolute_url(),
            "name": self.title,
            "description": self.description,
            "dateCreated": self.date,
            "image": self.media_sample().sd if self.media_sample() else None
        }


class Event(Entity):
    class Meta:
        ordering = ['-start_date']

    start_date = models.DateTimeField(blank=True, null=True)
    end_date = models.DateTimeField(blank=True, null=True)
    venue = models.CharField(max_length=200, blank=True, default='')


    def get_absolute_url(self):
        return reverse('event', kwargs={'slug': self.slug})

    @property
    def date(self):
        return self.start_date.date


    @property
    def sd(self):
        sd_data =  {
            "@context": "http://schema.org/",
            "@type": "VisualArtsEvent",
            "url": self.get_absolute_url(),
            "name": self.title,
            "description": self.description,
            "location": self.venue,
            "eventSchedule": {
                "@type": "Schedule",
                "startDate": self.start_date.strftime("%Y-%m-%d") if self.start_date else None,
                "endDate":  self.end_date.strftime("%Y-%m-%d") if self.end_date else None,
            }
        }
        clean_sd = {}
        for k,v in sd_data.items():
            if  v:
                clean_sd[k] = v
        return clean_sd


class Reference(Entity):
    class Meta:
        ordering = ['-publication_date']

    publication_date = models.DateField(blank=True, null=True)
    publication = models.CharField(max_length=200, blank=True, default='')
    author = models.CharField(max_length=200, blank=True, default='')
    url = models.URLField(max_length=200, blank=True, default='')

    def get_absolute_url(self):
        return reverse('reference', kwargs={'slug': self.slug})




    @property
    def sd(self):
        sd_data =  {
            "@context": "http://schema.org/",
            "@type": "Article",
            "url": self.get_absolute_url(),
            "name": self.title,
            "description": self.description,
            "location": self.venue,
        }
        clean_sd = {}
        for k,v in sd_data.items():
            if  v:
                clean_sd[k] = v
        return clean_sd