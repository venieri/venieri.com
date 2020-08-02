from django.apps import apps
from django.core.management.base import BaseCommand, CommandError


#from pinterest import Pinterest

class Command(BaseCommand):
    help = 'Test posting'

    # def add_arguments(self, parser):
    #     parser.add_argument('tags', nargs='+')

    def handle(self, *args, **options):
        try:
            SocialMediaSettings = apps.get_model('socialmedia.SocialMediaSettings')
            site = apps.get_model('wagtailcore.Site').objects.get(is_default_site=True)
            social_media_settings = SocialMediaSettings.for_site(site)
            print ('social_media_settings.test', social_media_settings.test)

            self.stdout.write(self.style.SUCCESS('Successfully imported "%s"' % res))
        except Exception as e:
            raise CommandError('Failed to post: %s' % e)

