from demo.models import Profile, Match
from demo.serializers import ProfileSerializer, MatchSerializer
from rest_framework import generics, status
from rest_framework.response import Response
from rest_framework.authtoken.models import Token
from rest_framework.authentication import BasicAuthentication
from rest_framework.decorators import authentication_classes, permission_classes
from django.conf import settings
from django.core.exceptions import ValidationError
from django.contrib.auth import login, logout, authenticate
from django.contrib.auth.mixins import LoginRequiredMixin
from django.db import IntegrityError
from django.db.models import Q
import json


@authentication_classes([])
@permission_classes([])
class Register(generics.CreateAPIView):
	queryset = Profile.objects.all()
	serializer_class = ProfileSerializer

	def create(self, request):
		data = json.loads(request.body)
		p_password   = data.get('password')
		p_username   = data.get('username')
		p_first_name = data.get('first_name')
		p_last_name  = data.get('last_name')
		p_email 	 = data.get('email')
		p_known_lang = data.get('known_lang')
		p_learn_lang = data.get('learn_lang')
		
		try:
			p = Profile.objects.create_user(password=p_password, username=p_username, first_name=p_first_name, 
				last_name=p_last_name, email=p_email, known_lang=p_known_lang, learn_lang=p_learn_lang)
		except (ValidationError, IntegrityError) as e:
			return Response(data=e.message, status=status.HTTP_400_BAD_REQUEST)
		else:
			return Response(status=status.HTTP_201_CREATED)


# LoginRequiredMixin needed
class ProfileList(generics.ListAPIView):
	queryset = Profile.objects.all()
	serializer_class = ProfileSerializer

	def list(self, request):
		username = request.user.get_username()
		try:
			initiator = Profile.objects.get(username=username)
		except:
			return Response(data='initiator not found', status=status.HTTP_400_BAD_REQUEST)
		else:
			c1 = Q(user_id1=initiator.id)
			c2 = Q(user_id2=initiator.id)
			matches = Match.objects.filter(c1 | c2)
			ids = [m.user_id1.id if m.user_id1 != initiator else m.user_id2.id for m in matches]
			c3 = Q(pk__in=ids)
			c4 = Q(learn_lang=initiator.known_lang)
			c5 = Q(known_lang=initiator.learn_lang)
			profiles = (Profile.objects.exclude(c3)).filter(c4 & c5)
			serializer = ProfileSerializer(profiles, many=True)
			return Response(serializer.data, status=status.HTTP_200_OK)


# LoginRequiredMixin needed
class ProfileDetail(generics.RetrieveUpdateDestroyAPIView):
	queryset = Profile.objects.all()
	serializer_class = ProfileSerializer


# LoginRequiredMixin needed
class MatchList(generics.ListCreateAPIView):
	queryset = Profile.objects.all()
	serializer_class = ProfileSerializer

	def list(self, request):
		username = request.user.get_username()
		try:
			initiator = Profile.objects.get(username=username)
		except:
			return Response(data='initiator not found', status=status.HTTP_400_BAD_REQUEST)
		else:
			# t1 = Q(initiator=initiator.id)
			# t2 = Q(acceptor=initiator.id)
			# test = Profile.objects.all(t1 | t2)
			# http://stackoverflow.com/questions/12087696/using-related-name-correctly-in-django
			# http://stackoverflow.com/questions/5734377/filter-for-elements-using-exists-through-a-reverse-fk
			c1 = Q(user_id1=initiator.id)
			c2 = Q(user_id2=initiator.id)
			matches = Match.objects.filter(c1 | c2)
			ids = [m.user_id1.id if m.user_id1 != initiator else m.user_id2.id for m in matches]
			profiles = Profile.objects.filter(pk__in=ids)
			serializer = ProfileSerializer(profiles, many=True)
			return Response(serializer.data, status=status.HTTP_200_OK)

	def create(self, request):
		data = json.loads(request.body)
		i_username = data.get('i_username')
		a_username = data.get('a_username')
		time_1 	   = data.get('time_1')
		time_2 	   = data.get('time_2')
		time_3 	   = data.get('time_3')

		try:
			initiator = Profile.objects.get(username=i_username)
		except:
			return Response(data='initiator not found', status=status.HTTP_400_BAD_REQUEST)
		else:
			if a_username:
				try:
					acceptor = Profile.objects.get(username=a_username)
					# need to also ensure that they don't make a duplicate match with the same user!
				except:
					return Response(data='acceptor not found', status=status.HTTP_400_BAD_REQUEST)
			else:
				c1 = Q(user_id1=initiator.id)
				c2 = Q(user_id2=initiator.id)
				matches = Match.objects.filter(c1 | c2)
				ids = [m.user_id1.id if m.user_id1 != initiator else m.user_id2.id for m in matches]
				strangers = Profile.objects.exclude(pk__in=ids) # only filter within unmatched people
				c3 = Q(known_lang__exact=initiator.learn_lang)
				c4 = Q(learn_lang__exact=initiator.known_lang)
				acceptor = strangers.filter(c3 & c4).order_by('?')

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
				serializer = ProfileSerializer(acceptor)
				return Response(serializer.data, status=status.HTTP_201_CREATED)

# LoginRequiredMixin needed
class MatchDetail(generics.RetrieveUpdateDestroyAPIView):
	queryset = Match.objects.all()
	serializer_class = MatchSerializer

	# def retrieve(self, request):
	# 	data = json.loads(request.body)
	# 	username = data.get('username')


@authentication_classes([])
@permission_classes([])
class Login(generics.CreateAPIView):
	queryset = Profile.objects.all()
	serializer_class = ProfileSerializer

	def create(self, request):
		data = json.loads(request.body)
		username = data.get('username')
		password = data.get('password')

		user = authenticate(username=username, password=password)
		if user is not None:
			login(request, user)
			return Response(status=status.HTTP_200_OK)
		else:
			return Response(data='login failed', status=status.HTTP_401_UNAUTHORIZED)


# LoginRequiredMixin needed
class Logout(generics.CreateAPIView):
	queryset = Profile.objects.all()
	serializer_class = ProfileSerializer

	def create(self, request):
		logout(request)
		return Response(status=status.HTTP_204_NO_CONTENT)

