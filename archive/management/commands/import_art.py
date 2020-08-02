import datetime
import glob, re, string

from PIL import Image
from django.core.files.base import ContentFile
from django.core.management.base import BaseCommand, CommandError

re_bronic_heros=re.compile(r'Lydia-Venieri-\d+-(.*)-plate')
re_bronic=re.compile(r'Lydia_Venieri-Byronic-(.*).jpg')
re_bubbles=re.compile(r'lydia_venieri-bubbles-(.*).jpg')
re_planetic_exodus=re.compile(r'PLANETIC_EXODUS-\d+-(.*)-2010.jpg')


class Command(BaseCommand):
    help = 'Imports art'

    def add_arguments(self, parser):
        parser.add_argument('art sources', nargs='+')

    def handle(self, *args, **options):
        from archive import models
        print (args, options)
        file_path = 'None'
        project = models.Project.objects.get(pk=12)
        try:

            for file_path in options['art sources']:
                match = re_planetic_exodus.search(file_path)
                if match:
                    #title =  match.group(1).replace('_',' ')
                    title = string.capwords(match.group(1).replace('_', ' '))
                    description = 'Offset print on satin, %s inches' % '80x40'
                    #image_obj = Image.open(open(file_path,'rb').read())
                    content = ContentFile(open(file_path,'rb').read())
                    m = models.Media.objects.create(caption='Planetic Exodus - '+title)

                    m.image.save(models.media_path(m, file_path), content)
                    art = models.Art.objects.create(
                        title = title,
                        project = project,
                        sd_type = models.Art.SD_Photograph,
                        year=2010,
                        description=description
                    )
                    art.tags.add("photo")
                    art.media.add(m)

                    # return
                    self.stdout.write(self.style.SUCCESS('Successfully imported %s "%s"' % (title, art)))
        except Exception as e:
            raise CommandError('Failed to import: %s->%s' % (file_path,e))
