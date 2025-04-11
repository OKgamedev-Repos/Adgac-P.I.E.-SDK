using UnityEngine;

public class AnimControl : MonoBehaviour
{
	[SerializeField]
	private ArmScript_v2 armRight;

	[SerializeField]
	private ArmScript_v2 armLeft;

	private Body bodyScript;

	protected Animator animator;

	private HingeJoint2D hj_R;

	private HingeJoint2D hj_L;

	private JointMotor2D motor_R;

	private JointMotor2D motor_L;

	private CapsuleCollider2D capsuleCollider;

	private Rigidbody2D rb;

	private Vector2 forceAverage_R;

	private Vector2 forceAverage_L;

	private void Start()
	{
		animator = GetComponent<Animator>();
		bodyScript = GetComponent<Body>();
		rb = GetComponent<Rigidbody2D>();
		HingeJoint2D[] components = GetComponents<HingeJoint2D>();
		foreach (HingeJoint2D hingeJoint2D in components)
		{
			if (hingeJoint2D.connectedBody.gameObject == armRight.gameObject)
			{
				hj_R = hingeJoint2D;
			}
			else if (hingeJoint2D.connectedBody.gameObject == armLeft.gameObject)
			{
				hj_L = hingeJoint2D;
			}
		}
		motor_R = hj_R.motor;
		motor_L = hj_L.motor;
		capsuleCollider = GetComponent<CapsuleCollider2D>();
		animator.SetLayerWeight(15, 1f);
	}

	private void Update()
	{
		if (armRight != null)
		{
			if (armRight.isGrabbing)
			{
				if (armRight.activeSurface != null)
				{
					if (armRight.activeSurface.isVertical)
					{
						animator.SetLayerWeight(16, 1f);
						animator.SetLayerWeight(1, 0f);
					}
					else
					{
						animator.SetLayerWeight(1, 1f);
					}
				}
				else
				{
					animator.SetLayerWeight(1, 1f);
				}
			}
			else
			{
				animator.SetLayerWeight(1, 0f);
				animator.SetLayerWeight(16, 0f);
			}
			float num = (armRight.hand.position.y - armRight.transform.position.y) / armRight.armDistance;
			animator.SetLayerWeight(3, Mathf.Clamp01(num - 0.1f));
			animator.SetLayerWeight(4, Mathf.Clamp01(num * -1f - 0.33f) / 0.66f);
			float num2 = (armRight.hand.position.x - armRight.transform.position.x) / armRight.armDistance;
			animator.SetLayerWeight(10, Mathf.Clamp01((num2 - 0.8f) / 0.2f));
			animator.SetLayerWeight(11, Mathf.Clamp01(num2 * -1f / 0.2f));
		}
		if (armLeft != null)
		{
			if (armLeft.isGrabbing)
			{
				if (armLeft.activeSurface != null)
				{
					if (armLeft.activeSurface.isVertical)
					{
						animator.SetLayerWeight(17, 1f);
						animator.SetLayerWeight(2, 0f);
					}
					else
					{
						animator.SetLayerWeight(2, 1f);
					}
				}
				else
				{
					animator.SetLayerWeight(2, 1f);
				}
			}
			else
			{
				animator.SetLayerWeight(2, 0f);
				animator.SetLayerWeight(17, 0f);
			}
			float num3 = (armLeft.hand.position.y - armLeft.transform.position.y) / armLeft.armDistance;
			animator.SetLayerWeight(5, Mathf.Clamp01(num3 - 0.1f));
			animator.SetLayerWeight(6, Mathf.Clamp01(num3 * -1f - 0.33f) / 0.66f);
			float num4 = (armLeft.transform.position.x - armLeft.hand.position.x) / armLeft.armDistance;
			animator.SetLayerWeight(12, Mathf.Clamp01((num4 - 0.8f) / 0.2f));
			animator.SetLayerWeight(13, Mathf.Clamp01(num4 * -1f / 0.2f));
		}
		if (bodyScript.isInWater)
		{
			animator.SetLayerWeight(14, 1f);
		}
		else
		{
			animator.SetLayerWeight(14, 0f);
		}
	}

	private void FixedUpdate()
	{
		float num = (armRight.hand.position.y - armLeft.hand.transform.position.y) / armRight.armDistance / 2f;
		animator.SetFloat("Lean", num);
		motor_R.maxMotorTorque = 10f;
		motor_L.maxMotorTorque = 10f;
		forceAverage_R = Vector2.Lerp(forceAverage_R, armRight.force, Time.fixedDeltaTime * 4f);
		forceAverage_L = Vector2.Lerp(forceAverage_L, armLeft.force, Time.fixedDeltaTime * 4f);
		if (!bodyScript.isInWater && armRight.isGrabbing && armRight.activeSurface != null && rb.velocity.y > 1f)
		{
			motor_R.maxMotorTorque = Mathf.Lerp(0f, 20f, (0f - forceAverage_R.y - 350f) / 50f);
			if (!hj_R.useMotor)
			{
				hj_R.useMotor = true;
			}
			motor_R.motorSpeed = Mathf.DeltaAngle(hj_R.jointAngle, 33f * (0f - num)) * 10f;
			hj_R.motor = motor_R;
		}
		else if (bodyScript.isInWater)
		{
			if (!hj_R.useMotor)
			{
				hj_R.useMotor = true;
			}
			motor_R.maxMotorTorque = 10f;
			motor_R.motorSpeed = Mathf.DeltaAngle(hj_R.jointAngle, 33f * (0f - num)) * 5f;
			hj_R.motor = motor_R;
		}
		else if (hj_R.useMotor)
		{
			hj_R.useMotor = false;
		}
		if (armLeft.isGrabbing && armLeft.activeSurface != null && rb.velocity.y > 1f)
		{
			motor_L.maxMotorTorque = Mathf.Lerp(0f, 20f, (0f - forceAverage_L.y - 350f) / 50f);
			if (!hj_L.useMotor)
			{
				hj_L.useMotor = true;
			}
			motor_L.motorSpeed = Mathf.DeltaAngle(hj_L.jointAngle, 33f * (0f - num)) * 10f;
			hj_L.motor = motor_L;
		}
		else if (hj_L.useMotor)
		{
			hj_L.useMotor = false;
		}
		Rigidbody2D component = bodyScript.GetComponent<Rigidbody2D>();
		float num2 = Mathf.Max(Mathf.Clamp01((forceAverage_R.magnitude - 300f) / 100f), Mathf.Clamp01((forceAverage_L.magnitude - 300f) / 100f));
		num2 += Mathf.Clamp01(component.velocity.sqrMagnitude / 20f) * (1f - Mathf.Clamp01(component.velocity.y));
		num2 += Mathf.Abs(armRight.hand.position.y - armLeft.hand.position.y) / 3f;
		if (armRight.isGrabbing && armRight.activeSurface != null)
		{
			animator.SetLayerWeight(8, Mathf.Clamp01(Mathf.Lerp(animator.GetLayerWeight(8), num2, Time.fixedDeltaTime * 4f)));
		}
		else
		{
			animator.SetLayerWeight(8, Mathf.Clamp01(Mathf.Lerp(animator.GetLayerWeight(8), 0f, Time.fixedDeltaTime * 2f)));
		}
		if (armLeft.isGrabbing && armLeft.activeSurface != null && !armRight.isGrabbing)
		{
			animator.SetLayerWeight(9, Mathf.Clamp01(Mathf.Lerp(animator.GetLayerWeight(9), num2, Time.fixedDeltaTime * 4f)));
		}
		else
		{
			animator.SetLayerWeight(9, Mathf.Clamp01(Mathf.Lerp(animator.GetLayerWeight(9), 0f, Time.fixedDeltaTime * 2f)));
		}
		if (armLeft.grabbedSurface == null && armRight.grabbedSurface == null && !bodyScript.isInWater)
		{
			animator.SetLayerWeight(20, Mathf.Lerp(animator.GetLayerWeight(20), 1f, Time.fixedDeltaTime * 3f));
		}
		else
		{
			animator.SetLayerWeight(20, Mathf.Lerp(animator.GetLayerWeight(20), 0f, Time.fixedDeltaTime * 3f));
		}
	}
}
