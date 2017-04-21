from django.db import models
# need to do from django.conf import settings (settings.LANGUAGES)

LANGUAGE_CHOICES = (('en', 'English'), ('zh', 'Chinese'), ('es', 'Spanish')
					('ar', 'Arabic'), ('pt', 'Portuguese'), ('ru', 'Russian'),
					('fr', 'French'), ('ja', 'Japanese'), ('it', 'Italian'),
					('cs', 'Czech'), ('de', 'German'), ('he', 'Hebrew'), 
					('hi', 'Hindi'), ('ko', 'Korean'), ('el', 'Greek'), 
					('fa', 'Persian'), ('sw', 'Swahili'), ('tr', 'Turkish'),
					('tw', 'Twi'), ('ur', 'Urdu'), ('pl', 'Polish'))

class Profile(models.Model):
	user_id = models.AutoField(primary_key=True)
	user_name = models.CharField(max_length=100, default='')
	first_name = models.CharField(max_length=100, default='')
	last_name = models.CharField(max_length=100, default='')
	known_lang = models.CharField(max_length=100, choices=LANGUAGE_CHOICES, default='')
	learn_lang = models.CharField(max_length=100, choices=LANGUAGE_CHOICES, default='')

	class Meta:
		db_table = 'profiles'
		ordering = ('user_id',)


class Match(models.Model):
	match_id = models.AutoField(primary_key=True)
	user_id1 = models.ForeignKey(Profile, related_name='initiator', on_delete=models.CASCADE)
	user_id2 = models.ForeignKey(Profile, related_name='acceptor', on_delete=models.CASCADE)
	time_1 = models.DateTimeField(blank=True)
	time_2 = models.DateTimeField(blank=True)
	time_3 = models.DateTimeField(blank=True)
	status_code = models.IntegerField(default='0') 
	#Key for status codes
	#0 - match made, but no scheduling has occurred
	#1 - match made, but acceptor has not confirmed; initiator is ready
	#2 - match made, but acceptor not available and counteroffers; acceptor is ready(but initiator isn't anymore)
	#3 - match made, and both have agreed on schedule

	class Meta:
		db_table = 'matches'
		ordering = ('match_id',)
