# -*- coding: utf-8 -*-
# Generated by Django 1.11.20 on 2019-03-07 00:12
from __future__ import unicode_literals

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('contenttypes', '0002_remove_content_type_name'),
        ('socialmedia', '0008_auto_20190306_2257'),
    ]

    operations = [
        migrations.AddField(
            model_name='job',
            name='content_type',
            field=models.ForeignKey(default=1, on_delete=django.db.models.deletion.CASCADE, to='contenttypes.ContentType'),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='job',
            name='object_id',
            field=models.PositiveIntegerField(default=1),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='job',
            name='status',
            field=models.CharField(choices=[('P', 'Pending'), ('E', 'Error'), ('H', 'Hold'), ('D', 'Done')], default='P', max_length=1),
        ),
    ]
