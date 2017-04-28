from django.conf.urls import url
from rest_framework.urlpatterns import format_suffix_patterns
from demo import views

urlpatterns = [
    url(r'^profiles/$', views.ProfileList.as_view()),
    url(r'^profiles/(?P<pk>[0-9]+)/$', views.ProfileDetail.as_view()),
    url(r'^matches/$', views.MatchList.as_view()),
    url(r'^matches/(?P<pk>[0-9]+)/$', views.MatchDetail.as_view()),
 	# url(r'^login$', django_cas_ng.views.login, name='cas_ng_login'),
	# url(r'^logout$', django_cas_ng.views.logout, name='cas_ng_logout'),
	# url(r'^callback$', django_cas_ng.views.callback, name='cas_ng_proxy_callback'),
]

urlpatterns = format_suffix_patterns(urlpatterns)