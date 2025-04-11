using System;
using System.Runtime.Serialization;

[Serializable]
public class PlayerData
{
	public float[] position;

	public float rotation;

	public float[] arm_r_pos;

	public float[] arm_l_pos;

	public float[] hand_r_pos;

	public float[] hand_l_pos;

	public bool isNewGame;

	public int items;

	public int clears;

	public int giftClaimed;

	[OptionalField]
	public float time;

	[OptionalField]
	public float pb;

	[OptionalField]
	public int quickRestart;

	[OptionalField]
	public int goldCloth;

	public PlayerData()
	{
		position = new float[2];
		position[0] = 1.7f;
		position[1] = -4f;
		hand_r_pos = new float[2];
		hand_r_pos[0] = position[0] + 0.5f;
		hand_r_pos[1] = position[1] + 1.5f;
		hand_l_pos = new float[2];
		hand_l_pos[0] = position[0] - 0.5f;
		hand_l_pos[1] = position[1] + 1.5f;
		isNewGame = true;
		items = 0;
		goldCloth = 0;
		clears = 0;
		time = 0f;
		pb = 0f;
		quickRestart = 0;
	}
}
