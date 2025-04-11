using UnityEngine;

public class CharacterShadowScript : MonoBehaviour
{
	public SkinnedMeshRenderer newArmature;

	public string rootBoneName = "pelvis";

	public bool PressToReassign;

	[SerializeField]
	private SkinnedMeshRenderer mesh;

	[SerializeField]
	private GameObject handBone_R;

	private void Start()
	{
	}

	private void UpdateBones()
	{
		for (int i = 0; i < mesh.bones.Length; i++)
		{
			for (int j = 0; j < newArmature.bones.Length; j++)
			{
				if (mesh.bones[i].name == newArmature.bones[j].name)
				{
					mesh.bones[i].transform.position = newArmature.bones[j].transform.position;
					mesh.bones[i].transform.rotation = newArmature.bones[j].transform.rotation;
				}
			}
		}
	}

	private void LateUpdate()
	{
		handBone_R.transform.position = Vector3.zero;
	}
}
