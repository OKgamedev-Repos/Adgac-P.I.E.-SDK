using UnityEngine;

public class HingeJointMotorTargetScript : MonoBehaviour
{
	private HingeJoint2D hj;

	[SerializeField]
	private float targetRotation;

	[SerializeField]
	private float speed;

	[SerializeField]
	private bool reduceStrengthAroundTarget;

	[SerializeField]
	private bool playSound;

	private AudioSource audioSource;

	private float maxTorque;

	//private bool direction;

	private void Start()
	{
		hj = GetComponent<HingeJoint2D>();
		maxTorque = hj.motor.maxMotorTorque;
		if (playSound)
		{
			audioSource = GetComponentInChildren<AudioSource>();
		}
	}

	private void FixedUpdate()
	{
		if (hj != null)
		{
			JointMotor2D motor = hj.motor;
			float num = targetRotation - hj.jointAngle;
			if (reduceStrengthAroundTarget)
			{
				motor.maxMotorTorque = Mathf.Lerp(0f, maxTorque, Mathf.Clamp01(Mathf.Abs(num * 0.05f)));
			}
			motor.motorSpeed = num * speed;
			hj.motor = motor;
		}
		if (!playSound)
		{
			return;
		}
		if (hj.jointSpeed > 15f)
		{
			if (!audioSource.isPlaying)
			{
				audioSource.pitch = 0.84000003f;
				audioSource.Play();
				//direction = true;
			}
		}
		else if (hj.jointSpeed < -15f && !audioSource.isPlaying)
		{
			audioSource.pitch = 1f;
			audioSource.Play();
			//direction = false;
		}
	}
}
