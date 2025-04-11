using System;
using UnityEngine;

public class PlayerBodySoundManager : MonoBehaviour
{
	public Sound[] sounds;

	private Sound currentSlideSound;

	private Rigidbody2D body;

	private bool playRandomSlideSound;

	private float timeSinceSlide;

	private int collidersTouching;

	private float timeSinceHit;

	private void Awake()
	{
		Sound[] array = sounds;
		foreach (Sound sound in array)
		{
			sound.source = base.gameObject.AddComponent<AudioSource>();
			sound.source.clip = sound.clip;
			sound.source.volume = sound.volume;
			sound.source.pitch = sound.pitch;
			sound.source.loop = sound.loop;
			sound.source.playOnAwake = false;
		}
	}

	private void Start()
	{
		body = GetComponent<Rigidbody2D>();
	}

	public Sound PlaySound(string name, bool randomDelayed = false)
	{
		Sound sound = Array.Find(sounds, (Sound x) => x.name == name);
		if (sound == null)
		{
			return null;
		}
		sound.source.volume = (UnityEngine.Random.Range(0f - sound.randomVolume, sound.randomVolume) + 1f) * sound.volume;
		sound.source.pitch = (UnityEngine.Random.Range(0f - sound.randomPitch, sound.randomPitch) + 1f) * sound.pitch;
		if (randomDelayed)
		{
			float length = sound.source.clip.length;
			sound.source.PlayScheduled(UnityEngine.Random.Range(0f, length));
			return sound;
		}
		sound.source.Play();
		return sound;
	}

	public void StopSound(string name)
	{
		Array.Find(sounds, (Sound x) => x.name == name)?.source.Stop();
	}

	public void PlaySlideSound()
	{
		timeSinceSlide = Time.time;
		playRandomSlideSound = true;
		currentSlideSound = PlaySound("BodySlide", randomDelayed: true);
		currentSlideSound.source.volume = 0f;
	}

	public void StopSlideSound()
	{
		if (currentSlideSound != null)
		{
			StopSound(currentSlideSound.name);
		}
		currentSlideSound = null;
	}

	private void PlayRandomSlideSound()
	{
		PlaySound("RockDebrisFall", randomDelayed: true);
		playRandomSlideSound = false;
	}

	private void FixedUpdate()
	{
		if (currentSlideSound != null && currentSlideSound.source != null)
		{
			currentSlideSound.source.pitch = Mathf.Lerp(body.velocity.magnitude / 10f, 1f, 0.75f);
			currentSlideSound.source.volume = Mathf.Clamp01(body.velocity.magnitude / 5f) * currentSlideSound.volume;
			if (Time.time - timeSinceSlide > 0.1f && playRandomSlideSound)
			{
				PlayRandomSlideSound();
			}
		}
	}

	private void OnCollisionEnter2D(Collision2D collision)
	{
		if (Time.time - timeSinceHit > 0.5f)
		{
			if (body.velocity.sqrMagnitude > 75f)
			{
				PlaySound("BodyHit" + UnityEngine.Random.Range(1, 3));
				PlaySound("VoiceHit" + UnityEngine.Random.Range(1, 3));
			}
			else if (body.velocity.sqrMagnitude > 25f)
			{
				PlaySound("BodyHitMedium" + UnityEngine.Random.Range(1, 3));
			}
			else if (body.velocity.sqrMagnitude > 1f)
			{
				PlaySound("BodyHitLight" + UnityEngine.Random.Range(1, 3));
			}
			timeSinceHit = Time.time;
		}
		PlaySlideSound();
		collidersTouching++;
	}

	private void OnCollisionExit2D(Collision2D collision)
	{
		collidersTouching--;
		if (collidersTouching == 0)
		{
			StopSlideSound();
		}
	}

	private void OnTriggerExit2D(Collider2D collision)
	{
		if (collision.tag == "Water")
		{
			PlaySound("ExitWater");
		}
	}
}
