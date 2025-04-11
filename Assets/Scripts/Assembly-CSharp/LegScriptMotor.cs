using UnityEngine;

public class LegScriptMotor : MonoBehaviour
{
	private HingeJoint2D hj;

	private JointMotor2D motor;

	[SerializeField]
	private Rigidbody2D body;

	private void Start()
	{
		hj = GetComponent<HingeJoint2D>();
		motor = hj.motor;
	}

	private void FixedUpdate()
	{
		float num = Mathf.DeltaAngle(hj.jointAngle, body.rotation);
		motor.motorSpeed = num * Mathf.Abs(num);
		hj.motor = motor;
	}
}
