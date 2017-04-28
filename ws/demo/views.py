from demo.models import Profile, Match
from demo.serializers import ProfileSerializer, MatchSerializer
from rest_framework import generics, status
from rest_framework.response import Response
import json

class ProfileList(generics.ListCreateAPIView):
    queryset = Profile.objects.all()
    serializer_class = ProfileSerializer

class ProfileDetail(generics.RetrieveUpdateDestroyAPIView):
    queryset = Profile.objects.all()
    serializer_class = ProfileSerializer

class MatchList(generics.ListCreateAPIView):
	queryset = Match.objects.all()
	serializer_class = MatchSerializer

	def create(self, request):
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
