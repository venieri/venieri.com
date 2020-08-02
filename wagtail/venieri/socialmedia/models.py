import datetime
import tempfile

from InstagramAPI import InstagramAPI
from django.apps import apps
from django.contrib.contenttypes.fields import GenericForeignKey
from django.contrib.contenttypes.models import ContentType
from django.db import models
from django.utils import timezone
from django_crypto_fields.fields import EncryptedCharField
# from pinterest import Pinterest
from twython import Twython
from wagtail.admin.edit_handlers import FieldPanel, ObjectList, TabbedInterface
from wagtail.contrib.settings.models import BaseSetting, register_setting
from wagtail.core.signals import page_published


@register_setting
class SocialMediaSettings(BaseSetting):
    instagram_username = models.CharField('user name',
                                          max_length=255, help_text='Your Instagram username, without the @')
    instagram_password = EncryptedCharField('password',
                                            max_length=214, help_text='Your Instagram username, without the @')

    twitter_consumer_key = models.CharField('consumer key',
                                            max_length=255, help_text='Your Twitter consumer_key')
    twitter_consumer_secret = EncryptedCharField('consumer secret',
                                                 max_length=214, help_text='Your Twitter consumer_secret')
    twitter_access_token_key = models.CharField('access token key',
                                                max_length=255, help_text='Your Twitter access_token_key')
    twitter_access_token_secret = EncryptedCharField('access token secret',
                                                     max_length=214, help_text='Your Twitter access_token_secret')

    first_tab_panels = [
        FieldPanel('instagram_username'),
        FieldPanel('instagram_password'),
    ]
    second_tab_panels = [
        FieldPanel('twitter_consumer_key'),
        FieldPanel('twitter_consumer_secret'),
        FieldPanel('twitter_access_token_key'),
        FieldPanel('twitter_access_token_secret'),
    ]

    edit_handler = TabbedInterface([
        ObjectList(first_tab_panels, heading='Instagram Account'),
        ObjectList(second_tab_panels, heading='Twitter Account'),
    ])

    def post_to_twitter(self, site, obj):
        twitter = Twython(
            self.twitter_consumer_key,
            self.twitter_consumer_secret,
            self.twitter_access_token_key,
            self.twitter_access_token_secret
        )
        image = obj.get_meta_image()
        with image.open_file() as media:
            response = twitter.upload_media(media=media)
        media_id = [response['media_id']]
        twitter.update_status(status=site.root_url + obj.get_absolute_url(), media_ids=media_id)

    def post_to_instagram(self, site, obj):
        instagramAPI = InstagramAPI(self.instagram_username, self.instagram_password)
        instagramAPI.login()
        #  1080 pixel width, and go up to 1350
        image = obj.get_meta_image()
        print(image.file)
        fp = tempfile.NamedTemporaryFile()
        fp.write(image.file.read())
        fp.seek(0)
        print(fp.name)
        return instagramAPI.uploadPhoto(fp.name, caption=obj.get_message())

    @classmethod
    def post(cls, obj):
        site = apps.get_model('wagtailcore.Site').objects.get(is_default_site=True)
        social_media_settings = SocialMediaSettings.for_site(site)
        for poster in cls.POSTERS:
            poster(social_media_settings, site, obj)

    POSTERS = [post_to_twitter, post_to_instagram]


class Job(models.Model):
    scheduled_for = models.DateTimeField(null=True, blank=True)
    block = models.BooleanField(default=False)
    status = (
        ('P', 'Pending'),
        ('E', 'Error'),
        ('H', 'Hold'),
        ('D', 'Done'),
    )
    status = models.CharField(max_length=1, choices=status, default='P')
    TARGETS = (
        ('Gr', 'Greece'),
        ('Eu', 'Europe'),
        ('Ny', 'New York'),
        ('La', 'Los Angeles'),

    )
    target = models.CharField(max_length=2, choices=TARGETS, default='Ny')
    caption = models.CharField(max_length=255)

    panels = [
        FieldPanel('scheduled_for'),
        FieldPanel('block'),
        #   FieldPanel('service'),
        FieldPanel('target'),
        FieldPanel('caption'),
    ]

    content_type = models.ForeignKey(ContentType, on_delete=models.CASCADE)
    object_id = models.PositiveIntegerField()
    content_object = GenericForeignKey('content_type', 'object_id')

    def __str__(self):
        return self.caption


def add_job_to_queue(sender, **kwargs):
    fire_for = [apps.get_model('events.EventPage'), apps.get_model('work.ArtPage')]
    date = timezone.now() + datetime.timedelta(hours=1)
    to_post = kwargs['instance']
    if to_post.__class__ in fire_for:
        job = Job.objects.create(
            content_object=to_post,
            scheduled_for=date,
            caption=to_post.get_message(),
        )


page_published.connect(add_job_to_queue)

# class FacebookAccount(Account):
#     access_token = models.CharField(max_length=256)
#
#     def post(self, obj):
#         graph = facebook.GraphAPI(access_token=self.access_token, version="2.12")
#         graph.put_object(
#             parent_object="me",
#             connection_name="feed",
#             message=obj.message(),
#             link=obj.get_absolute_url())
#
#
#
# class PintrestAccount(Account):
#     username_or_email = models.CharField(max_length=128)
#     user_password = models.CharField(max_length=128)
#     board_id = models.CharField(max_length=128)
#
#     def post(self, obj):
#         instagramAPI = InstagramAPI(self.user_name, self.user_password)
#         instagramAPI.login()
#         instagramAPI.uploadPhoto(obj.get_image_path(), caption=obj.title)
#         pinterest = Pinterest(username_or_email=self.username_or_email, password=self.user_password)
#         pinterest.login()
#         pin = pinterest.pin(
#             board_id=self.board_id,
#             image_url=object.get_image_path(),
#             description=obj.message(),
#             link=obj.get_image_path()
#         )
#
#
