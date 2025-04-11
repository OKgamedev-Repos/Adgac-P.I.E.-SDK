using UnityEngine;

public class ShouldersScript : MonoBehaviour
{
	[SerializeField]
	private GameObject mannequin;

	[SerializeField]
	private ArmScript_v2 armRight;

	[SerializeField]
	private ArmScript_v2 armLeft;

	private HingeJoint2D hj_R;

	private HingeJoint2D hj_L;

	private JointMotor2D motor_L;

	private JointMotor2D motor_R;

	private void Start()
	{
		HingeJoint2D[] components = mannequin.GetComponents<HingeJoint2D>();
		foreach (HingeJoint2D hingeJoint2D in components)
		{
			if (hj_R == null)
			{
				hj_R = hingeJoint2D;
			}
			else
			{
				hj_L = hingeJoint2D;
			}
		}
		motor_R = hj_R.motor;
		motor_L = hj_L.motor;
	}

	private void Update()
	{
	}

	private void FixedUpdate()
	{
		float num = (armRight.hand.position.y - armLeft.hand.transform.position.y) / armRight.armDistance / 2f;
		motor_R.motorSpeed = Mathf.DeltaAngle(hj_R.jointAngle, 25f * (0f - num)) * 10f;
		hj_R.motor = motor_R;
		motor_L.motorSpeed = Mathf.DeltaAngle(hj_L.jointAngle, 25f * (0f - num)) * 10f;
		hj_L.motor = motor_L;
	}
}
