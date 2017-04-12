from rest_framework import serializers
from demo.models import Profile, Match, LANGUAGE_CHOICES

class ProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = Profile
        fields = ('user_id', 'user_name', 'first_name', 'last_name', 'pref_time', 'known_lang', 'learn_lang')


class MatchSerializer(serializers.HyperlinkedModelSerializer):
    class Meta:
        model = Match
        fields = ('match_id', 'user_id1', 'user_id2')