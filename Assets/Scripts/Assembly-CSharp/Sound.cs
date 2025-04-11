using System;
using UnityEngine;

[Serializable]
public class Sound
{
	public string name;

	public AudioClip clip;

	[Range(0f, 1f)]
	public float volume = 1f;

	[Range(0.1f, 3f)]
	public float pitch = 1f;

	public bool loop;

	[Range(0f, 1f)]
	public float randomVolume;

	[Range(0f, 1f)]
	public float randomPitch;

	[HideInInspector]
	public AudioSource source;
}
