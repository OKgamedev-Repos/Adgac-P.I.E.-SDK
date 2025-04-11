using System;
using UnityEngine;

public class ArmScript : MonoBehaviour
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

	private JointMotor2D hingeJointMotor;

	private JointMotor2D sliderJointMotor;

	private float oldAngle1;

	private float oldAngle2;

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
		Vector2 vector = (Vector2)gameCursor.transform.position + mouseInput;
		if (Vector2.Distance(base.transform.position, vector) > cursorDistance)
		{
			vector = (Vector2)base.transform.position + (vector - (Vector2)base.transform.position).normalized * cursorDistance;
		}
		Vector2 vector2 = vector - (Vector2)hand.transform.position;
		vector += 0.05f * -vector2 * Math.Clamp(1f - mouseVelocityAverage / 0.2f, 0f, 1f);
		gameCursorRB.MovePosition((Vector3)vector);
		Vector2 vector3 = gameCursor.transform.position - base.transform.position;
		float target = Mathf.Atan2(vector3.y, vector3.x) * 57.29578f;
		float num = Mathf.DeltaAngle(_hingeJoint.jointAngle, target);
		num /= 180f;
		num *= Mathf.Abs(num);
		num *= 180f;
		hingeJointMotor.motorSpeed = Mathf.Clamp(num * 500f, -1000f, 1000f);
		MonoBehaviour.print(hingeJointMotor.motorSpeed);
		_hingeJoint.motor = hingeJointMotor;
		float num2 = Vector2.Dot((hand.transform.position - base.transform.position).normalized, (hand.transform.position - gameCursor.transform.position).normalized);
		float magnitude = (hand.transform.position - gameCursor.transform.position).magnitude;
		sliderJointMotor.motorSpeed = Mathf.Clamp((0f - num2) * Mathf.Abs(num2) * 20f * magnitude, -75f, 75f);
		_sliderJoint.motor = sliderJointMotor;
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
}
