using UnityEngine;

public class LegScript : MonoBehaviour
{
	private Rigidbody2D rb;

	private Vector2 offset;

	[SerializeField]
	private Transform parent;

	private void Start()
	{
		rb = GetComponent<Rigidbody2D>();
		offset = (Vector2)base.transform.position - (Vector2)parent.position;
	}

	private void FixedUpdate()
	{
		Vector2 force = ((Vector2)parent.position + offset - rb.position) * 30f;
		force *= force.magnitude;
		force -= rb.velocity * 5f;
		rb.AddForce(force);
	}
}
