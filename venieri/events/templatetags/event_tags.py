from django.template import Template
from django import template
from django.utils.html import conditional_escape
from django.utils.safestring import mark_safe

from wagtail.core.models import Orderable, Page

register = template.Library()


@register.simple_tag(takes_context=True)
def render(context, template_str):
    template = Template(template_str)
    return mark_safe(template.render(context))

@register.simple_tag
def image_from(page, indx):
    gallery_item = page.gallery_images.all()[indx]
    return gallery_item.image


@register.simple_tag
def menu():
    e = Page.objects.get(slug='home')
    return e.get_children().live()

