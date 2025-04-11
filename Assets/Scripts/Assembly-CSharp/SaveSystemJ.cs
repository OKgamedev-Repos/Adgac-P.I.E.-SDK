using System;
using System.IO;
using UnityEngine;

public static class SaveSystemJ
{
	private static PlayerData playerData;

	private static int saveSlot = 0;

	public static float startTime = 0f;

	public static float timeFromSave = 0f;

	public static bool timeValid = true;

	public static float timeCompleted;

	private static bool checkPointSave = false;

	private static string GetDataPath()
	{
		if (checkPointSave)
		{
			return Path.Combine(Application.persistentDataPath, "datacp.pain");
		}
		if (saveSlot == 1)
		{
			return Path.Combine(Application.persistentDataPath, "data1.pain");
		}
		if (saveSlot == 2)
		{
			return Path.Combine(Application.persistentDataPath, "data2.pain");
		}
		return Path.Combine(Application.persistentDataPath, "data.pain");
	}

	private static string GetSlotPath()
	{
		return Path.Combine(Application.persistentDataPath, "current.slot");
	}

	public static void InitSaveSystem()
	{
		saveSlot = 0;
		LoadSaveSlot();
		playerData = new PlayerData();
		LoadPlayer();
		timeFromSave = playerData.time;
		if (!playerData.isNewGame && playerData.time == 0f)
		{
			timeValid = false;
		}
	}

	private static void IncrementSaveSlot()
	{
		if (saveSlot < 2)
		{
			saveSlot++;
		}
		else
		{
			saveSlot = 0;
		}
	}

	private static void LoadSaveSlot()
	{
		if (File.Exists(GetSlotPath()))
		{
			if (File.ReadAllText(GetSlotPath()) == "1")
			{
				saveSlot = 1;
			}
			else if (File.ReadAllText(GetSlotPath()) == "2")
			{
				saveSlot = 2;
			}
		}
	}

	public static void SavePlayer(ClimberMain climberMain, bool checkpoint = false)
	{
		checkPointSave = false;
		if (playerData == null)
		{
			playerData = new PlayerData();
		}
		playerData.position = new float[2];
		playerData.position[0] = climberMain.body.transform.position.x;
		playerData.position[1] = climberMain.body.transform.position.y;
		playerData.rotation = climberMain.body.transform.eulerAngles.z;
		playerData.hand_r_pos = new float[2];
		playerData.hand_r_pos[0] = climberMain.arm_Right.hand.position.x;
		playerData.hand_r_pos[1] = climberMain.arm_Right.hand.position.y;
		playerData.hand_l_pos = new float[2];
		playerData.hand_l_pos[0] = climberMain.arm_Left.hand.position.x;
		playerData.hand_l_pos[1] = climberMain.arm_Left.hand.position.y;
		playerData.isNewGame = false;
		if (timeValid)
		{
			playerData.time = Time.time + timeFromSave - startTime;
		}
		if (checkpoint)
		{
			checkPointSave = true;
		}
		SaveToFile();
		if (checkpoint)
		{
			checkPointSave = false;
		}
	}

	public static void IncrementItemCount()
	{
		if (playerData == null)
		{
			LoadPlayer();
		}
		if (playerData.giftClaimed == 0)
		{
			playerData.items = 1;
			if (playerData.clears >= 49)
			{
				playerData.goldCloth = 1;
			}
		}
		playerData.giftClaimed = 1;
		SaveToFile();
	}

	public static void ClearGame()
	{
		if (timeValid && timeCompleted != 0f && (playerData.pb > timeCompleted || playerData.pb == 0f))
		{
			playerData.pb = timeCompleted;
		}
		playerData.giftClaimed = 0;
		playerData.clears++;
		SaveToFile();
	}

	public static void NewGame(bool quickrestart, bool cleared = false)
	{
		playerData.position = new float[2];
		playerData.position[0] = 1.7f;
		playerData.position[1] = -4f;
		playerData.rotation = 0f;
		playerData.hand_r_pos = new float[2];
		playerData.hand_r_pos[0] = playerData.position[0] + 0.5f;
		playerData.hand_r_pos[1] = playerData.position[1] + 1.5f;
		playerData.hand_l_pos = new float[2];
		playerData.hand_l_pos[0] = playerData.position[0] - 0.5f;
		playerData.hand_l_pos[1] = playerData.position[1] + 1.5f;
		playerData.isNewGame = true;
		playerData.giftClaimed = 0;
		if (cleared)
		{
			playerData.clears++;
		}
		if (quickrestart)
		{
			playerData.quickRestart = 1;
		}
		else
		{
			playerData.quickRestart = 0;
		}
		playerData.time = 0f;
		timeValid = true;
		SaveToFile();
	}

	public static PlayerData LoadPlayer()
	{
		checkPointSave = false;
		for (int i = 0; i < 4; i++)
		{
			if (File.Exists(GetDataPath()))
			{
				try
				{
					string data = "";
					using (FileStream stream = new FileStream(GetDataPath(), FileMode.Open))
					{
						using StreamReader streamReader = new StreamReader(stream);
						data = streamReader.ReadToEnd();
					}
					data = EncryptDecrypt(data);
					playerData = JsonUtility.FromJson<PlayerData>(data);
					return playerData;
				}
				catch (Exception ex)
				{
					Debug.LogError("Error loading data file: " + GetDataPath() + "\n" + ex);
				}
			}
			if (i < 2)
			{
				IncrementSaveSlot();
			}
			else
			{
				checkPointSave = true;
			}
		}
		Debug.LogError("Could not find save data files.");
		return null;
	}

	public static PlayerData GetPlayerData()
	{
		return playerData;
	}

	public static void SaveToFile()
	{
		IncrementSaveSlot();
		try
		{
			Directory.CreateDirectory(Path.GetDirectoryName(GetDataPath()));
			string data = JsonUtility.ToJson(playerData, prettyPrint: true);
			data = EncryptDecrypt(data);
			using FileStream stream = new FileStream(GetDataPath(), FileMode.Create);
			using StreamWriter streamWriter = new StreamWriter(stream);
			streamWriter.Write(data);
		}
		catch (Exception ex)
		{
			Debug.LogError("Error saving data to file: " + GetDataPath() + "\n" + ex);
		}
		try
		{
			Directory.CreateDirectory(Path.GetDirectoryName(GetSlotPath()));
			File.WriteAllText(GetSlotPath(), saveSlot.ToString());
		}
		catch (Exception ex2)
		{
			Debug.LogError("Error saving SLOT file: " + GetDataPath() + "\n" + ex2);
		}
	}

	private static string EncryptDecrypt(string data)
	{
		string text = "";
		string text2 = "gitgud";
		for (int i = 0; i < data.Length; i++)
		{
			text += (char)(data[i] ^ text2[i % text2.Length]);
		}
		return text;
	}

	public static void SetCompleteTime()
	{
		timeCompleted = Time.time + timeFromSave - startTime;
	}

	public static void ResetPersonalBest()
	{
		playerData.pb = 0f;
		SaveToFile();
	}
}
