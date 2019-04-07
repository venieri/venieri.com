# Generated by Django 2.1.7 on 2019-03-17 16:45

import archive.models
import autoslug.fields
from django.db import migrations, models
import django.db.models.deletion
import tagulous.models.models
import versatileimagefield.fields


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='Media',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('caption', models.CharField(max_length=200)),
                ('slug', autoslug.fields.AutoSlugField(editable=False, populate_from='caption')),
                ('image', versatileimagefield.fields.VersatileImageField(blank=True, null=True, upload_to=archive.models.media_path)),
            ],
        ),
        migrations.CreateModel(
            name='Tags',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=255, unique=True)),
                ('slug', models.SlugField()),
                ('count', models.IntegerField(default=0, help_text='Internal counter of how many times this tag is in use')),
                ('protected', models.BooleanField(default=False, help_text='Will not be deleted when the count reaches 0')),
                ('path', models.TextField()),
                ('label', models.CharField(help_text='The name of the tag, without ancestors', max_length=255)),
                ('level', models.IntegerField(default=1, help_text='The level of the tag in the tree')),
                ('parent', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.CASCADE, related_name='children', to='archive.Tags')),
            ],
            options={
                'ordering': ('name',),
                'abstract': False,
            },
            bases=(tagulous.models.models.BaseTagTreeModel, models.Model),
        ),
        migrations.AlterUniqueTogether(
            name='tags',
            unique_together={('slug', 'parent')},
        ),
    ]