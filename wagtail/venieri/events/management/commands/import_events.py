import datetime

from django.core.management.base import BaseCommand, CommandError
from .... import models

group_shows = """2017|  Summer Sex I - On the Spur of the Moment|Lichtundfire|New York
2017|On Paper|Paris Koh Fine Arts|New York
2017|Xanadu:Land of Enchantment|President’s Gallery John Jay College of Criminal Justice CUNY|New York|Curated by Dr. Thalia Vrachopoulos
2016|Collateral Damage|The Anya and Andrew Shiva Gallery|New York|Curated by Drs. Jungsil Lee & Thalia Vrachopoulos
2015|Ithaca Returned|The Blender Gallery|Athens
2015|Mykonos Biennale - Antidote Treasure Hunt|Delos|Greece
2015|Mykonos Biennale|Archaeologic Museum|Mykonos
2015|EYES ONLY: PHOTOGRAPHS|Stux + Haller|NEW YORK
2014|THE STOLEN BIRD|Vanessa Quang|Paris
2014|MYKONOS BIENNALE|CRISIS AND PAGANISM|Vanessa Quang|Paris
2014|BURNING BRIGHT: TIGER|TIGER|Stux Gallery|New York
2013|Mykonos Biennale|Archaeologic Museum|Mykonos.
2013|HELL AS PAVILION|Palais de Tokyo|Paris|curated by Nadja Argyropoulou 
2013|In Praise of Chance and Failure|Family Business|New York
2010| Sculptures in the Garden| Botanical Gardens of Kefalonia, Kosmtatos Foundation|Greece|curated by Liana Scourles.
2010|Low Blow: And Other Species of Confusion|Stefan Stux Gallery|New York
2009|Tokyo 101 Contemporary|Terra Gallery|Tokyo
2008| Scope 08|Terra Gallery|Miami
2008|Scope 08|Terra Gallery|London
2008|Art Taipei|Terra Gallery|Taiwan
2008|Korean International Art Fair|Terra Gallery|Korea
2008|Art Miami 08|Stux Gallery|Miami
2008|Shanghai Art Fair|Terra Gallery|China
2008|Selection Art Moscow 2008|Terra Gallery|Moscow
2008|From Head to Toe|Stux Gallery|New York
2008|NEXT Art Fair|Stux Gallery|Chicago
2007|Macedonian Museum of Contemporary Art|Thessaloniki|Greece
2007|War Games|Gallery Quang, Show Off!|Paris
2007|Scope Basel International Art Fair|Stux Gallery|Basel
2007|Art Athina|Luxe Gallery|Athens
2007|Art Chicago|Luxe Gallery|Chicago
2007|Art Miami|Stux Gallery|Miami
2007|The Nightly News|Luxe|New York|curated by Kathleen Goncharov and Stephan Stoyanov
2006|War Games|Gallery Luxe FIAC 2006|Paris
2006|Tarot|Gallery Quang|Paris
2006|The Last Conflict|Location One|New York
2006|The Venieri Tarot|Gallery Quang|Paris
2006|Oh, You Beautiful Doll|Andrea Meislin Gallery|New York|curated by Douglas F.Maxwell
2005|ARTISSIMA 12|Luxe Gallery|Turin
2005|Platonic Exodus - FIAC 2005|Luxe Gallery|Paris
2005|It’s Not About Sex|Luxe Gallery|New York
2005|Propos d’Europe IV|Foundation Hippocrene, Agence de Rob Mallet- Stevens|Paris
2005|Art Athina|Luxe Gallery|Athens
2005|Flash Art Fair|Luxe Gallery|Milan
2005|Diva|Luxe Gallery|New York
2004|Drawings|Luxe Gallery|New York 
2004|FIAC 2004|Gallery Luxe|Paris 
2004|Art in General|Studio Visit|New York
2004|Tower of Symbols|Summer Olympics|Athens
2003|Alive In New York|Eugenia Cucalon Gallery|New York
2003|Centre Culturel Hellenique|Paris|France
2002|Lydia Venieri|Atelier Mallet Stevens|Paris
2002|FIAC 2002|Video Novella|Gallerie Samy Kinge|Paris
2002|Lydia Venieri|Centre Cultural de Marrousi|Athens
2001|Storm On Moon|Selini Gallery|Athens
2001|Greek Gods and Heroes|Centre for Contemporary Art in Dordrecht|Netherlands
2000|Greek Contemporary Art|Glassing Gallery|Munster, Germany
2000|L’Oeil De La Galerie “Samy Kinge”|Selini Galerie|Athens
1999|A Water Melon| BenetonCinema Phiri|Athens
1999|Pret Art Porter|Dakis Ioannou Fondation|Athens
1999|Approaching Hellinism: Generation 80s & 90s|Cultural Centre|Stockholm
1999|Approaching Hellinism: Generation 80s & 90s|Dazarma Museum|Falum, Sweden
1999|Touch of Art in Ordinary Objects|Selini Gallery|Athens
1999|Opening of Possibilities|Hewlett Packard|Gazi,Athens
1999|Approaching Hellinism: Generation 80s & 90s|Vaiden Castle|Luxembourg
1999|Art Quake|Benakiom Museum|Athens
1999|Approaching Hellinism: Generation 80s & 90s|National Gallery of Greece|Athens
1998|Triptych|Downtown Gallery|Athens
1998|Art & Technology Festival|Eleana Tounta Gallery|Athens
1998|Trash Art|Gazi|Athens
1998|Croix Rouge||Athens
1998|Flying Art|Municipality of Athens, Varvakio Square|Athens
1997|42nd Salon de Montrouge|Salon de Montrouge|Paris
1996|Manifesta 1|Rotterdam|Netherlands
1996|Pandora’s Box, Women/Beyond Borders|California and Basel|Switzerland
1995|International Video Art Festival|Syracuse|Italy
1995|FIAC 1995, “Fin”|Gallerie Samy Kinge|Paris
1995|Lydia Venieri|Espace EIFFEL Branely|Paris
1994|Premiere Rencontre Internationale de Sculpture|Centre Culturel Europeen de Delphes|Delphes,Greece
1992|Ermata. Errance du Sacre|Galerie Montenay|Paris
1992|Spira I. Douze Createurs Grecs|Circulo de Bellas Artes|Madrid
1992|Metamorphoses du Moderne|Pinacotheque Nationale|Athens
1990|Biennale Internationale de Jeunes Createurs|Musee Skirnion|Athens
1989|Espirt et Corps|sous les auspices du Ministere de la Culture Greece|Zappion Athens
1989|Celebration de la Terre|organisation par Earth Trust, Centre Culturel du Parc de la Liberte|Athens
1989|Humour et Revolution|organisee a l’occation de 200 ans de la Revolution Franciase|Biennale de Cannes|Cannes et Barcelone
1988|Image et Lettre|Galerie Niki Diana Marquardt|Paris| Curated by Demosthenes Davetas.
1988|Salon de Montrouge|Paris|France
1988|Exposition de l’Institue Francais d’Athenes|Salle Costis Palamas|Athens
1987|Exposition Panhellenique|Piree|Greece
1987|Carte Blanche, a l’occation de l’anniversaire de 10 ans du Centre George Pompidou|Galeries Contemporaines|Paris 
1986| Paris Salon des Comparaisons|Grande Palais|Paris
1986| Biennale de Jeunes Createurs de la Mediterannee Europeenne||Greece
1986|Europeenne|Thessalonique|Greece
1985|Salon de Mai|Grande Palais|Paris
1983|Exposition a l’Ateilier de Yankel|Galeire Bernanos|Paris"""


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
            lydia = EventIndexPage.objects.get(slug='lydia-venieri')

            for line in solo_shows.split('\n'):
                parts = line.split('|')
                if len(parts) == 5:
                    year, title, venue, location, info = parts
                else:
                    year, title, venue, location = parts
                    info = ''
                new_page = EventPage(title=title.strip(),
                                     start_date= datetime.datetime.now().replace(year=int(year)),

                                     venue=venue.strip(),
                                     location=location.strip(),
                                     intro=title,
                                     owner=lydia.owner)
                new_page.tags.add("group show")
                lydia.add_child(instance=new_page)
                new_page.save_revision().publish()
                self.stdout.write(self.style.SUCCESS('Successfully imported "%s"' % title))
        except:
            raise CommandError('Failed to import: %s' % line)
