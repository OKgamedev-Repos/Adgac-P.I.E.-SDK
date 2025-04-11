using UnityEngine;

public class FreezeCameraYBox : MonoBehaviour
{
	[SerializeField]
	private bool freeze;

	[SerializeField]
	private bool superSmoothMode;

	[SerializeField]
	private bool stopSuperSmoothMode;

	private void OnTriggerEnter2D(Collider2D collision)
	{
		if (collision.tag == "Player")
		{
			if (freeze && collision.transform.position.y + 0.5f < base.transform.position.y)
			{
				Object.FindObjectOfType<CameraScript>().StopYMovement();
			}
			if (superSmoothMode)
			{
				Object.FindObjectOfType<CameraScript>().ActivateSuperSmooth();
			}
			if (stopSuperSmoothMode)
			{
				Object.FindObjectOfType<CameraScript>().DeactivateSuperSmooth();
			}
		}
	}

	private void OnTriggerExit2D(Collider2D collision)
	{
		if (collision.tag == "Player" && freeze)
		{
			if (collision.transform.position.y + 0.5f > base.transform.position.y)
			{
				Object.FindObjectOfType<CameraScript>().StartYMovement(up: true);
			}
			else
			{
				Object.FindObjectOfType<CameraScript>().StartYMovement(up: false);
			}
		}
	}
}
