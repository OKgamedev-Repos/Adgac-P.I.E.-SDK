using UnityEngine;

public class SnappingHingeJointScript : MonoBehaviour
{
	[SerializeField]
	private float swingThreshold = 1f;

	private HingeJoint2D hj;

	private float targetRotation;

	private bool isSuspended = true;

	private float speed = 10f;

	private float maxTorque;

	private AudioSource audioSource;

	[SerializeField]
	private ParticleSystem[] particles;

	private void Start()
	{
		hj = GetComponent<HingeJoint2D>();
		maxTorque = hj.motor.maxMotorTorque;
		audioSource = GetComponent<AudioSource>();
	}

	private void FixedUpdate()
	{
		if (hj != null && isSuspended)
		{
			JointMotor2D motor = hj.motor;
			float num = targetRotation - hj.jointAngle;
			motor.motorSpeed = num * speed;
			motor.maxMotorTorque = Mathf.Lerp(0f, maxTorque, Mathf.Clamp01(Mathf.Abs(num / swingThreshold)));
			hj.motor = motor;
			if (Mathf.Abs(hj.jointSpeed) > 1f && !audioSource.isPlaying)
			{
				audioSource.Play();
			}
			audioSource.volume = Mathf.Clamp01(hj.jointSpeed / 2f);
		}
	}
}
