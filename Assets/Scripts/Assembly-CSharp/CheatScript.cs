using UnityEngine;

public class CheatScript : MonoBehaviour
{
	private Rigidbody2D rb;

	[SerializeField]
	private float flySpeed = 10f;

	[SerializeField]
	private Rigidbody2D legR;

	[SerializeField]
	private Rigidbody2D legL;

	private bool hover;

	private Vector2 fly;

	private void Start()
	{
		rb = GetComponent<Rigidbody2D>();
	}

	private void Update()
	{
		fly = Vector2.zero;
		if (Input.GetKey(KeyCode.LeftControl))
		{
			if (Input.GetKey(KeyCode.W))
			{
				fly += Vector2.up;
			}
			if (Input.GetKey(KeyCode.S))
			{
				fly += Vector2.down;
			}
			if (Input.GetKey(KeyCode.A))
			{
				fly += Vector2.left * 0.5f;
			}
			if (Input.GetKey(KeyCode.D))
			{
				fly += Vector2.right * 0.5f;
			}
			if (Input.GetKey(KeyCode.Space))
			{
				hover = true;
			}
			if (Input.GetKey(KeyCode.Q))
			{
				rb.AddTorque(20000f * Time.deltaTime);
			}
			if (Input.GetKey(KeyCode.E))
			{
				rb.AddTorque(-20000f * Time.deltaTime);
			}
		}
		if (Input.GetKeyUp(KeyCode.LeftControl))
		{
			hover = false;
		}
		if (Input.GetKey(KeyCode.P))
		{
			if (Time.timeScale == 0f)
			{
				Time.timeScale = 1f;
			}
			else
			{
				Time.timeScale = 0f;
			}
		}
		if (Input.GetKey(KeyCode.O))
		{
			if (Time.timeScale == 0.1f)
			{
				Time.timeScale = 1f;
			}
			else
			{
				Time.timeScale = 0.1f;
			}
		}
		if (Input.GetKey(KeyCode.Alpha1))
		{
			MovePlayer(new Vector2(2f, -6f));
		}
		if (Input.GetKey(KeyCode.Alpha2))
		{
			MovePlayer(new Vector2(4f, 31f));
		}
		if (Input.GetKey(KeyCode.Alpha3))
		{
			MovePlayer(new Vector2(-9f, 55f));
		}
		if (Input.GetKey(KeyCode.Alpha4))
		{
			MovePlayer(new Vector2(11f, 86f));
		}
		if (Input.GetKey(KeyCode.Alpha5))
		{
			MovePlayer(new Vector2(3f, 110f));
		}
		if (Input.GetKey(KeyCode.Alpha6))
		{
			MovePlayer(new Vector2(7f, 135f));
		}
		if (Input.GetKey(KeyCode.Alpha7))
		{
			MovePlayer(new Vector2(44f, 154f));
		}
		if (Input.GetKey(KeyCode.Alpha8))
		{
			MovePlayer(new Vector2(48f, 245f));
		}
		if (Input.GetKey(KeyCode.Alpha9))
		{
			MovePlayer(new Vector2(1.7f, -33f));
		}
		if (Input.GetKey(KeyCode.Alpha0))
		{
			Object.FindObjectOfType<PlayerSpawn>().Despawn();
		}
		static void MovePlayer(Vector2 p)
		{
			Object.FindObjectOfType<PlayerSpawn>().Respawn(p);
		}
	}

	private void FixedUpdate()
	{
		bool flag = false;
		if (fly.magnitude > 0f)
		{
			flag = true;
		}
		if (flag)
		{
			rb.AddForce((flySpeed * fly - rb.velocity) * 50f);
			rb.freezeRotation = true;
		}
		else
		{
			rb.freezeRotation = false;
		}
		if (hover)
		{
			rb.AddForce(-rb.velocity * 50f);
			rb.AddForce(new Vector2(0f, 300f));
			rb.freezeRotation = true;
		}
	}
}
