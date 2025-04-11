using UnityEngine;

public class EndTeleporterScript : MonoBehaviour
{
	[SerializeField]
	private FadeToWhiteScript fadeToWhite;

	private void OnTriggerEnter2D(Collider2D collision)
	{
		if (collision != null && collision.tag == "Player")
		{
			fadeToWhite.FadeFromWhite(0.33f);
			Object.FindObjectOfType<PlayerSpawn>().Respawn(new Vector2(1.7f, -33f));
		}
	}
}
