import datetime
import tempfile
import os
from django.conf import settings
from django.apps import apps
from django.core.management.base import BaseCommand, CommandError
from events.models import EventPage
from wagtail.core.models import Page
from twython import Twython
#from pinterest import Pinterest
import requests
from InstagramAPI import InstagramAPI
import facebook

class Command(BaseCommand):
    help = 'Test posting'

    # def add_arguments(self, parser):
    #     parser.add_argument('tags', nargs='+')

    def handle(self, *args, **options):
        try:
            event = apps.get_model('events.EventPage').objects.last()
            apps.get_model('socialmedia.SocialMediaSettings').post(event)



            self.stdout.write(self.style.SUCCESS('Successfully posted'))
        except Exception as e:
            raise CommandError('Failed to post: %s' % e)


# def instagram_post(obj):
#     instagramAPI = InstagramAPI('thanosagram', 'R30d5tar%')
#     instagramAPI.login()
#     #  1080 pixel width, and go up to 1350
#     image = obj.get_meta_image()
#     print (image.file)
#     fp = tempfile.NamedTemporaryFile()
#     fp.write(image.file.read())
#     fp.seek(0)
#     print(fp.name)
#     return instagramAPI.uploadPhoto(fp.name, caption=obj.get_message())
#
#
#
# def pintrest_post(obj):
#     pinterest = Pinterest(username_or_email='thanosv@gmail.com', password='R30d5tar%')
#     logged_in = pinterest.login()
#
#     boards = pinterest.boards()
#
#     print (boards)
#
#
# def facebook_post(obj):
#     graph = facebook.GraphAPI(access_token="EAAFViUItQKUBADtLPIsP0UTGcZBbTbEaqNPHlmuLZAYmTnfE2ZBDi7ZApUrkgIzevXacDQkHZA3JECmpZCN6RUMt2luDwuwy5yKvZASqEYIoEOSoun10nirrgQRdtSS1e2980ghQiITMUwnNZBLPDGNKR9l22tOB41nGEeaFSDlhYGdM7J1cAkrpiL69CaakkyUr2DMdhFVZABwZDZD", version="3.1")
#     Site = apps.get_model('wagtailcore.Site')
#     site = Site.objects.get(is_default_site=True)
#     graph.put_object(
#         parent_object="me",
#         connection_name="feed",
#         message=obj.get_message(),
#         link=site.root_url + obj.get_absolute_url())