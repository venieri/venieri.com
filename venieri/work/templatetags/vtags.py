from django.template import Template
from django import template
from django.utils.html import conditional_escape
from django.utils.safestring import mark_safe
from .. models import Art, Event, Project, Page

register = template.Library()


@register.simple_tag(takes_context=True)
def render(context, template_str):
    template = Template(template_str)
    return mark_safe(template.render(context))

@register.simple_tag
def art(**kwargs):
    art = Art.objects.get(**kwargs)
    return art

@register.simple_tag
def artworks(**kwargs):
    return Art.objects.filter(**kwargs)


@register.simple_tag
def event(**kwargs):
    return Event.objects.get(**kwargs)
    return art

@register.simple_tag
def events(**kwargs):
    return Event.objects.filter(**kwargs)


@register.simple_tag
def project(**kwargs):
    return Project.objects.get(**kwargs)


@register.simple_tag
def projects(**kwargs):
    return Project.objects.filter(**kwargs)



@register.simple_tag
def page(**kwargs):
    return Page.objects.get(**kwargs)


@register.simple_tag
def pages(**kwargs):
    return Page.objects.filter(**kwargs)