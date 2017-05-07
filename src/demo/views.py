from demo.models import Profile, Match
from demo.serializers import RegistrationSerializer, ProfileSerializer, MatchSerializer
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
from datetime import datetime, timedelta
import json


class ProfileList(generics.ListAPIView):
	queryset = Profile.objects.all()
	serializer_class = ProfileSerializer

	def list(self, request):
		username = request.user.get_username()
		try:
			initiator = Profile.objects.get(username=username)
		except:
			return Response(data='initiator not found', status=status.HTTP_400_BAD_REQUEST)
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


class ProfileDetail(generics.RetrieveUpdateDestroyAPIView):
	queryset = Profile.objects.all()
	serializer_class = ProfileSerializer


class MatchList(generics.ListCreateAPIView):
	queryset = Profile.objects.all()
	serializer_class = ProfileSerializer

	def list(self, request):
		t = datetime.now() - timedelta(hours=6) # fuck you google
		Match.objects.filter(time_1__lte=t).update(status_code=0, time_1=None, time_2=None, time_3=None)
		username = request.user.get_username()
		try:
			initiator = Profile.objects.get(username=username)
		except:
			return Response(data='initiator not found', status=status.HTTP_400_BAD_REQUEST)
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

		try:
			initiator = Profile.objects.get(username=i_username)
		except:
			return Response(data='initiator not found', status=status.HTTP_400_BAD_REQUEST)

		if a_username:
			try:
				acceptor = Profile.objects.get(username=a_username)
			except:
				return Response(data='acceptor not found', status=status.HTTP_400_BAD_REQUEST)
			c1 = Q(user_id1=acceptor.id)
			c2 = Q(user_id2=initiator.id)
			c3 = Q(user_id1=acceptor.id)
			c4 = Q(user_id2=initiator.id)
			matches = Match.objects.filter((c1 & c2) | (c3 & c4))
			if len(matches) > 0: # prevent re-match
				return Response(data='users are already matched', status=status.HTTP_400_BAD_REQUEST)
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
				return Response(data='no eligible users remaining', status=status.HTTP_400_BAD_REQUEST)

		m = Match(user_id1=initiator, user_id2=acceptor)
		try:
			m.save()
		except:
			return Response(data='could not create match', status=status.HTTP_400_BAD_REQUEST)
		serializer = ProfileSerializer(acceptor)
		return Response(serializer.data, status=status.HTTP_201_CREATED)


class MatchDetail(generics.RetrieveUpdateDestroyAPIView):
	queryset = Match.objects.all()
	serializer_class = MatchSerializer
	(INITIAL, OFFER_1, OFFER_2, CREATED) = (0, 1, 2, 3)

	def check(self, username, pk):
		try:
			user = Profile.objects.get(username=username)
		except:
			return (None, None, 'user not found', status.HTTP_400_BAD_REQUEST)
		try:
			match = Match.objects.get(match_id=pk)
		except:
			return (None, None, 'match not found', status.HTTP_404_NOT_FOUND)
		if match.user_id1 != user and match.user_id2 != user:
			return (None, None, 'not a member of this match', status.HTTP_403_FORBIDDEN)
		return (user, match, None, None)

	def retrieve(self, request, pk):
		t = datetime.now() - timedelta(hours=6) # fuck you google
		Match.objects.filter(time_1__lte=t).update(status_code=0, time_1=None, time_2=None, time_3=None)
		username = request.user.get_username()
		(user, match, msg, code) = self.check(username, pk)
		if match is None:
			return Response(data=msg, status=code)
		serializer = MatchSerializer(match)
		return Response(data=serializer.data, status=status.HTTP_200_OK)

	def update(self, request, pk):
		data = json.loads(request.body)
		username = data.get('username')
		(user, match, msg, code) = self.check(username, pk)
		if match is None:
			return Response(data=msg, status=code)
		old_status = match.status_code
		
		new_status = int(data.get('new_status'))
		if new_status is None or new_status not in range(4):
			return Response(data='new status missing or invalid', status=status.HTTP_400_BAD_REQUEST)
		
		times = []
		for t in [data.get('time_1'), data.get('time_2'), data.get('time_3')]:
			if t is None:
				times.append(None)
			else:
				try:
					times.append(datetime.strptime(t, '%Y %m %d %H %M'))
				except:
					return Response(data='time formatted incorrectly', status=status.HTTP_400_BAD_REQUEST)
		
		if new_status == old_status:
			return Response(data='same status provided; no change', status=status.HTTP_400_BAD_REQUEST)
		if ((old_status == self.INITIAL and new_status == self.CREATED) or
			(old_status == self.OFFER_1 and user == match.user_id1) or
			(old_status == self.OFFER_2 and user == match.user_id2) or
			(new_status == self.OFFER_1 and user == match.user_id2) or
			(new_status == self.OFFER_2 and user == match.user_id1)):
			return Response(data='invalid state transition', status=status.HTTP_400_BAD_REQUEST)
		if new_status in (self.OFFER_1, self.OFFER_2) and None in times:
			return Response(data='fewer than three times provided', status=status.HTTP_400_BAD_REQUEST)
		if (new_status == self.CREATED and ((times[0] == None) or 
				(times[0] not in (match.time_1, match.time_2, match.time_3)))):
			return Response(data='none or inconsistent time provided', status=status.HTTP_400_BAD_REQUEST)

		if   new_status == self.INITIAL:
			(sc, t1, t2, t3) = (new_status, None, None, None)
		elif new_status == self.CREATED:
			(sc, t1, t2, t3) = (new_status, times[0], None, None)
		else:
			(sc, t1, t2, t3) = (new_status, times[0], times[1], times[2])
		
		try:
			match.status_code=sc
			match.time_1=t1
			match.time_2=t2
			match.time_3=t3
			match.save()
		except IntegrityError as e:
			print e.message
			return Response(data='update failed', status=status.HTTP_400_BAD_REQUEST)

		match.refresh_from_db()
		serializer = MatchSerializer(match)
		return Response(serializer.data, status=status.HTTP_200_OK)

	def destroy(request, pk):
		data = json.loads(request.body)
		username = data.get('username')
		(user, match, msg, code) = self.check(username, pk)
		if match is None:
			return Response(data=msg, status=code)
		try:
			match.delete()
		except:
			return Response(data='deletion failed', status=status.HTTP_400_BAD_REQUEST)
		return Response(status=status.HTTP_200_OK)


@authentication_classes([])
@permission_classes([])
class Register(generics.CreateAPIView):
	queryset = Profile.objects.all()
	serializer_class = RegistrationSerializer

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


class Logout(generics.CreateAPIView):
	queryset = Profile.objects.all()
	serializer_class = ProfileSerializer

	def create(self, request):
		logout(request)
		return Response(status=status.HTTP_204_NO_CONTENT)

