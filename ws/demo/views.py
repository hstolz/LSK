from demo.models import Profile, Match
from demo.serializers import ProfileSerializer, MatchSerializer
from rest_framework import generics, status
from rest_framework.response import Response
from rest_framework.authtoken.models import Token
from django.conf import settings
from django.core.exceptions import ValidationError
from django.contrib.auth import authenticate
from django.db import IntegrityError
import json

def check_ios(request):
	return request.META['HTTP_USER_AGENT'] == 'iPhone'

class ProfileList(generics.ListCreateAPIView):
    queryset = Profile.objects.all()
    serializer_class = ProfileSerializer

    # def create(self, request):
    # 	data = json.loads(request.body)
    # 	p_password = data.get('password')
    # 	p_username = data.get('username')
    # 	p_first_name = data.get('first_name')
    # 	p_last_name = data.get('last_name')
    # 	p_email = data.get('email')
    # 	p_known_lang = data.get('known_lang')
    # 	p_learn_lang = data.get('learn_lang')
    # 	p = Profile.objects.create_user(password=p_password, username=p_username, 
    # 									first_name=p_first_name, last_name=p_last_name, 
    # 									email=p_email, known_lang=p_known_lang, learn_lang=p_learn_lang)
    # 	try:
    # 		p.save()
    # 	except (ValidationError, IntegrityError) as e: # ValueError?
    # 		return Response(data=e.message, status=status.HTTP_400_BAD_REQUEST)
    # 	else:
    # 		return Response(status=status.HTTP_201_CREATED)

class ProfileDetail(generics.RetrieveUpdateDestroyAPIView):
    queryset = Profile.objects.all()
    serializer_class = ProfileSerializer

class MatchList(generics.ListCreateAPIView):
	queryset = Match.objects.all()
	serializer_class = MatchSerializer

	def create(self, request):
		if not settings.DEBUG and not check_ios(request):
			return Response(data='not an iPhone', status=status.HTTP_400_BAD_REQUEST)

		data = json.loads(request.body)
		i_user_name = data.get('i_user_name')
		a_user_name = data.get('a_user_name')
		learn_lang  = data.get('learn_lang')
		time_1 		= data.get('time_1')
		time_2 		= data.get('time_2')
		time_3 		= data.get('time_3')

		try:
			initiator = Profile.objects.get(user_name=i_user_name)
		except:
			return Response(data='initiator not found', status=status.HTTP_400_BAD_REQUEST)
		else:
			if a_user_name:
				try:
					acceptor = Profile.objects.get(user_name=a_user_name)
				except:
					return Response(data='acceptor not found', status=status.HTTP_400_BAD_REQUEST)
			else:
				acceptor = Profile.objects.filter(known_lang__exact=learn_lang).order_by('?')
				if len(acceptor) > 0:
					acceptor = acceptor[0]
				else:
					return Response(data='acceptor not found', status=status.HTTP_400_BAD_REQUEST)

			m = Match(user_id1=initiator, user_id2=acceptor)
			try:
				m.save()
			except:
				return Response(data='could not create match', status=status.HTTP_400_BAD_REQUEST)
			else:
				return Response(status=status.HTTP_201_CREATED)

class MatchDetail(generics.RetrieveUpdateDestroyAPIView):
	queryset = Match.objects.all()
	serializer_class = MatchSerializer

class Login(generics.CreateAPIView):
	queryset = Profile.objects.all()
	serializer_class = ProfileSerializer

	def create(self, request):
		data = json.loads(request.body)
		username = data.get('username')
		password = data.get('password')

		user = authenticate(username=username, password=password)
		if user is not None:
			token = Token.objects.create(user=user)
			return Response(data=token, status=status.HTTP_200_OK)
		else:
			return Response(data='login failed', status=status.HTTP_401_UNAUTHORIZED)
