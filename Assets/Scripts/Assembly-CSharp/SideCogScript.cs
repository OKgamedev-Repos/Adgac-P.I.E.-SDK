using UnityEngine;

public class SideCogScript : MonoBehaviour
{
	[SerializeField]
	private GameObject cog;

	[SerializeField]
	private Rigidbody2D box1;

	[SerializeField]
	private Rigidbody2D box2;

	private BoxCollider2D boxCollider1;

	[SerializeField]
	private float speed = 1f;

	[SerializeField]
	private float cogSpeed = 1f;

	[SerializeField]
	private bool left;

	private Vector2 boxInitT;

	private float dir = 1f;

	private void Start()
	{
		boxCollider1 = box1.GetComponent<BoxCollider2D>();
		boxInitT = box1.transform.position;
		box1.transform.position = boxInitT + Vector2.left * (boxCollider1.size.x * base.transform.localScale.x) / 2f;
		box2.transform.position = boxInitT + Vector2.right * (boxCollider1.size.x * base.transform.localScale.x) / 2f;
		if (left)
		{
			dir = -1f;
		}
	}

	private void FixedUpdate()
	{
		Vector2 move = new Vector2(Time.fixedDeltaTime * speed * dir, 0f);
		MoveBox(box1, move);
		MoveBox(box2, move);
		cog.transform.localEulerAngles = cog.transform.localEulerAngles + new Vector3(0f, cogSpeed * Time.fixedDeltaTime * (0f - dir), 0f);
	}

	private void MoveBox(Rigidbody2D box, Vector2 move)
	{
		float num = 0.01f;
		if (box.position.x - boxInitT.x > boxCollider1.size.x * base.transform.localScale.x + num)
		{
			box.position = boxInitT + Vector2.left * boxCollider1.size.x * base.transform.localScale.x;
		}
		else if (box.position.x - boxInitT.x < (0f - boxCollider1.size.x) * base.transform.localScale.x - num)
		{
			box.position = boxInitT + Vector2.right * boxCollider1.size.x * base.transform.localScale.x;
		}
		else
		{
			box.MovePosition(box.position + move);
		}
	}
}
