using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SpawnLocationScript : MonoBehaviour
{
    void Awake()
    {
        SetSpawnPoint();
        Transform visual = transform.GetChild(0);
        visual.gameObject.SetActive(false);
    }

    public void SetSpawnPoint()
    {
        PlayerData playerData = SaveSystemJ.GetPlayerData();
        if (playerData != null)
        {
            playerData.position = new float[2] { transform.position.x, transform.position.y };
        }
        else
        {
            playerData = new PlayerData();
            playerData.position = new float[2] { transform.position.x, transform.position.y };
        }
        playerData.hand_r_pos = new float[2];
        playerData.hand_r_pos[0] = playerData.position[0] + 0.5f;
        playerData.hand_r_pos[1] = playerData.position[1] + 1.5f;
        playerData.hand_l_pos = new float[2];
        playerData.hand_l_pos[0] = playerData.position[0] - 0.5f;
        playerData.hand_l_pos[1] = playerData.position[1] + 1.5f;
    }
}
