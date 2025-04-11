using UnityEngine;

public class WaterDetector : MonoBehaviour
{
	private void OnTriggerEnter2D(Collider2D Hit)
	{
		if (Hit.GetComponent<Rigidbody2D>() != null)
		{
			base.transform.parent.GetComponent<Water>().Splash(Hit.transform.position.x, Hit.GetComponent<Rigidbody2D>().velocity.y * Hit.GetComponent<Rigidbody2D>().mass / 40f);
		}
	}
}
