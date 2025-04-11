using UnityEngine;

public class SetPhysicsObjectPositions : MonoBehaviour
{
	[SerializeField]
	private PhysicsObjectsPositions targetPositionsObject;

	private void Update()
	{
		if (Input.GetKeyDown(KeyCode.M))
		{
			SetPositions();
		}
	}

	private void SetPositions()
	{
		PhysicsBodiesPrewarmScript component = GetComponent<PhysicsBodiesPrewarmScript>();
		if (component != null)
		{
			targetPositionsObject.positions = new Vector2[component.rigidBodies.Length];
			targetPositionsObject.rotations = new float[component.rigidBodies.Length];
			for (int i = 0; i < component.rigidBodies.Length; i++)
			{
				targetPositionsObject.positions[i] = component.rigidBodies[i].position;
				targetPositionsObject.rotations[i] = component.rigidBodies[i].rotation;
			}
		}
	}
}
