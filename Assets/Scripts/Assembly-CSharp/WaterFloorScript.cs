using UnityEngine;

public class WaterFloorScript : MonoBehaviour
{
	private Rigidbody2D body;

	private BoxCollider2D boxCollider;

	[SerializeField]
	private ParticleSystem waterBubbles01;

	[SerializeField]
	private ParticleSystem bubblesFollow;

	[SerializeField]
	private ParticleSystem splash;

	[SerializeField]
	private BoxCollider particleKillCol;

	[SerializeField]
	private bool isHeaven;

	private float surfacePosY;

	private SoundManager soundManager;

	private float splashTimer;

	private bool smallSplashAlternator;

	private void Start()
	{
		boxCollider = GetComponent<BoxCollider2D>();
		surfacePosY = base.transform.position.y + boxCollider.size.y / 2f;
		soundManager = GetComponent<SoundManager>();
	}

	private void FixedUpdate()
	{
		if (body != null)
		{
			float f = surfacePosY + 1.3f - body.worldCenterOfMass.y;
			Vector2 vector = Vector2.up * 100f * Mathf.Pow(f, 2f);
			if (body.velocity.y > 0f || isHeaven)
			{
				vector = Vector2.ClampMagnitude(vector, 500f);
			}
			Vector2 vector2 = body.velocity * body.velocity.magnitude * 5f * -1f;
			body.AddForce(vector + vector2);
			body.GetComponent<Body>().ForceOnBody(vector + vector2);
			float num = Mathf.DeltaAngle(body.transform.eulerAngles.z - 180f, 180f);
			body.AddTorque(num * 1.7f);
		}
	}

	private void OnTriggerEnter2D(Collider2D collision)
	{
		if (collision.name == "Climber_Hero_Body_Prefab")
		{
			body = collision.GetComponent<Rigidbody2D>();
			float num = 0f - body.velocity.y;
			if (num > 0.5f && Time.time - splashTimer > 1f)
			{
				if (num > 4f)
				{
					soundManager.PlaySound("splashBig1");
					int num2 = Random.Range(1, 6);
					soundManager.PlaySound("kallsup" + num2);
				}
				else
				{
					soundManager.PlaySound("splashBig2");
				}
				splashTimer = Time.time + 0.5f;
			}
			if (num > 2f)
			{
				ParticleSystem[] componentsInChildren = Object.Instantiate(bubblesFollow, body.GetComponent<Animator>().GetBoneTransform(HumanBodyBones.LeftFoot).transform).GetComponentsInChildren<ParticleSystem>();
				foreach (ParticleSystem obj in componentsInChildren)
				{
					_ = obj.emission;
					obj.trigger.AddCollider(particleKillCol);
				}
				componentsInChildren = Object.Instantiate(bubblesFollow, body.GetComponent<Animator>().GetBoneTransform(HumanBodyBones.RightFoot).transform).GetComponentsInChildren<ParticleSystem>();
				foreach (ParticleSystem obj2 in componentsInChildren)
				{
					ParticleSystem.EmissionModule emission = obj2.emission;
					emission.rateOverTimeMultiplier = collision.GetComponent<Rigidbody2D>().velocity.magnitude * 75f;
					obj2.trigger.AddCollider(particleKillCol);
				}
			}
		}
		if (!(collision.name == "Hand"))
		{
			return;
		}
		float magnitude = collision.GetComponent<Rigidbody2D>().velocity.magnitude;
		if (magnitude > 2f)
		{
			ParticleSystem[] componentsInChildren = Object.Instantiate(bubblesFollow, collision.transform).GetComponentsInChildren<ParticleSystem>();
			foreach (ParticleSystem obj3 in componentsInChildren)
			{
				obj3.Stop();
				ParticleSystem.EmissionModule emission2 = obj3.emission;
				emission2.rateOverTimeMultiplier = magnitude * 75f;
				ParticleSystem.MainModule main = obj3.main;
				main.duration *= Mathf.Clamp01(magnitude / 10f);
				obj3.trigger.AddCollider(particleKillCol);
				obj3.Play();
			}
			if (Time.time - splashTimer > 0.2f)
			{
				splashTimer = Time.time;
				int num3 = Random.Range(1, 4);
				soundManager.PlaySound("splashSmall" + num3, (magnitude - 1f) / 7f);
			}
		}
	}

	private void OnTriggerExit2D(Collider2D collision)
	{
		if (collision.name == "Climber_Hero_Body_Prefab")
		{
			_ = body.velocity.y;
			_ = 2f;
			body = null;
		}
	}
}
