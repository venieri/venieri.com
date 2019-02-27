from django.db import models
import os
from django.urls import reverse
import tagulous.models

from embed_video.fields import EmbedVideoField
from versatileimagefield.fields import VersatileImageField
from autoslug import AutoSlugField
from meta.models import ModelMeta
from textblob import TextBlob
from django.contrib.contenttypes.fields import GenericRelation
from django.contrib.contenttypes.fields import GenericForeignKey
from django.contrib.contenttypes.models import ContentType
from sortedm2m.fields import SortedManyToManyField
from gm2m import GM2MField

def media_path(instance, filename):
    filename = 'lydia-venieri-{}.{}'.format(instance.slug,  filename.split('.')[-1])
    return os.path.join('art', filename)

class Media(models.Model):
    caption = models.CharField(max_length=200)
    slug = AutoSlugField(populate_from='caption')
    # content_type = models.ForeignKey(ContentType, on_delete=models.CASCADE)
    # object_id = models.PositiveIntegerField()
    # content_object = GenericForeignKey('content_type', 'object_id')
    image = VersatileImageField(upload_to=media_path, blank=True, null=True)

    def __str__(self):
        return self.image.url




# Create your models here.


class Tags(tagulous.models.TagTreeModel):
    class TagMeta:
        initial = "food/eating, food/cooking, gaming/football"
        force_lowercase = True
        # autocomplete_view = 'work.views.hobbies_autocomplete'



class BaseModel(models.Model):
    visible = models.BooleanField(default=True)
    title = models.CharField(max_length=200)
    slug = AutoSlugField(populate_from='get_slug')
    tags = tagulous.models.TagField(to=Tags)
    class Meta:
        abstract = True

    def __str__(self):
        return self.title

    def get_slug(self):
        return self.title

    @classmethod
    def get_visible(cls):
        return cls.objects.filter(visible=True)




#
# class Gallery(BaseModel):
#     description = models.TextField(blank=True)
#     is_public = models.BooleanField(default=True)
#     media = SortedManyToManyField('Media', related_name='albums', blank=True)


class Album(BaseModel):
    content_type = models.ForeignKey(ContentType, on_delete=models.CASCADE)
    object_id = models.PositiveIntegerField()
    content_object = GenericForeignKey('content_type', 'object_id')
    description = models.TextField(blank=True, default='')
    is_public = models.BooleanField(default=True)
    media = SortedManyToManyField(Media, related_name='album', blank=True)

class VisualEntity(BaseModel):
    class Meta:
        abstract = True
    description = models.TextField(blank=True)
    is_public = models.BooleanField(default=True)
    # album = SortedManyToManyField(Media, related_name='albums', blank=True)
    albums = GenericRelation(Album)


    def poster(self):
        album =  self.albums.first()
        if album:
            return album.media.first()


class Project(VisualEntity):
    date = models.SmallIntegerField()
    statement = models.TextField()
    # poster = models.ForeignKey('Art', related_name='poster_for', on_delete= models.SET_NULL, blank=True, null=True)

    def get_absolute_url(self):
        return reverse('project', args=[self.slug])

class Art(VisualEntity):
    project = models.ForeignKey(Project, on_delete= models.SET_NULL, blank=True, null=True)
    # gallery = models.OneToOneField(Gallery, related_name='artwork', on_delete= models.SET_NULL, blank=True, null=True)
    # gendre = tagulous.models.SingleTagField(
    #     initial="Sculpture, Painting, Video, Performance",
    # )
    gendre = tagulous.models.TagField(
        force_lowercase=True,
        max_count=5,
    )
    date = models.SmallIntegerField()
    size = models.CharField(max_length=64)
    material = models.CharField(max_length=200)
    description = models.TextField()

    edition = models.BooleanField(default=False)
    edition_size = models.PositiveIntegerField(default=1)


    def poster(self):
        return self.image_set.first().image

    def get_slug(self):
        return '{}-{}'.format(self.title, self.date)

    def get_absolute_url(self):
        return reverse('art', args=[self.slug])


def image_path(instance, filename):
    ext = filename.split('.')[-1]
    # get filename
    count = instance.__class__.objects.count()
    if not filename: filename = 'lydia-venieri-{}-{}.{}'.format(instance.art.slug,  count,  ext)
    return os.path.join('images', filename)

class Image(models.Model):
    art = models.ForeignKey(Art, on_delete= models.SET_NULL, blank=True, null=True)
    image = VersatileImageField(upload_to=image_path, blank=True, null=True)
    def __str__(self):
        return self.art.title






class Video(models.Model):
    art = models.OneToOneField(Art, on_delete= models.SET_NULL, blank=True, null=True)
    video = EmbedVideoField(blank=True, null=True)
    visible = models.BooleanField(default=True)
    def __str__(self):
        return self.art.title



class Event(VisualEntity):
    class Meta:
        ordering = ['-date']
    header = models.CharField(max_length=200, blank=True, default='')
    order = models.IntegerField()
    date = models.DateField()
    leader = models.TextField(blank=True, default='')
    content = models.TextField(blank=True, default='')
    css = models.TextField(blank=True, default='')
    # poster = models.ForeignKey('Art',  on_delete= models.SET_NULL, blank=True, null=True)
    venue = models.CharField(max_length=200, blank=True, default='')
    location = models.CharField(max_length=200, blank=True, default='')


    def save(self, *args, **kwargs):
        if not self.header:
            self.header = self.title
        super(Event, self).save(*args, **kwargs)

    _metadata = {
        'title': 'title',
        'description': 'leader',
        'image': 'get_meta_image',
    }

    def get_meta_image(self):
        if self.poster.poster:
            return self.poster.poster().url

    def get_slug(self):
        return '{}-{}'.format(self.title, self.date)


    def get_absolute_url(self):
        return reverse('event', args=[self.slug])

    def poster(self):
        album =  self.albums.first()
        if album:
            return album.media.first()


class Page(ModelMeta, BaseModel):
    class Meta:
        ordering = ['order']

    _metadata = {
        'title': 'title',
        'description': 'description_300',
        # 'image': 'get_meta_image',
    }



    order = models.IntegerField()
    template = models.CharField(max_length=128, default='page.html')
    description_155 = models.TextField(blank=True, default='')
    description_200 = models.TextField(blank=True, default='')
    description_300 = models.TextField(blank=True, default='')
    url = models.URLField(blank=True, default='')
    in_menubar = models.BooleanField(default=True)
    content = models.TextField(blank=True, default='')
    css = models.TextField(blank=True, default='')
    javascript = models.TextField(blank=True, default='')

    def save(self, *args, **kwargs):
        super(Page, self).save(*args, **kwargs)


    @classmethod
    def menubar(cls):
        return cls.objects.filter(in_menubar=True, visible=True)

    def __str__(self):
        return self.title

    def get_absolute_url(self):
        return reverse('page', args=[self.slug])



