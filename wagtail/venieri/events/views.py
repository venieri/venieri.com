
from django.shortcuts import render


# Create your views here.
def select_toggle(request):
    return render(request,
                  'your-template.html',
                   context={},
                   status=204) # your custom status in this case 204