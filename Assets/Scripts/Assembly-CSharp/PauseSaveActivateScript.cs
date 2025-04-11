using UnityEngine;

public class PauseSaveActivateScript : MonoBehaviour
{
	[SerializeField]
	private bool activateSavePause = true;

	private void OnTriggerEnter2D(Collider2D collision)
	{
		if (collision.name == "Climber_Hero_Body_Prefab")
		{
			Object.FindObjectOfType<PauseMenu>().pauseAllowed = activateSavePause;
			collision.GetComponentInParent<ClimberMain>().saveAllowed = activateSavePause;
		}
	}
}
