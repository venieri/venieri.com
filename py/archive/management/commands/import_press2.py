import datetime

from django.core.management.base import BaseCommand, CommandError

from django.utils.dateparse import parse_date
import pickle

class Command(BaseCommand):
    help = 'Imports press'

    ARG_PRESS_FILE = 'press_file'
    def add_arguments(self, parser):
        parser.add_argument(self.ARG_PRESS_FILE)

    def handle(self, *args, **options):
        from archive import models
        for record in pickle.load(open(options[self.ARG_PRESS_FILE], 'rb')):
            try:
                print(record)
                id, title, is_visible, slug, publication_date, publication, authors, url = record

                models.Reference.objects.create(
                    title = title,
                    is_visible = True if is_visible else False,
                    slug = slug,
                    publication_date = datetime.datetime.strptime(publication_date, "%Y-%m-%d"),
                    publication=publication,
                    authors=authors,
                    tags=['press'],
                    article_url=url
                )
                # record = [field.strip() for field in line.split(',')]
                # record_len = len(record)
                # title = author = publication = volume = date_str = None
                # if record_len == 6:
                #     data = dict(zip(['title', 'authors', 'publication', 'volume', 'publication_date', 'url'],record))
                # elif record_len == 5:
                #     data = dict(zip(['title', 'authors', 'publication', 'volume', 'publication_date'], record))
                # elif record_len == 4:
                #     data = dict(zip(['title', 'publication', 'volume', 'publication_date'], record))
                # elif record_len == 3:
                #     data = dict(zip([ 'title',  'volume', 'publication_date', ], record))
                # else:
                #     print ("record error", record)
                #     break
                #
                # try:
                #     data.pop('volume')
                #     if 'title' not in data:
                #         data['title'] = ''
                #     data['publication_date'] = datetime.datetime.strptime(data['publication_date'], "%m/%d/%Y")
                #     models.Reference.objects.create(**data)
                # except:
                #     print (line)
                #     print (record)
                #     print ('date parse failed', '->%s<-' % data['publication_date'].strftime("%m/%d/%Y"))
                #     raise
            except Exception as e:
                print (record, e)
                raise



        # from archive import models
        # try:
        #      for line in solo_shows.split('\n'):
        #         parts = line.split('|')
        #         if len(parts) == 5:
        #             year, title, venue, location, info = parts
        #         else:
        #             year, title, venue, location = parts
        #             info = ''
        #         event = models.Event.objects.create(title=title.strip(),
        #                              start_date= datetime.datetime.now().replace(year=int(year)),
        #                              venue=venue.strip()+', '+location.strip()
        #                              )
        #         event.tags.add("show/group")
        #         self.stdout.write(self.style.SUCCESS('Successfully imported "%s"' % title))
        # except Exception as e:
        #     raise CommandError('Failed to import: %s->%s' % (line,e))
