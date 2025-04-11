using UnityEngine;

public class handScript : MonoBehaviour
{
	[SerializeField]
	private ArmScript_v2 armScript;

	private PlayerSoundManager soundManager;

	private void Start()
	{
		soundManager = armScript.GetComponent<PlayerSoundManager>();
	}

	private void OnTriggerEnter2D(Collider2D collision)
	{
		if ((bool)collision.GetComponent<ClimbingSurface>())
		{
			armScript.AddFrictionSurface(collision.GetComponent<ClimbingSurface>());
		}
	}

	private void OnTriggerExit2D(Collider2D collision)
	{
		if ((bool)collision.GetComponent<ClimbingSurface>())
		{
			armScript.RemoveFrictionSurface(collision.GetComponent<ClimbingSurface>());
		}
	}

	private void OnCollisionEnter2D(Collision2D collision)
	{
		armScript.AddCollisionSurface();
		if (soundManager != null)
		{
			soundManager.PlayHandHitSound();
		}
	}

	private void OnCollisionExit2D(Collision2D collision)
	{
		armScript.RemoveCollisionSurface();
	}
}
