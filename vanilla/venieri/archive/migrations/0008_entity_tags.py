# Generated by Django 2.1.7 on 2019-03-18 15:27

from django.db import migrations
import tagulous.models.fields


class Migration(migrations.Migration):

    dependencies = [
        ('archive', '0007_auto_20190318_1447'),
    ]

    operations = [
        migrations.AddField(
            model_name='entity',
            name='tags',
            field=tagulous.models.fields.TagField(_set_tag_meta=True, force_lowercase=True, help_text='Enter a comma-separated tag string', initial='food/eating, food/cooking, gaming/football', to='archive.Tags', tree=True),
        ),
    ]
