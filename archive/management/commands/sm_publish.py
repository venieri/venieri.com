import datetime

from django.core.management.base import BaseCommand, CommandError

from django.utils.dateparse import parse_date


class Command(BaseCommand):
    help = 'publish on social media'

    # ARG_PRESS_FILE = 'press_file'
    # def add_arguments(self, parser):
    #     parser.add_argument(self.ARG_PRESS_FILE)

    def handle(self, *args, **options):
        from archive import models
        #facebook = OpenFacebook(
        try:
             for event in models.Event.objects.all():
                self.stdout.write(self.style.SUCCESS('Successfully published "%s"' % event))
        except Exception as e:
            raise CommandError('Failed to published: %s' % event)
