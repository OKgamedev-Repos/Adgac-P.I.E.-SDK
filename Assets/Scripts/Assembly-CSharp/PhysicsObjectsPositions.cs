using UnityEngine;

[CreateAssetMenu(fileName = "New Positions", menuName = "ScriptableObjects/PhysicsObjectsPositions")]
public class PhysicsObjectsPositions : ScriptableObject
{
	public Vector2[] positions;

	public float[] rotations;
}
