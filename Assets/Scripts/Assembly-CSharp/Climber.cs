using UnityEngine;

public class Climber : MonoBehaviour
{
	public GameObject customCursor;

	public Rigidbody2D body;

	public Rigidbody2D arm;

	public Rigidbody2D hammer;

	public AnimationCurve mouseCurve;

	private HingeJoint2D hj;

	private SliderJoint2D sj;

	private Rigidbody2D fakeCursorRB;

	[SerializeField]
	private float mouseSpeed = 0.5f;

	[SerializeField]
	private float deadzone = 0.1f;

	private JointMotor2D motor;

	private JointMotor2D slider;

	private float oldAngle;

	private float mouseVelocityAverage;

	private Vector2 mouseInput;

	private void Start()
	{
		Physics2D.gravity = new Vector2(0f, -30f);
		Cursor.visible = false;
		Cursor.lockState = CursorLockMode.Locked;
		customCursor.transform.position = hammer.position;
		hj = body.GetComponent<HingeJoint2D>();
		sj = arm.GetComponent<SliderJoint2D>();
		motor = hj.motor;
		slider = sj.motor;
		mouseVelocityAverage = 0f;
		mouseInput = Vector2.zero;
		fakeCursorRB = customCursor.GetComponent<Rigidbody2D>();
	}

	private void Update()
	{
		customCursor.transform.position = new Vector3(customCursor.transform.position.x, customCursor.transform.position.y, -1f);
	}

	private void FixedUpdate()
	{
		Vector2 a = mouseInput;
		mouseInput = new Vector2(Input.GetAxis("Mouse X"), Input.GetAxis("Mouse Y")) * mouseSpeed;
		mouseInput *= mouseCurve.Evaluate(mouseInput.magnitude);
		mouseInput = Vector2.Lerp(a, mouseInput, 0.5f);
		BFod();
	}

	private void ArmLength()
	{
		float motorSpeed = Vector2.Distance(body.transform.position, customCursor.transform.position) - Vector2.Distance(body.transform.position, hammer.position);
		JointMotor2D jointMotor2D = default(JointMotor2D);
		jointMotor2D.motorSpeed = motorSpeed;
		jointMotor2D.maxMotorTorque = 10000f;
		JointMotor2D jointMotor2D2 = jointMotor2D;
		arm.GetComponent<SliderJoint2D>().motor = jointMotor2D2;
	}

	private void HingeRotation()
	{
		float motorSpeed = Vector2.Angle(hammer.transform.position - body.transform.position, customCursor.transform.position - body.transform.position);
		JointMotor2D jointMotor2D = default(JointMotor2D);
		jointMotor2D.motorSpeed = motorSpeed;
		jointMotor2D.maxMotorTorque = 10000f;
		JointMotor2D jointMotor2D2 = jointMotor2D;
		body.GetComponent<HingeJoint2D>().motor = jointMotor2D2;
	}

	private void BFod()
	{
		float num = 0f;
		float num2 = 0f;
		Vector2 vector = customCursor.transform.position;
		float num3 = 1f;
		mouseVelocityAverage = Mathf.Lerp(mouseVelocityAverage, Mathf.Max(0.1f * mouseInput.magnitude, 0.001f), 0.05f) + 0.005f;
		Vector2 vector2 = fakeCursorRB.position + mouseInput * mouseVelocityAverage;
		if (((Vector2)body.transform.position - vector2).magnitude > 3.5f)
		{
			vector2 = (Vector2)body.transform.position + (vector2 - (Vector2)body.transform.position).normalized * 3.5f;
		}
		Vector2 vector3 = (Vector2)hammer.transform.position - vector;
		Vector2 lhs = (hammer.transform.position - hj.transform.position).normalized;
		new Vector2(0f - lhs.y, lhs.x);
		num2 = Vector2.Dot(lhs, vector3.normalized);
		num = vector3.magnitude * num2;
		vector2 += 0.05f * vector3 * 10f * Mathf.Clamp(0.2f - mouseVelocityAverage, 0f, 0.2f);
		fakeCursorRB.MovePosition(vector2);
		fakeCursorRB.velocity = vector2 - fakeCursorRB.position;
		Vector2 vector4 = (Vector2)hj.transform.position - vector;
		float current = 57.29578f * Mathf.Atan2(vector4.y, vector4.x) - 180f - hj.referenceAngle;
		float num4 = 0f - Mathf.DeltaAngle(current, hj.jointAngle);
		num4 = Mathf.Sign(num4) * Mathf.Max(Mathf.Abs(num4 / 2f), Mathf.Abs(num4 * num4));
		num4 *= Mathf.Clamp01(Mathf.Abs(num4) / num3);
		motor.motorSpeed = Mathf.Clamp((num4 * 3f + (num4 - oldAngle) * 0f) * Mathf.Pow(Mathf.Clamp01(vector4.magnitude / deadzone), 2f), -800f, 800f);
		hj.motor = motor;
		float num5 = 16f - Mathf.Max(sj.reactionTorque * 0.001f, 5f);
		float num6 = Mathf.Pow(num2, 4f);
		slider.motorSpeed = Mathf.Clamp((0f - num) * Mathf.Abs(num) * num5 * num6, -50f, 50f);
		sj.motor = slider;
		oldAngle = num4;
	}

	private void MouseInput()
	{
		float axis = Input.GetAxis("Mouse X");
		float axis2 = Input.GetAxis("Mouse Y");
		customCursor.transform.position += new Vector3(axis, axis2, 0f) * mouseSpeed;
	}
}
