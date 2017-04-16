from demo.models import Profile, Match
from demo.serializers import ProfileSerializer, MatchSerializer
from rest_framework import generics, status
from rest_framework.response import Response


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
		user_id = request.data['user_id']
		learn_lang = request.data['learn_lang']
		initiator = Profile.objects.get(user_id=user_id)
		match = Profile.objects.filter(known_lang__exact=learn_lang).order_by('?')
		if len(match) > 0:
			acceptor = match[0]
			m = Match(match_id=0, user_id1=initiator, user_id2=acceptor)
			try:
				m.save()
				return Response(status=status.HTTP_201_CREATED)
			except:
				return Response(status=status.HTTP_400_BAD_REQUEST)
		return Response(status=status.HTTP_400_BAD_REQUEST)

class MatchDetail(generics.RetrieveUpdateDestroyAPIView):
	queryset = Match.objects.all()
	serializer_class = MatchSerializer
