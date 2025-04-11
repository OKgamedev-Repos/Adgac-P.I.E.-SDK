using UnityEngine;

public class RotateGameObject : MonoBehaviour
{
	public float rot_speed_x;

	public float rot_speed_y;

	public float rot_speed_z;

	public bool local;

	private void Start()
	{
	}

	private void FixedUpdate()
	{
		if (local)
		{
			base.transform.Rotate(base.transform.up, Time.fixedDeltaTime * rot_speed_x);
		}
		else
		{
			base.transform.Rotate(Time.fixedDeltaTime * new Vector3(rot_speed_x, rot_speed_y, rot_speed_z), Space.World);
		}
	}
}
