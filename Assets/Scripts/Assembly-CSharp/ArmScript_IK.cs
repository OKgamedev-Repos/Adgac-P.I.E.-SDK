using System;
using UnityEngine;

public class ArmScript_IK : MonoBehaviour
{
	[SerializeField]
	private GameObject elbow;

	[SerializeField]
	private GameObject hand;

	[SerializeField]
	private GameObject gameCursor;

	private HingeJoint2D bodyHingeJoint;

	private HingeJoint2D elbowHingeJoint;

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

	private Vector2 handTarget;

	private JointMotor2D bodyJointMotor;

	private JointMotor2D elbowJointMotor;

	private float oldAngle1;

	private float oldAngle2;

	private void Start()
	{
		Physics2D.gravity = new Vector2(0f, -30f);
		Cursor.visible = false;
		Cursor.lockState = CursorLockMode.Locked;
		jointLengths.x = Vector2.Distance(base.transform.position, elbow.transform.position);
		jointLengths.y = Vector2.Distance(elbow.transform.position, hand.transform.position);
		bodyHingeJoint = GetComponent<HingeJoint2D>();
		elbowHingeJoint = elbow.GetComponent<HingeJoint2D>();
		frictionJoint = hand.GetComponent<FrictionJoint2D>();
		bodyJointMotor = bodyHingeJoint.motor;
		elbowJointMotor = elbowHingeJoint.motor;
		gameCursorRB = gameCursor.GetComponent<Rigidbody2D>();
		gameCursor.transform.position = hand.transform.position;
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
		float num = Mathf.Clamp(Vector2.Distance(base.transform.position, gameCursor.transform.position), minHandDistance, jointLengths.x + jointLengths.y);
		Vector2 vector3 = gameCursor.transform.position - base.transform.position;
		float num2 = LawOfCos(jointLengths.y, jointLengths.x, num) - Mathf.Atan2(vector3.x, vector3.y) * 57.29578f - 90f;
		float num3 = LawOfCos(num, jointLengths.x, jointLengths.y);
		float num4 = Mathf.DeltaAngle(bodyHingeJoint.jointAngle, num2 - 180f);
		num4 *= Mathf.Abs(num4 / 2f);
		num4 *= Mathf.Clamp01(MathF.Abs(num4));
		bodyJointMotor.motorSpeed = Mathf.Clamp(num4 * 10f, -1000f, 1000f);
		bodyHingeJoint.motor = bodyJointMotor;
		float num5 = Mathf.DeltaAngle(elbowHingeJoint.jointAngle, num3 - 180f);
		num5 *= Mathf.Abs(num5 / 2f);
		num5 *= Mathf.Clamp01(MathF.Abs(num5));
		elbowJointMotor.motorSpeed = Mathf.Clamp(num5 * 10f, -1000f, 1000f);
		elbowHingeJoint.motor = elbowJointMotor;
		MonoBehaviour.print(elbowHingeJoint.motor.motorSpeed);
		Debug.DrawLine(base.transform.position, elbow.transform.position);
		Debug.DrawLine(elbow.transform.position, hand.transform.position);
		oldAngle1 = num4;
		oldAngle2 = num5;
	}

	private float LawOfCos(float a, float b, float c)
	{
		if (b * c == 0f)
		{
			return 0f;
		}
		return Mathf.Acos((b * b + c * c - a * a) / (2f * b * c)) * 57.29578f;
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
