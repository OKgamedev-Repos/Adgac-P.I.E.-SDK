using System;
using UnityEngine;

public class PlayerSoundManager : MonoBehaviour
{
	public Sound[] sounds;

	private ArmScript_v2 armScript;

	private Sound currentSlideSound;

	private float timeSinceSlide;

	private bool playRandomSlideSound;

	private float timeSinceSolidHit;

	private float randomSlideDelay = 0.1f;

	private PlayerSoundManager otherPlayerSoundManager;

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
		}
	}

	private void Start()
	{
		armScript = GetComponent<ArmScript_v2>();
		otherPlayerSoundManager = armScript.otherArm.GetComponent<PlayerSoundManager>();
	}

	public Sound PlaySound(string name, bool randomDelayed = false, float volume = 1f, float pitch = 0f)
	{
		Sound sound = Array.Find(sounds, (Sound x) => x.name == name);
		if (sound == null)
		{
			return null;
		}
		sound.source.volume = (UnityEngine.Random.Range(0f - sound.randomVolume, sound.randomVolume) + 1f) * sound.volume;
		sound.source.pitch = (UnityEngine.Random.Range(0f - sound.randomPitch, sound.randomPitch) + 1f) * sound.pitch;
		sound.source.volume *= volume;
		sound.source.pitch += pitch;
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

	public void PlayGrabSound(bool playerInvoked)
	{
		if (!(armScript.grabbedSurface != null))
		{
			return;
		}
		if (armScript.grabbedSurface.surfaceType == ClimbingSurface.SurfaceType.Rock)
		{
			PlaySound("GrabRock");
		}
		else if (armScript.grabbedSurface.surfaceType == ClimbingSurface.SurfaceType.Wood)
		{
			int num = UnityEngine.Random.Range(1, 4);
			if (UnityEngine.Random.value > 0.5f)
			{
				num = 1;
			}
			PlaySound("GrabWood" + num);
		}
		else if (armScript.grabbedSurface.surfaceType == ClimbingSurface.SurfaceType.Ice)
		{
			PlaySound("GrabIce");
		}
		else if (armScript.grabbedSurface.surfaceType == ClimbingSurface.SurfaceType.Plank)
		{
			PlaySound("GrabPlank1");
		}
		else if (armScript.grabbedSurface.surfaceType == ClimbingSurface.SurfaceType.Foliage)
		{
			PlaySound("FoliageGrab" + UnityEngine.Random.Range(1, 3));
		}
		else if (armScript.grabbedSurface.surfaceType == ClimbingSurface.SurfaceType.Metal)
		{
			if (!playerInvoked)
			{
				if (!Array.Find(sounds, (Sound x) => x.name == "GrabMetal3").source.isPlaying)
				{
					PlaySound("GrabMetal3");
				}
			}
			else
			{
				PlaySound("GrabMetal2");
			}
		}
		else if (armScript.grabbedSurface.surfaceType == ClimbingSurface.SurfaceType.MetalStiff)
		{
			PlaySound("GrabMetalStiff" + 1);
		}
		else if (armScript.grabbedSurface.surfaceType == ClimbingSurface.SurfaceType.Cloth)
		{
			PlaySound("GrabCloth" + UnityEngine.Random.Range(1, 3));
		}
		else if (armScript.grabbedSurface.surfaceType == ClimbingSurface.SurfaceType.Mushroom)
		{
			PlaySound("GrabMushroom" + UnityEngine.Random.Range(1, 3));
		}
		else if (armScript.grabbedSurface.surfaceType == ClimbingSurface.SurfaceType.Bone)
		{
			float pitch = (float)(armScript.grabbedSurface.priority - 7) * 0.1f;
			PlaySound("GrabBone", randomDelayed: false, 1f, pitch);
		}
		else if (armScript.grabbedSurface.surfaceType == ClimbingSurface.SurfaceType.Cloud)
		{
			PlaySound("GrabCloud");
		}
		else
		{
			PlaySound("GrabRock");
		}
		if (armScript.grabbedSurface.isPickup)
		{
			PlaySound("GrabPickup");
		}
	}

	public void PlayReleaseSurfaceSound(bool playerInvoked)
	{
		if (armScript.grabbedSurface != null && armScript.grabbedSurface.surfaceType == ClimbingSurface.SurfaceType.Foliage)
		{
			PlaySound("FoliageGrab" + UnityEngine.Random.Range(1, 3));
		}
		if (!playerInvoked && armScript.grabbedSurface != null)
		{
			if (armScript.grabbedSurface.surfaceType == ClimbingSurface.SurfaceType.Rock)
			{
				PlaySound("SlipOffRock");
			}
			else
			{
				PlaySound("SlipOffRock");
			}
		}
	}

	public void PlaySlideSound()
	{
		timeSinceSlide = Time.time;
		playRandomSlideSound = true;
		if (armScript.grabbedSurface.surfaceType == ClimbingSurface.SurfaceType.Rock)
		{
			currentSlideSound = PlaySound("SlideRock", randomDelayed: true);
			currentSlideSound.source.volume = 0f;
			randomSlideDelay = UnityEngine.Random.Range(0.1f, 0.4f);
		}
		else if (armScript.grabbedSurface.surfaceType == ClimbingSurface.SurfaceType.Wet)
		{
			currentSlideSound = PlaySound("SlideWet", randomDelayed: true);
			currentSlideSound.source.volume = 0f;
		}
		else if (armScript.grabbedSurface.surfaceType == ClimbingSurface.SurfaceType.Metal)
		{
			currentSlideSound = PlaySound("SlideMetal1", randomDelayed: true);
			currentSlideSound.source.volume = 0f;
			randomSlideDelay = 0.3f;
		}
		else if (armScript.grabbedSurface.surfaceType == ClimbingSurface.SurfaceType.Concrete)
		{
			currentSlideSound = PlaySound("SlideConcrete", randomDelayed: true);
			currentSlideSound.source.volume = 0f;
		}
		else if (armScript.grabbedSurface.surfaceType == ClimbingSurface.SurfaceType.Cloth)
		{
			currentSlideSound = PlaySound("SlideCloth", randomDelayed: true);
			currentSlideSound.source.volume = 0f;
		}
		else if (armScript.grabbedSurface.surfaceType == ClimbingSurface.SurfaceType.Ice)
		{
			currentSlideSound = PlaySound("SlideIce", randomDelayed: true);
			currentSlideSound.source.volume = 0f;
		}
		else if (armScript.grabbedSurface.surfaceType == ClimbingSurface.SurfaceType.Wood)
		{
			currentSlideSound = PlaySound("SlideWood", randomDelayed: true);
			currentSlideSound.source.volume = 0f;
		}
		if (currentSlideSound != null && currentSlideSound.source != null && otherPlayerSoundManager.currentSlideSound != null && otherPlayerSoundManager.currentSlideSound.source.time < 0.2f)
		{
			currentSlideSound.source.time = 0.5f;
		}
	}

	public void StopSlideSound()
	{
		if (currentSlideSound != null)
		{
			StopSound(currentSlideSound.name);
		}
		currentSlideSound = null;
	}

	public void PlayVoiceChargeSound()
	{
		PlaySound("VoiceCharge" + UnityEngine.Random.Range(1, 13));
	}

	public void PlayVoiceGrabSound()
	{
		PlaySound("VoiceGrab" + UnityEngine.Random.Range(1, 5));
	}

	public void PlayVoiceUpsetSound()
	{
		PlaySound("VoiceUpset" + UnityEngine.Random.Range(1, 14));
	}

	public void PlayVoiceFallSound()
	{
		PlaySound("VoiceFall" + UnityEngine.Random.Range(1, 3));
	}

	public void PlayVoiceBigFallSound()
	{
		PlaySound("VoiceBigFall1");
	}

	public void StopVoiceBigFallSound()
	{
		StopSound("VoiceBigFall1");
	}

	private void PlayRandomSlideSound()
	{
		if (armScript.grabbedSurface.surfaceType == ClimbingSurface.SurfaceType.Rock)
		{
			PlaySound("RockDebrisFall", randomDelayed: true);
		}
		else if (armScript.grabbedSurface.surfaceType == ClimbingSurface.SurfaceType.Metal)
		{
			PlaySound("GrabMetal3", randomDelayed: true);
		}
		playRandomSlideSound = false;
	}

	private void FixedUpdate()
	{
		if (currentSlideSound != null && currentSlideSound.source != null)
		{
			currentSlideSound.source.pitch = Mathf.Lerp(armScript.hand.velocity.magnitude / 10f, 1f, 0.75f);
			currentSlideSound.source.volume = currentSlideSound.volume * Mathf.Clamp01(armScript.hand.velocity.magnitude / 5f) * currentSlideSound.volume;
			if (Time.time - timeSinceSlide > randomSlideDelay && playRandomSlideSound)
			{
				PlayRandomSlideSound();
			}
		}
	}

	public void PlayHandHitSound()
	{
		if (Time.time - timeSinceSolidHit > 0.2f)
		{
			PlaySound("HandHit" + UnityEngine.Random.Range(1, 3), randomDelayed: false, Mathf.Clamp(armScript.hand.velocity.sqrMagnitude / 5f, 0.4f, 1f));
			_ = armScript.hand.velocity.sqrMagnitude;
			_ = 1f;
			timeSinceSolidHit = Time.time;
		}
	}
}
