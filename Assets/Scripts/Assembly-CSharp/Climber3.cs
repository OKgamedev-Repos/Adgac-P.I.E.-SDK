using System;
using UnityEngine;

public class Climber3 : MonoBehaviour
{
	[SerializeField]
	private GameObject gameCursor;

	[SerializeField]
	private Rigidbody2D body;

	[SerializeField]
	private Rigidbody2D hand;

	[SerializeField]
	private AnimationCurve mouseCurve;

	[SerializeField]
	private Transform shoulder_R;

	private HingeJoint2D hingejoint;

	private FrictionJoint2D frictionJoint;

	[SerializeField]
	private float armDistance;

	[SerializeField]
	private float cursorDistance;

	[SerializeField]
	private float mouseSpeed = 0.5f;

	[SerializeField]
	private float maxTargetVelocity;

	[SerializeField]
	private float strength;

	private Vector2 mouseAxis;

	private bool isGrabbing;

	private Vector2 mouseInput;

	private float mouseVelocityAverage;

	private void Start()
	{
		Physics2D.gravity = new Vector2(0f, -30f);
		Cursor.visible = false;
		Cursor.lockState = CursorLockMode.Locked;
		mouseInput = Vector2.zero;
		gameCursor.transform.position = hand.transform.position;
		frictionJoint = hand.GetComponent<FrictionJoint2D>();
	}

	private void FixedUpdate()
	{
		_ = mouseInput;
		mouseInput = mouseAxis * mouseSpeed;
		mouseAxis = Vector2.zero;
		mouseInput *= mouseCurve.Evaluate(mouseInput.magnitude);
		mouseVelocityAverage = Mathf.Lerp(mouseVelocityAverage, mouseInput.magnitude, Time.fixedDeltaTime * 3f);
		Vector2 vector = (Vector2)gameCursor.transform.position + mouseInput;
		if ((vector - (Vector2)shoulder_R.transform.position).magnitude > cursorDistance)
		{
			vector = (Vector2)shoulder_R.transform.position + (vector - (Vector2)shoulder_R.transform.position).normalized * cursorDistance;
		}
		Vector2 vector2 = vector - (Vector2)hand.transform.position;
		vector += 0.05f * -vector2 * Math.Clamp(1f - mouseVelocityAverage / 0.2f, 0f, 1f);
		gameCursor.transform.position = vector;
		_ = vector2.sqrMagnitude;
	}

	private void Update()
	{
		mouseAxis += new Vector2(Input.GetAxis("Mouse X"), Input.GetAxis("Mouse Y"));
		if (Input.GetMouseButtonDown(0) || Input.GetMouseButtonUp(0))
		{
			GrabPressed();
		}
	}

	private void JointPhysics(Vector2 targetVelocity, float delta)
	{
		Vector2 vector = Vector2.ClampMagnitude(targetVelocity, maxTargetVelocity);
		Vector2 vector2 = hand.velocity - body.velocity;
		Vector2 vector3 = vector - vector2;
		Vector2 force = -vector3 * strength;
		Vector2 force2 = vector3 * strength;
		_ = isGrabbing;
		body.AddForce(force);
		hand.AddForce(force2);
	}

	private Vector2 Friction(Rigidbody2D rb, Vector2 totalForce, float frictionForceLimit, float dynamicMu, float dynamicThreshold, float delta)
	{
		float num = 0f;
		Vector2 vector = -totalForce + new Vector2(0f, 0f - num);
		Vector2 vector2 = -rb.velocity / delta * rb.mass;
		if (hand.velocity.magnitude < dynamicThreshold)
		{
			return Vector2.ClampMagnitude(vector + vector2, frictionForceLimit);
		}
		return Vector2.ClampMagnitude(vector + vector2, frictionForceLimit * dynamicMu);
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
