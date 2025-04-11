using UnityEngine;

public class SoundYFaderScript : MonoBehaviour
{
	private AudioSource source;

	private BoxCollider2D boxCollider;

	private GameObject player;

	[SerializeField]
	private float fadeThreshold = 1f;

	[SerializeField]
	private float falloffExponent = 2f;

	private float fadeDistance = 1f;

	private float vol;

	private void Start()
	{
		source = GetComponent<AudioSource>();
		vol = source.volume;
		boxCollider = GetComponent<BoxCollider2D>();
		fadeDistance = boxCollider.size.y / 2f - fadeThreshold;
	}

	private void Update()
	{
		if (player != null && source != null)
		{
			source.volume = vol * Mathf.Clamp01(Mathf.Pow(1f - (Mathf.Abs(player.transform.position.y - base.transform.position.y) - fadeThreshold) / fadeDistance, falloffExponent));
		}
	}

	private void OnTriggerEnter2D(Collider2D collision)
	{
		if (collision.gameObject.tag == "Player")
		{
			base.enabled = true;
			player = collision.gameObject;
			source.enabled = true;
		}
	}

	private void OnTriggerExit2D(Collider2D collision)
	{
		if (collision.gameObject.tag == "Player")
		{
			base.enabled = false;
			source.enabled = false;
		}
	}
}
