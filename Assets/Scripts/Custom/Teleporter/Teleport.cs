using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Reflection;
using UnityEngine;

public class Teleport : MonoBehaviour
{
    public static void TeleportPlayer(Transform target, bool grabL, bool grabR)
    {
        PlayerSpawn playerSpawn = FindObjectOfType<PlayerSpawn>();
        ClimberMain climberMain = FindObjectOfType<ClimberMain>();

        Transform handL = target.GetChild(1);
        Transform handR = target.GetChild(2);

        ReleaseSurface();
        playerSpawn.Respawn(target.position);
        playerSpawn.StartCoroutine(ReleasePlayer(handL, handR, grabL, grabR));
    }

    private static IEnumerator ReleasePlayer(Transform handL, Transform handR, bool grabL, bool grabR)
    {
        yield return new WaitForEndOfFrame();

        ClimberMain climberMain = FindObjectOfType<ClimberMain>();

        climberMain.UnfreezeBody();
        climberMain.arm_Right.listenToInput = true;
        climberMain.arm_Left.listenToInput = true;

        climberMain.arm_Left.SetHandPosition(handL.position);
        climberMain.arm_Right.SetHandPosition(handR.position);

        if(grabL)
        {
            climberMain.arm_Left.ToggleGrab();
        }
        if (grabR)
        {
            climberMain.arm_Right.ToggleGrab();
        }
    }

    private static void ReleaseSurface()
    {
        ClimberMain climberMain = FindObjectOfType<ClimberMain>();
        ArmScript_v2 arm_Left = climberMain.arm_Left;
        ArmScript_v2 arm_Right = climberMain.arm_Right;

        MethodInfo method = arm_Left.GetType().GetMethod("ReleaseSurface",
            BindingFlags.Instance | BindingFlags.NonPublic);

        method.Invoke(arm_Left, new object[] { false, false });
        method.Invoke(arm_Right, new object[] { false, false });

        arm_Left.RemoveFrictionSurface(arm_Left.grabbedSurface);
        arm_Right.RemoveFrictionSurface(arm_Right.grabbedSurface);
    }
}
