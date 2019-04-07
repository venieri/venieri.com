import datetime

from django.core.management.base import BaseCommand, CommandError
from events.models import EventPage
from wagtail.core.models import Page

solo_shows = """2008| See No Evil |   Terra Gallery Tokyo |   Japan 
2007| War Games |   Stux Gallery |   New York
2007| War Games |   Gallery Lola Nikalaou |   Thessaloniki
2006| Forever After |   Gallery 3 |   Athens
2006| For Ever After |   Luxe |   New York
2005| For Ever After |   Gallery Quang |   Paris
2004| Hibernation – Summer Olympics |   Vernikos Foundation |   Kastella, Athens
2004| Sleeping Beauty Conscience |   Mid-Manhattan Library |   New York
2004| Hibernation |   Luxe Gallery |   New York
2002| Hibernation |   Gallerie Three |   Athens
2002| Hibernation |   Gallerie Samy Kinge |   Paris
2001| Summer Celebration |   Sundaram Tagore Gallery |   New York
2001| Beyond Being |   Space Untitled |   New York
2000| Beyond Being |   Gallery Three |   Athens
2000| Axiome Lambda |   Gallery Samy Kinge |   Paris
2000| Beyond Being |   Gallery Lola Nikolaou |   Thessaloniki, Greece
1999| Who is Nostalgic |   Gallery Vourkariani |   Kia, Greece
1997| Two Strangers on the Moon |   Galerie Selini |   Athens
1997| Cool Memories |   Galerie lola Nikolaou |  Thessalonique, Greece
1995| Anima Mundis |   Art Space X |   Athens
1995| Manifeste Tellurique III |   Gallerie Samy Kinge |   Paris
1994| Manifeste Tellurique II |   Galerie lola Nikolaou |   Thessalonique, Greece
1994| Manifeste Tellurique I |   Gallerie d’Athens |   Athens
1993| Anima Mundis |   Banque Franco-Hellenique |   Larissa
1990| Les Sistres du Temps | Galerie Asbaek Pilon |   Copenhagan
1990| Les Sistres du Temps |   Ancien Musee Archeologique | Thessalonique
1988| FIAC |   Galerie Samy Kinge |   Grande Palais, Paris
1988| Les Figures De Lydia |   Galerie Medoussa |   Athenes
1986| Exposition personnelle |   Galerie Samy Kinge |   Paris"""


class Command(BaseCommand):
    help = 'Imports events'

    def add_arguments(self, parser):
        parser.add_argument('tags', nargs='+')

    def handle(self, *args, **options):
        try:
            lydia = Page.objects.get(slug='lydia-venieri')

            for line in solo_shows.split('\n'):
                parts = line.split('|')
                if len(parts) == 5:
                    year, title, venue, location, info = parts
                else:
                    year, title, venue, location = parts
                    info = ''
                event = EventPage.objects.get(title=title.strip(),
                                     venue=venue.strip(),
                                     location=location.strip())
                date = datetime.datetime.now()
                event.date = date.replace(year=int(year))
                # event.tags.add('solo show')
                # lydia.add_child(instance=new_page)
                event.save_revision().publish()
                self.stdout.write(self.style.SUCCESS('Successfully imported "%s"' % event))
        except Exception as e:
            raise CommandError('Failed to import[%s]: %s' % (e, line))
