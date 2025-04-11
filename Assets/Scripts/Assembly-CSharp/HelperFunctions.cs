using System;
using UnityEngine;

public static class HelperFunctions
{
	public static Vector2 RadianToVector2(float radian)
	{
		return new Vector2(Mathf.Cos(radian), Mathf.Sin(radian));
	}

	public static Vector2 DegreeToVector2(float degree)
	{
		return RadianToVector2(degree * (MathF.PI / 180f));
	}

	public static float Hypot(float sideALength, float sideBLength)
	{
		return Mathf.Sqrt(sideALength * sideALength + sideBLength * sideBLength);
	}

	public static float ClosestTo(float a, float b, float target = 0f)
	{
		if (Mathf.Abs(a - target) < Mathf.Abs(b - target))
		{
			return a;
		}
		return b;
	}
}
