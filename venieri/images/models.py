import os

from django.db import models
from django.utils.text import slugify
from unidecode import unidecode
from wagtail.images.models import AbstractImage, AbstractRendition, Image


class CustomImage(AbstractImage):
    # Add any extra fields to image here

    # eg. To add a caption field:
    description = models.TextField(blank=True)

    admin_form_fields = Image.admin_form_fields + (
        # Then add the field names here to make them appear in the form:
        'description',
    )

    def get_upload_to(self, filename):
        folder_name = 'original_media'
        filename = self.file.field.storage.get_valid_name(filename)

        # do a unidecode in the filename and then
        # replace non-ascii characters in filename with _ , to sidestep issues with filesystem encoding
        filename = "".join((i if ord(i) < 128 else '_') for i in unidecode(filename))
        prefix, extension = os.path.splitext(filename)
        # Truncate filename so it fits in the 100 character limit
        # https://code.djangoproject.com/ticket/9893
        new_file_name = 'lydia-venieri-{}'.format(slugify(self.title))
        full_path = os.path.join(folder_name, new_file_name)
        if len(new_file_name) >= 95:
            chars_to_trim = len(new_file_name) - 94
            filename = new_file_name[:-chars_to_trim] + extension
        else:
            filename = new_file_name + extension
        full_path = os.path.join(folder_name, filename)
        return full_path


class CustomRendition(AbstractRendition):
    image = models.ForeignKey(CustomImage, on_delete=models.CASCADE, related_name='renditions')

    class Meta:
        unique_together = (
            ('image', 'filter_spec', 'focal_point_key'),
        )
