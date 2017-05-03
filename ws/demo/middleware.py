from django.middleware.csrf import CsrfViewMiddleware 
from django.contrib.sessions.middleware import SessionMiddleware
from django.conf import settings


def is_mobile_app_access(request):
	# return request.META.get('HTTP_REFERER', None) is None and request.META.get('HTTP_COOKIE', None) is None and request.META.get('HTTP_X_REQUESTED_WITH', None) == 'your.app.name.here' and request.META.get('HTTP_ORIGIN', None) == 'file://'
	# return request.META['HTTP_USER_AGENT'] == 'iPhone'
    return True


class CustomCsrfViewMiddleware(CsrfViewMiddleware):
	def process_view(self, request, callback, callback_args, callback_kwargs):
		if is_mobile_app_access(request):
			return None
		else:
			return super(CustomCsrfViewMiddleware, self).process_view(request, callback, callback_args, callback_kwargs)

	def process_response(self, request, response):
		if is_mobile_app_access(request):
			return response
		else:
			return super(CustomCsrfViewMiddleware, self).process_response(request, response)


class CustomSessionMiddleware(SessionMiddleware):
	def process_request(self, request):
		if is_mobile_app_access(request):
			session_key = request.META.get("HTTP_AUTHORIZATION", None)
		else:
			session_key = request.COOKIES.get(settings.SESSION_COOKIE_NAME)
		request.session = self.SessionStore(session_key)
