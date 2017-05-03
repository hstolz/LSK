from django.db import models
from django.contrib.auth.models import AbstractUser
from django.conf import settings
from django.db.models.signals import post_save
from django.dispatch import receiver
from rest_framework.authtoken.models import Token 


LANGUAGE_CHOICES = (('en', 'English'), ('zh', 'Chinese'), ('es', 'Spanish'),
					('ar', 'Arabic'), ('pt', 'Portuguese'), ('ru', 'Russian'),
					('fr', 'French'), ('ja', 'Japanese'), ('it', 'Italian'),
					('cs', 'Czech'), ('de', 'German'), ('he', 'Hebrew'), 
					('hi', 'Hindi'), ('ko', 'Korean'), ('el', 'Greek'), 
					('fa', 'Persian'), ('sw', 'Swahili'), ('tr', 'Turkish'),
					('tw', 'Twi'), ('ur', 'Urdu'), ('pl', 'Polish'))


@receiver(post_save, sender=settings.AUTH_USER_MODEL)
def create_auth_token(sender, instance=None, created=False, **kwargs):
    if created:
        Token.objects.create(user=instance)


class Profile(AbstractUser):
	known_lang = models.CharField(max_length=100, choices=LANGUAGE_CHOICES, default='')
	learn_lang = models.CharField(max_length=100, choices=LANGUAGE_CHOICES, default='')

	class Meta:
		db_table = 'profiles'
		ordering = ('username',)


class Match(models.Model):
	match_id = models.AutoField(primary_key=True)
	user_id1 = models.ForeignKey(settings.AUTH_USER_MODEL, related_name='initiator', on_delete=models.CASCADE)
	user_id2 = models.ForeignKey(settings.AUTH_USER_MODEL, related_name='acceptor', on_delete=models.CASCADE)
	time_1 = models.DateTimeField(null=True)
	time_2 = models.DateTimeField(null=True)
	time_3 = models.DateTimeField(null=True)
	status_code = models.IntegerField(default='0') 
	#Key for status codes
	#0 - match made, but no scheduling has occurred
	#1 - match made, but acceptor has not confirmed; initiator is ready
	#2 - match made, but acceptor not available and counteroffers; acceptor is ready(but initiator isn't anymore)
	#3 - match made, and both have agreed on schedule

	class Meta:
		db_table = 'matches'
		ordering = ('match_id',)
