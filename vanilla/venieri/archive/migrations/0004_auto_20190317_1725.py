# Generated by Django 2.1.7 on 2019-03-17 17:25

import autoslug.fields
from django.db import migrations, models
import django.db.models.deletion
import sortedm2m.fields


class Migration(migrations.Migration):

    dependencies = [
        ('archive', '0003_auto_20190317_1723'),
    ]

    operations = [
        migrations.CreateModel(
            name='Entity',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('visible', models.BooleanField(default=True)),
                ('title', models.CharField(max_length=200)),
                ('slug', autoslug.fields.AutoSlugField(editable=False, populate_from='get_slug')),
                ('media', sortedm2m.fields.SortedManyToManyField(blank=True, help_text=None, related_name='entities', to='archive.Media')),
            ],
            options={
                'verbose_name_plural': 'entities',
            },
        ),
        migrations.RemoveField(
            model_name='art',
            name='id',
        ),
        migrations.RemoveField(
            model_name='art',
            name='slug',
        ),
        migrations.RemoveField(
            model_name='art',
            name='title',
        ),
        migrations.RemoveField(
            model_name='art',
            name='visible',
        ),
        migrations.RemoveField(
            model_name='event',
            name='id',
        ),
        migrations.RemoveField(
            model_name='event',
            name='slug',
        ),
        migrations.RemoveField(
            model_name='event',
            name='title',
        ),
        migrations.RemoveField(
            model_name='event',
            name='visible',
        ),
        migrations.AddField(
            model_name='art',
            name='entity_ptr',
            field=models.OneToOneField(auto_created=True, default=1, on_delete=django.db.models.deletion.CASCADE, parent_link=True, primary_key=True, serialize=False, to='archive.Entity'),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='event',
            name='entity_ptr',
            field=models.OneToOneField(auto_created=True, default=1, on_delete=django.db.models.deletion.CASCADE, parent_link=True, primary_key=True, serialize=False, to='archive.Entity'),
            preserve_default=False,
        ),
    ]