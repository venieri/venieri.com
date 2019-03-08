from django.apps import apps
from django.core.management.base import BaseCommand, CommandError
from django.utils import timezone


# from pinterest import Pinterest

class Command(BaseCommand):
    help = 'Test posting'

    # def add_arguments(self, parser):
    #     parser.add_argument('tags', nargs='+')

    def handle(self, *args, **options):
        try:
            now = timezone.now()
            qs = apps.get_model('socialmedia.Job').objects.filter(status='P')
            for job in qs:  # apps.get_model('socialmedia.Job').objects.filter(scheduled_for__lte=now):
                apps.get_model('socialmedia.SocialMediaSettings').post(job.content_object)
                job.status = 'D'
                job.save()
                self.stdout.write(self.style.SUCCESS('Successfully posted %s' % job.content_object))
        except Exception as e:
            raise CommandError('Failed to post: %s' % e)
