using UnityEngine;

public class SuspendedHingeJointScript : MonoBehaviour
{
	[SerializeField]
	private float dropThreshold = 1f;

	private HingeJoint2D hj;

	private float targetRotation;

	private bool isSuspended = true;

	private float speed = 10f;

	private float maxTorque;

	[SerializeField]
	private ParticleSystem[] particles;

	private AudioSource breakSound;

	private void Start()
	{
		hj = GetComponent<HingeJoint2D>();
		maxTorque = hj.motor.maxMotorTorque;
		breakSound = GetComponent<AudioSource>();
	}

	private void FixedUpdate()
	{
		if (!(hj != null) || !isSuspended)
		{
			return;
		}
		JointMotor2D motor = hj.motor;
		float num = targetRotation - hj.jointAngle;
		motor.motorSpeed = num * speed;
		motor.maxMotorTorque = Mathf.Lerp(0f, maxTorque, Mathf.Clamp01(Mathf.Abs(num / dropThreshold)));
		hj.motor = motor;
		if (!(Mathf.Abs(num) > dropThreshold))
		{
			return;
		}
		hj.useMotor = false;
		isSuspended = false;
		breakSound.Play();
		if (particles.Length != 0)
		{
			for (int i = 0; i < particles.Length; i++)
			{
				particles[i].Play();
			}
		}
	}
}
