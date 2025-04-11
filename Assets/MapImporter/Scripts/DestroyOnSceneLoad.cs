using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using UnityEngine;

public class DestroyOnSceneLoad : MonoBehaviour
{
    public bool isSpawner;
    public bool isCamera;

    private void Awake()
    {
        if (!Application.isEditor)
        {
            if (!isSpawner && !isCamera)
            {
                Destroy(gameObject);
                return;
            }

            if (isSpawner)
            {
                HandleSpawner();
            }
            else if (isCamera)
            {
                HandleCamera();
            }
        }
    }

    private void HandleSpawner()
    {
        Transform spawnTransform = transform;

        Destroy(gameObject);

        GameObject playerSpawn = GameObject.Find("PlayerSpawner");
        playerSpawn.transform.position = spawnTransform.position;
    }

    private void HandleCamera()
    {
        Destroy(gameObject);

        GameObject cameraMain = GameObject.Find("Main Camera");
        if (cameraMain != null)
        {
            // Get the SkyController component
            Component skyController = cameraMain.GetComponent("SkyController");

            if (skyController != null)
            {
                // Destroy the SkyController component
                Destroy(skyController);
            }
            else
            {
                Debug.LogWarning("SkyController component not found on MainCamera.");
            }
        }
        else
        {
            Debug.LogWarning("MainCamera not found in the scene.");
        }
    }
}
