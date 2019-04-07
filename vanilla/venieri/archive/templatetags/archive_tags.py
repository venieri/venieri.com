import os
from django.conf import settings
from django.template import Template
from django import template
from django.utils.html import conditional_escape
from django.utils.safestring import mark_safe

from .. import models

register = template.Library()


@register.simple_tag(takes_context=True)
def render(context, template_str):
    template = Template(template_str)
    return mark_safe(template.render(context))


@register.simple_tag
def art(**kwargs):
    art = models.Art.objects.get(**kwargs)
    return art


@register.simple_tag
def media(**kwargs):
    media = models.Media.objects.get(**kwargs)
    return media


@register.simple_tag
def media_image(**kwargs):
    media = models.Media.objects.get(**kwargs)
    return media.image

import re

@register.tag
def with_media(parser, token):
    try:
        tag_name, arg = token.contents.split(None, 1)
    except ValueError:
        raise template.TemplateSyntaxError(
            "%r tag requires arguments" % token.contents.split()[0]
        )

    nodelist = parser.parse(('endwith_media',))
    parser.delete_first_token()
    m = re.search(r'(.*?) as (\w+)', arg)
    if not m:
        raise template.TemplateSyntaxError("%r tag had invalid arguments" % tag_name)
    id, var_name = m.groups()
    # if not (format_string[0] == format_string[-1] and format_string[0] in ('"', "'")):
    #     raise template.TemplateSyntaxError(
    #         "%r tag's argument should be in quotes" % tag_name
    #     )
    return MediaNode(nodelist,id, var_name)

class MediaNode(template.Node):
    def __init__(self, nodelist, id, var_name):
        self.nodelist = nodelist
        self.id = id
        self.var_name = var_name

    def render(self, context):
        context[self.var_name] =  models.Media.objects.get(pk=self.id)
        return self.nodelist.render(context)


@register.inclusion_tag('media_responsive.html')
def render_media(*args, **kwargs):
    context = {}
    if 'class' in kwargs:
        context['media_class'] = kwargs.pop('class')

    if 'show_caption' in  kwargs:
        context['show_caption'] =  kwargs.pop('show_caption')
    context['media'] = models.Media.objects.get(**kwargs)
    if not args:
        context['media_image_url'] = context['media'].image.thumbnail["900x900"]
    else:
        context['media_image_url'] = context['media'].image.thumbnail[args[0]]
    return context


@register.inclusion_tag('css_framework.html')
def include_css_framework(*args, **kwargs):
    return {'STATIC_SITE': settings.STATIC_SITE}

@register.inclusion_tag('analytics.html')
def include_analytics(*args, **kwargs):
    return {'STATIC_SITE': settings.STATIC_SITE}