# -*- coding: utf-8 -*-
# from __future__ import unicode_literals

# from django.shortcuts import render

# Create your views here.
from django.http import HttpResponse, JsonResponse
from django.views.decorators.csrf import csrf_exempt
from rest_framework.renderers import JSONRenderer
from rest_framework.parsers import JSONParser
from demo.models import Profile
from demo.serializers import ProfileSerializer

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