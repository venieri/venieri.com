# -*- coding: utf-8 -*-
# Generated by Django 1.11.20 on 2019-03-04 21:10
from __future__ import unicode_literals

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('images', '0001_initial'),
        ('events', '0023_eventindexpage_search_image'),
    ]

    operations = [
        migrations.AddField(
            model_name='artindexpage',
            name='search_image',
            field=models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.SET_NULL, related_name='+', to='images.CustomImage', verbose_name='Search image'),
        ),
        migrations.AddField(
            model_name='artpage',
            name='search_image',
            field=models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.SET_NULL, related_name='+', to='images.CustomImage', verbose_name='Search image'),
        ),
        migrations.AddField(
            model_name='biopage',
            name='search_image',
            field=models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.SET_NULL, related_name='+', to='images.CustomImage', verbose_name='Search image'),
        ),
        migrations.AddField(
            model_name='eventpage',
            name='search_image',
            field=models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.SET_NULL, related_name='+', to='images.CustomImage', verbose_name='Search image'),
        ),
        migrations.AddField(
            model_name='projectindexpage',
            name='search_image',
            field=models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.SET_NULL, related_name='+', to='images.CustomImage', verbose_name='Search image'),
        ),
        migrations.AddField(
            model_name='projectpage',
            name='search_image',
            field=models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.SET_NULL, related_name='+', to='images.CustomImage', verbose_name='Search image'),
        ),
    ]
