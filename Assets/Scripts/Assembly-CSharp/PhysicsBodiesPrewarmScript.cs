using System.Collections;
using UnityEngine;

public class PhysicsBodiesPrewarmScript : MonoBehaviour
{
	[SerializeField]
	public Rigidbody2D[] rigidBodies;

	[SerializeField]
	private PhysicsObjectsPositions objectsPositions;

	private int frames;

	private bool prewarm;

	private void OnEnable()
	{
		StartCoroutine(HaltMotion());
	}

	private void ApplyPositions()
	{
		for (int i = 0; i < rigidBodies.Length; i++)
		{
			rigidBodies[i].velocity = Vector2.zero;
			rigidBodies[i].angularVelocity = 0f;
		}
	}

	private void AdvancePhysX(int framesToSim)
	{
		frames = 0;
		Physics2D.simulationMode = SimulationMode2D.Script;
		StartCoroutine(StepPhysics(framesToSim));
	}

	private IEnumerator StepPhysics(int framesToSim)
	{
		while (true)
		{
			Physics2D.Simulate(0.025f);
			frames++;
			if (frames > framesToSim)
			{
				break;
			}
			yield return null;
		}
		Physics2D.simulationMode = SimulationMode2D.FixedUpdate;
	}

	private IEnumerator HaltMotion()
	{
		yield return new WaitForSeconds(1f);
		ApplyPositions();
	}
}
