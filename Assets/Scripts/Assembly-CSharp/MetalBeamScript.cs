using UnityEngine;

public class MetalBeamScript : MonoBehaviour
{
	private Rigidbody2D rb;

	private HingeJoint2D joint;

	private AudioSource audioSource;

	private float smoothVel;

	private void Start()
	{
		rb = GetComponent<Rigidbody2D>();
		joint = GetComponent<HingeJoint2D>();
		rb.AddTorque(1000f);
		audioSource = GetComponent<AudioSource>();
	}

	private void FixedUpdate()
	{
		float jointAngle = joint.jointAngle;
		if ((double)Mathf.Abs(jointAngle) < 0.33)
		{
			if (jointAngle >= 0f)
			{
				if (rb.angularVelocity > 0f)
				{
					rb.AddTorque(50f);
				}
			}
			else if (rb.angularVelocity < 0f)
			{
				rb.AddTorque(-50f);
			}
		}
		jointAngle *= 5f;
		rb.AddTorque(jointAngle);
		float value = Mathf.Abs(rb.angularVelocity) / 10f;
		value = Mathf.Clamp01(value);
		smoothVel = Mathf.Lerp(smoothVel, value, Time.fixedDeltaTime);
		audioSource.volume = smoothVel;
		audioSource.pitch = Mathf.Clamp01(smoothVel / 5f + 0.9f);
	}
}
