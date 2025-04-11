using System.Collections;
using UnityEngine;

public class ClearGameScript : MonoBehaviour
{
	[SerializeField]

	private void OnTriggerEnter2D(Collider2D collision)
	{
		if (collision.tag == "Player")
		{
			SaveSystemJ.ClearGame();
			StartCoroutine(ResetTimers());
		}
		else
		{
			Debug.Log("Missing ConfettiHandleScript! Can't respawn lid!");
		}
		static IEnumerator ResetTimers()
		{
			yield return new WaitForSeconds(3.5f);
			SaveSystemJ.timeFromSave = 0f;
			SaveSystemJ.startTime = Time.time;
			SaveSystemJ.timeValid = true;
		}
	}
}
