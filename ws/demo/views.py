from demo.models import Profile, Match
from demo.serializers import ProfileSerializer, MatchSerializer
from rest_framework import generics, status
from rest_framework.response import Response

from django.http import HttpResponse, JsonResponse
from django.views.decorators.csrf import csrf_exempt
from rest_framework.renderers import JSONRenderer
from rest_framework.parsers import JSONParser
from demo.models import Profile
from demo.serializers import ProfileSerializer

# class ProfileList(generics.ListCreateAPIView):
#     queryset = Profile.objects.all()
#     serializer_class = ProfileSerializer

# class ProfileDetail(generics.RetrieveUpdateDestroyAPIView):
#     queryset = Profile.objects.all()
#     serializer_class = ProfileSerializer

class MatchList(generics.ListCreateAPIView):
	queryset = Match.objects.all()
	serializer_class = MatchSerializer

	def create(self, request):
		print str(request.data)
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

@csrf_exempt
def profile_list(request):
	if request.method == 'GET':
		profile = Profile.objects.all()
		serializer = ProfileSerializer(profile, many=True)
		return JsonResponse(serializer.data, safe=False)

	elif request.method == 'POST':
		data = JSONParser().parse(request)
		serializer = ProfileSerializer(data=data)
		if serializer.is_valid():
			serializer.save()
			return JsonResponse(serializer.data, status=201)
		return JsonResponse(serializer.errors, status=400)

@csrf_exempt
def profile_detail(request, pk):
	try:
		profile = Profile.objects.get(pk=pk)
	except Profile.DoesNotExist:
		return HttpResponse(status=404)

	if request.method == 'GET':
		serializer = ProfileSerializer(profile)
		return JsonResponse(serializer.data)

	elif request.method == 'PUT':
		data = JSONParser().parse(request)
		serializer = ProfileSerializer(profile, data=data)
		if serializer.is_valid():
			serializer.save()
			return JsonResponse(serializer.data)
		return JsonResponse(serializer.errors, status=400)

	elif request.method == 'DELETE':
		profile.delete()
		return HttpResponse(status=204)