using System;
using UnityEngine;

public class SoundManager : MonoBehaviour
{
	public Sound[] sounds;

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

	public void PlaySound(string name, float volume = 1f)
	{
		Sound sound = Array.Find(sounds, (Sound x) => x.name == name);
		if (sound != null)
		{
			sound.source.volume = (UnityEngine.Random.Range(0f - sound.randomVolume, sound.randomVolume) + 1f) * sound.volume;
			sound.source.pitch = (UnityEngine.Random.Range(0f - sound.randomPitch, sound.randomPitch) + 1f) * sound.pitch;
			sound.source.volume *= volume;
			sound.source.Play();
		}
	}
}
