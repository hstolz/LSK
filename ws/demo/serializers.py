from rest_framework import serializers
from demo.models import Profile, Match, LANGUAGE_CHOICES

class ProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = Profile
        fields = ('username', 'first_name', 'last_name', 'known_lang', 'learn_lang')
        # fields = ('username', 'password', 'first_name', 'last_name', 'email', 'known_lang', 'learn_lang')

# class ProfileSerializer(serializers.ModelSerializer):
#     class Meta:
#         model = Profile
#         fields = ('user_id', 'user_name', 'first_name', 'last_name', 'known_lang', 'learn_lang')

class MatchSerializer(serializers.ModelSerializer):
    class Meta:
        model = Match
        fields = ('match_id', 'user_id1', 'user_id2', 'time_1', 'time_2', 'time_3', 'status_code')