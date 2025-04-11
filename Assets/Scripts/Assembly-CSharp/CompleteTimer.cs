using UnityEngine;

public class CompleteTimer : MonoBehaviour
{
	private void OnTriggerEnter2D(Collider2D collision)
	{
		if (collision.name == "Climber_Hero_Body_Prefab")
		{
			SaveSystemJ.SetCompleteTime();
		}
	}
}
