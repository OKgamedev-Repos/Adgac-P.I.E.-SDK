using UnityEngine;

public class RunningWater : MonoBehaviour
{
	private AreaEffector2D ae;

	private ClimbingSurface cs;

	public float force = 300f;

	private int activeHands;

	private Rigidbody2D handR;

	private Rigidbody2D handL;

	private void Start()
	{
		ae = GetComponent<AreaEffector2D>();
		cs = GetComponent<ClimbingSurface>();
	}

	public void AddHand(ArmScript_v2 armScript)
	{
		if (activeHands == 0)
		{
			ActivateWater();
		}
		activeHands++;
		if (armScript.isLeft)
		{
			handL = armScript.hand;
		}
		else
		{
			handR = armScript.hand;
		}
	}

	public void RemoveHand(ArmScript_v2 armScript)
	{
		activeHands--;
		if (activeHands == 0)
		{
			DeactivateWater();
		}
		if (armScript.isLeft)
		{
			handL = null;
		}
		else
		{
			handR = null;
		}
	}

	private void ActivateWater()
	{
	}

	public void DeactivateWater()
	{
		ae.forceMagnitude = 0f;
	}

	public void OnDrawGizmos()
	{
		ae = GetComponent<AreaEffector2D>();
		Gizmos.color = Color.red;
		Vector2 vector = HelperFunctions.DegreeToVector2(ae.forceAngle);
		Gizmos.DrawLine(base.transform.position, base.transform.position + (Vector3)vector);
	}

	private void FixedUpdate()
	{
		if (handL != null)
		{
			Vector2 vector = HelperFunctions.DegreeToVector2(ae.forceAngle);
			vector *= force;
			handL.AddForce(vector);
		}
		if (handR != null)
		{
			Vector2 vector2 = HelperFunctions.DegreeToVector2(ae.forceAngle);
			vector2 *= force;
			handR.AddForce(vector2);
		}
	}
}
