from django.db import models
# need to do from django.conf import settings (settings.LANGUAGES)

LANGUAGE_CHOICES = (('eng', 'English'), ('chi', 'Mandarin'), ('spa', 'Spanish'))


class Profile(models.Model):
	user_id = models.AutoField(primary_key=True)
	# user_id = models.IntegerField(primary_key=True)
	user_name = models.CharField(max_length=100, default='')
	first_name = models.CharField(max_length=100, default='')
	last_name = models.CharField(max_length=100, default='')
	pref_time = models.DateTimeField()
	known_lang = models.CharField(max_length=100, choices=LANGUAGE_CHOICES, default='')
	learn_lang = models.CharField(max_length=100, choices=LANGUAGE_CHOICES, default='')

	class Meta:
		db_table = 'profiles'
		ordering = ('user_id',)


class Match(models.Model):
	match_id = models.AutoField(primary_key=True)
	# match_id = models.IntegerField(primary_key=True)
	user_id1 = models.ForeignKey(Profile, related_name='initiator', on_delete=models.CASCADE)
	user_id2 = models.ForeignKey(Profile, related_name='acceptor', on_delete=models.CASCADE)

	class Meta:
		db_table = 'matches'
		ordering = ('match_id',)
