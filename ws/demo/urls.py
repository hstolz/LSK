from django.conf.urls import url, include
from django.contrib import admin
from rest_framework.urlpatterns import format_suffix_patterns
from demo import views
from django.contrib.auth import views as auth_views

# admin.autodiscover()

urlpatterns = [
    url(r'^profiles/$', views.ProfileList.as_view()),
    url(r'^profiles/(?P<pk>[0-9]+)/$', views.ProfileDetail.as_view()),
    url(r'^matches/$', views.MatchList.as_view()),
    url(r'^matches/(?P<pk>[0-9]+)/$', views.MatchDetail.as_view()),
	url(r'^login/$', views.Login.as_view()),
    # url(r'^logout/$', views.Logout.as_view()),
    url(r'^admin/', admin.site.urls),
]

urlpatterns = format_suffix_patterns(urlpatterns)