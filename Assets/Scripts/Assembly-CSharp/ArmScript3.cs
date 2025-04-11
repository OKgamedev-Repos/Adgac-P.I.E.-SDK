using UnityEngine;

public class ArmScript3 : MonoBehaviour
{
	[SerializeField]
	private GameObject slider;

	[SerializeField]
	private GameObject hand;

	[SerializeField]
	private GameObject gameCursor;

	private HingeJoint2D _hingeJoint;

	private SliderJoint2D _sliderJoint;

	private Rigidbody2D gameCursorRB;

	private FrictionJoint2D frictionJoint;

	[SerializeField]
	private float mouseSpeed = 0.5f;

	[SerializeField]
	private AnimationCurve mouseCurve;

	[SerializeField]
	private float armDistance;

	[SerializeField]
	private float cursorDistance;

	[SerializeField]
	private float minHandDistance;

	private Vector2 mouseAxis;

	private bool isGrabbing;

	private Vector2 mouseInput;

	private float mouseVelocityAverage;

	private Vector2 jointLengths;

	private float oldAngle;

	private JointMotor2D hingeJointMotor;

	private JointMotor2D sliderJointMotor;

	private void Start()
	{
		Physics2D.gravity = new Vector2(0f, -30f);
		Cursor.visible = false;
		Cursor.lockState = CursorLockMode.Locked;
		gameCursorRB = gameCursor.GetComponent<Rigidbody2D>();
		gameCursor.transform.position = hand.transform.position;
		_hingeJoint = GetComponent<HingeJoint2D>();
		_sliderJoint = slider.GetComponent<SliderJoint2D>();
		hingeJointMotor = _hingeJoint.motor;
		sliderJointMotor = _sliderJoint.motor;
		frictionJoint = hand.GetComponent<FrictionJoint2D>();
	}

	private void Update()
	{
		mouseAxis += new Vector2(Input.GetAxis("Mouse X"), Input.GetAxis("Mouse Y"));
		if (Input.GetMouseButtonDown(0) || Input.GetMouseButtonUp(0))
		{
			GrabPressed();
		}
	}

	private void FixedUpdate()
	{
		_ = mouseInput;
		mouseInput = mouseAxis * mouseSpeed;
		mouseAxis = Vector2.zero;
		BFod();
	}

	private void GrabPressed()
	{
		isGrabbing = !isGrabbing;
		if (isGrabbing)
		{
			frictionJoint.maxForce = 750f;
		}
		else
		{
			frictionJoint.maxForce = 0f;
		}
	}

	private void BFod()
	{
		float num = 0f;
		float num2 = 0f;
		Vector2 vector = gameCursor.transform.position;
		float num3 = 1f;
		mouseVelocityAverage = Mathf.Lerp(mouseVelocityAverage, Mathf.Max(0.1f * mouseInput.magnitude, 0.001f), 0.05f) + 0.005f;
		Vector2 vector2 = gameCursorRB.position + mouseInput * mouseVelocityAverage;
		if (((Vector2)base.transform.position - vector2).magnitude > 3.5f)
		{
			vector2 = (Vector2)base.transform.position + (vector2 - (Vector2)base.transform.position).normalized * 3.5f;
		}
		Vector2 vector3 = (Vector2)hand.transform.position - vector;
		Vector2 lhs = (hand.transform.position - _hingeJoint.transform.position).normalized;
		new Vector2(0f - lhs.y, lhs.x);
		num2 = Vector2.Dot(lhs, vector3.normalized);
		num = vector3.magnitude * num2;
		vector2 += 0.05f * vector3 * 10f * Mathf.Clamp(0.2f - mouseVelocityAverage, 0f, 0.2f);
		gameCursorRB.MovePosition(vector2);
		gameCursorRB.velocity = vector2 - gameCursorRB.position;
		Vector2 vector4 = (Vector2)_hingeJoint.transform.position - vector;
		float current = 57.29578f * Mathf.Atan2(vector4.y, vector4.x) - 180f - _hingeJoint.referenceAngle;
		float num4 = 0f - Mathf.DeltaAngle(current, _hingeJoint.jointAngle);
		num4 = Mathf.Sign(num4) * Mathf.Max(Mathf.Abs(num4 / 2f), Mathf.Abs(num4 * num4));
		num4 *= Mathf.Clamp01(Mathf.Abs(num4) / num3);
		hingeJointMotor.motorSpeed = Mathf.Clamp((num4 * 3f + (num4 - oldAngle) * 0f) * Mathf.Pow(Mathf.Clamp01(vector4.magnitude / 0.1f), 2f), -800f, 800f);
		_hingeJoint.motor = hingeJointMotor;
		float num5 = 16f - Mathf.Max(_sliderJoint.reactionTorque * 0.001f, 5f);
		float num6 = Mathf.Pow(num2, 2f);
		sliderJointMotor.motorSpeed = Mathf.Clamp((0f - num) * Mathf.Abs(num) * num5 * num6, -50f, 50f);
		_sliderJoint.motor = sliderJointMotor;
		oldAngle = num4;
	}
}
