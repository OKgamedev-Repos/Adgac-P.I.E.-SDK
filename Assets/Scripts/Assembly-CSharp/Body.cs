using UnityEngine;

public class Body : MonoBehaviour
{
	public Vector2 forceOnBody;

	public bool isInWater;

	public GameObject bodyModel;

	[SerializeField]
	private float maxVelocity = 25f;

	[SerializeField]
	private ClimberMain climberMain;

	[SerializeField]
	private ParticleSystem particlesExitWater;

	private Vector2 storedForceOnBody;

	private Rigidbody2D rb;

	private float inertia = 1.45f;

	private void Start()
	{
		rb = GetComponent<Rigidbody2D>();
		rb.centerOfMass = new Vector2(0f, 0.69f);
		rb.inertia = inertia;
	}

	private void OnTriggerEnter2D(Collider2D collision)
	{
		if (collision.tag == "Water")
		{
			isInWater = true;
			rb.inertia = 1.7f;
			rb.angularDrag = 5f;
			SaveSystemJ.SavePlayer(climberMain, checkpoint: true);
		}
	}

	private void OnTriggerExit2D(Collider2D collision)
	{
		if (collision.tag == "Water")
		{
			isInWater = false;
			rb.inertia = inertia;
			rb.angularDrag = 2f;
			Object.Instantiate(particlesExitWater, base.transform);
		}
	}

	private void OnCollisionEnter2D(Collision2D collision)
	{
	}

	public void ForceOnBody(Vector2 f)
	{
		storedForceOnBody += f;
	}

	private void FixedUpdate()
	{
		forceOnBody = storedForceOnBody;
		storedForceOnBody = Vector2.zero;
		if (rb.velocity.y < 0f && !isInWater)
		{
			if (climberMain.arm_Right.grabbedSurface == null && climberMain.arm_Left.grabbedSurface == null)
			{
				float gravityScale = Mathf.Clamp(rb.velocity.y / 5f * -1f, 0.5f, 0.75f);
				rb.gravityScale = gravityScale;
			}
			else
			{
				rb.gravityScale = 0.75f;
			}
		}
		else
		{
			rb.gravityScale = 1f;
		}
		if (rb.velocity.y * -1f > maxVelocity)
		{
			rb.AddForce(Vector2.up * (rb.velocity.y * -1f - maxVelocity), ForceMode2D.Impulse);
		}
	}
}
