using UnityEngine;

public class PlaySoundTriggerScript : MonoBehaviour
{
	private AudioSource audioSource;

	private void OnTriggerEnter2D(Collider2D collision)
	{
		if (collision.name == "Climber_Hero_Body_Prefab")
		{
			if (audioSource == null)
			{
				audioSource = GetComponent<AudioSource>();
			}
			if (!audioSource.isPlaying)
			{
				audioSource.Play();
			}
		}
	}
}
