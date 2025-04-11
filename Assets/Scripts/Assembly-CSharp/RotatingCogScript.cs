using UnityEngine;

public class RotatingCogScript : MonoBehaviour
{
	[SerializeField]
	private float speed = 1f;

	[SerializeField]
	private bool clockwise = true;

	private Rigidbody2D rb;

	private void Start()
	{
		rb = GetComponent<Rigidbody2D>();
	}

	private void FixedUpdate()
	{
		if (clockwise)
		{
			rb.MoveRotation(rb.rotation - speed * Time.deltaTime);
		}
		else
		{
			rb.MoveRotation(rb.rotation + speed * Time.deltaTime);
		}
	}
}
