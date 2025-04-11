using System.IO;
using System.Runtime.Serialization.Formatters.Binary;
using UnityEngine;

public static class SaveSystem
{
	private static string GetDataPath()
	{
		return Path.Combine(Application.persistentDataPath, "player.pain");
	}

	public static void InitSaveSystem()
	{
		if (!File.Exists(GetDataPath()))
		{
			NewGame();
		}
	}

	public static void SavePlayer(ClimberMain climberMain)
	{
		BinaryFormatter binaryFormatter = new BinaryFormatter();
		FileStream fileStream = new FileStream(GetDataPath(), FileMode.Create);
		PlayerData graph = new PlayerData();
		binaryFormatter.Serialize(fileStream, graph);
		fileStream.Close();
	}

	public static PlayerData LoadPlayer()
	{
		string dataPath = GetDataPath();
		if (File.Exists(dataPath))
		{
			BinaryFormatter binaryFormatter = new BinaryFormatter();
			FileStream fileStream = new FileStream(dataPath, FileMode.Open);
			PlayerData result = binaryFormatter.Deserialize(fileStream) as PlayerData;
			fileStream.Close();
			return result;
		}
		Debug.LogError("Save file not found in: " + dataPath);
		return null;
	}

	public static void NewGame()
	{
		BinaryFormatter binaryFormatter = new BinaryFormatter();
		FileStream fileStream = new FileStream(GetDataPath(), FileMode.Create);
		PlayerData graph = new PlayerData();
		binaryFormatter.Serialize(fileStream, graph);
		fileStream.Close();
	}
}
