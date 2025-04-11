using UnityEngine;

public class Water : MonoBehaviour
{
	private BoxCollider2D boxcollider2D;

	private SmoothLineRenderer smoothSurfaceLine;

	private float[] xpositions;

	private float[] ypositions;

	private float[] velocities;

	private float[] accelerations;

	private Vector3[] vertices;

	private Vector3[] vertices_3d;

	private GameObject colliderObject;

	private Mesh mesh;

	private GameObject meshObject;

	public GameObject watermesh;

	private GameObject meshObject3d;

	private Mesh mesh_3d;

	public GameObject watermesh3d;

	public ParticleSystem splash;

	public Material mat;

	public Material underwater;

	[SerializeField]
	private Color surfaceAlbeto;

	[SerializeField]
	private int zSize = 2;

	[SerializeField]
	private float wavesDamping = 6f;

	[SerializeField]
	private bool Use3dWater = true;

	[SerializeField]
	private bool UseSurfaceLine = true;

	private const float springconstant = 0.02f;

	private const float damping = 0.05f;

	private const float spread = 0.002f;

	[SerializeField]
	private float zPos = 0.25f;

	private const float cameraZeroPlane = 0.25f;

	private const int segments = 6;

	private float surfacePosY;

	private int edgecount;

	private float baseheight;

	private float left;

	private float bottom;

	private float[] leftDeltas;

	private float[] rightDeltas;

	private void Start()
	{
		boxcollider2D = GetComponent<BoxCollider2D>();
		edgecount = Mathf.RoundToInt(boxcollider2D.size.x) * 6;
		SpawnWater(base.transform.position.x - boxcollider2D.size.x / 2f, boxcollider2D.size.x, base.transform.position.y + boxcollider2D.size.y / 2f, base.transform.position.y - boxcollider2D.size.y / 2f);
		surfacePosY = base.transform.position.y + boxcollider2D.size.y / 2f;
	}

	public void Splash(float xpos, float velocity)
	{
		if (xpos >= xpositions[0] && xpos <= xpositions[xpositions.Length - 1])
		{
			xpos -= xpositions[0];
			int num = Mathf.RoundToInt((float)(xpositions.Length - 1) * (xpos / (xpositions[xpositions.Length - 1] - xpositions[0])));
			velocities[num] += Mathf.Clamp(velocity * 0.2f, -0.1f, 0.02f);
			if (num > 0)
			{
				velocities[num - 1] += Mathf.Clamp(velocity * 0.1f, -0.1f, 0.02f);
			}
			if (num < xpositions.Length - 1)
			{
				velocities[num + 1] += Mathf.Clamp(velocity * 0.1f, -0.1f, 0.02f);
			}
			if (velocity < -1f)
			{
				Object.Instantiate(splash, new Vector3(xpositions[num], surfacePosY - 0.2f, -3f), base.transform.rotation);
			}
		}
	}

	public void SpawnWater(float left, float width, float top, float bottom)
	{
		surfacePosY = top;
		int num = Mathf.RoundToInt(width) * 6;
		int num2 = num + 1;
		smoothSurfaceLine = base.gameObject.AddComponent<SmoothLineRenderer>();
		smoothSurfaceLine.InitLineRenderer(num2, mat);
		xpositions = new float[num2];
		ypositions = new float[num2];
		velocities = new float[num2];
		accelerations = new float[num2];
		leftDeltas = new float[xpositions.Length];
		rightDeltas = new float[xpositions.Length];
		baseheight = top;
		this.bottom = bottom;
		this.left = left;
		for (int i = 0; i < num2; i++)
		{
			ypositions[i] = top;
			xpositions[i] = left + width * (float)i / (float)num;
			accelerations[i] = 0f;
			velocities[i] = 0f;
		}
		mesh = new Mesh();
		meshObject = Object.Instantiate(watermesh, Vector3.zero, Quaternion.identity);
		meshObject.GetComponent<MeshFilter>().mesh = mesh;
		meshObject.transform.parent = base.transform;
		meshObject.GetComponent<MeshRenderer>().material = underwater;
		vertices = new Vector3[num2 * 2];
		int num3 = 0;
		for (int j = 0; j <= 1; j++)
		{
			for (int k = 0; k <= num; k++)
			{
				vertices[num3] = new Vector3(xpositions[k], this.bottom + boxcollider2D.size.y * (float)j, zPos);
				num3++;
			}
		}
		int[] array = new int[num * 6];
		int num4 = 0;
		int num5 = 0;
		for (int l = 0; l < num; l++)
		{
			array[num5] = num4;
			array[1 + num5] = num4 + num2;
			array[2 + num5] = num4 + 1;
			array[3 + num5] = num4 + 1;
			array[4 + num5] = num4 + num2;
			array[5 + num5] = num4 + num2 + 1;
			num4++;
			num5 += 6;
		}
		Vector2[] array2 = new Vector2[vertices.Length];
		int num6 = 0;
		for (int m = 0; m <= 1; m++)
		{
			for (int n = 0; n <= num; n++)
			{
				array2[num6] = new Vector2(n / num, m);
				num6++;
			}
		}
		mesh.vertices = vertices;
		mesh.triangles = array;
		mesh.uv = array2;
		mesh.RecalculateNormals();
		colliderObject = new GameObject();
		colliderObject.name = "WaterTriggerCollider";
		colliderObject.AddComponent<BoxCollider2D>();
		colliderObject.transform.parent = base.transform;
		colliderObject.transform.position = base.transform.position;
		colliderObject.GetComponent<BoxCollider2D>().size = new Vector2(width, top - bottom);
		colliderObject.GetComponent<BoxCollider2D>().isTrigger = true;
		colliderObject.AddComponent<WaterDetector>();
		if (!Use3dWater)
		{
			return;
		}
		vertices_3d = new Vector3[(num + 1) * (zSize + 1)];
		mesh_3d = new Mesh();
		meshObject3d = Object.Instantiate(watermesh3d, Vector3.zero, Quaternion.identity);
		meshObject3d.GetComponent<MeshFilter>().mesh = mesh_3d;
		meshObject3d.transform.parent = base.transform;
		meshObject3d.GetComponent<MeshRenderer>().material.SetColor("_Color", surfaceAlbeto);
		vertices_3d = new Vector3[(num + 1) * (zSize + 1)];
		int num7 = 0;
		for (int num8 = 0; num8 <= zSize; num8++)
		{
			for (int num9 = 0; num9 <= num; num9++)
			{
				vertices_3d[num7] = new Vector3(xpositions[num9], top, 0.25f + (float)num8 / 6f);
				num7++;
			}
		}
		int[] array3 = new int[num * zSize * 6];
		num4 = 0;
		num5 = 0;
		for (int num10 = 0; num10 < zSize; num10++)
		{
			for (int num11 = 0; num11 < num; num11++)
			{
				array3[num5] = num4;
				array3[num5 + 1] = num4 + num + 1;
				array3[num5 + 2] = num4 + 1;
				array3[num5 + 3] = num4 + 1;
				array3[num5 + 4] = num4 + num + 1;
				array3[num5 + 5] = num4 + num + 2;
				num4++;
				num5 += 6;
			}
			num4++;
		}
		array2 = new Vector2[vertices_3d.Length];
		int num12 = 0;
		for (int num13 = 0; num13 <= zSize; num13++)
		{
			for (int num14 = 0; num14 <= num; num14++)
			{
				array2[num12] = new Vector2((float)num14 / 75f, (float)num13 / (float)zSize);
				num12++;
			}
		}
		mesh_3d.Clear();
		mesh_3d.vertices = vertices_3d;
		mesh_3d.triangles = array3;
		mesh_3d.uv = array2;
		mesh_3d.RecalculateNormals();
		Bounds bounds = mesh_3d.bounds;
		bounds.center = new Vector3(bounds.center.x, base.transform.position.y + boxcollider2D.size.y / 2f, bounds.center.z);
		bounds.size = new Vector3(bounds.size.x, 1f, bounds.size.z);
		mesh_3d.bounds = bounds;
	}

	private void FixedUpdate()
	{
		for (int i = 0; i < xpositions.Length; i++)
		{
			float num = 0.02f * (ypositions[i] - baseheight) + velocities[i] * 0.05f;
			accelerations[i] = 0f - num;
			if (Mathf.Abs(velocities[i]) < 0.003f)
			{
				accelerations[i] += Mathf.Sin((float)i * 1.33f + Time.time * 7f) * 0.001f;
				accelerations[i] += Mathf.Sin((float)i * 2f - Time.time * 14f) * 0.0003f;
			}
			ypositions[i] += velocities[i];
			velocities[i] += accelerations[i];
		}
		if (UseSurfaceLine)
		{
			smoothSurfaceLine.UpdatePoints(xpositions, ypositions, zPos + -1f);
		}
		else if (smoothSurfaceLine.enabled)
		{
			smoothSurfaceLine.enabled = false;
		}
		for (int j = 0; j < 8; j++)
		{
			for (int k = 0; k < xpositions.Length; k++)
			{
				if (k > 0)
				{
					leftDeltas[k] = 0.002f * (ypositions[k] - ypositions[k - 1]);
					velocities[k - 1] += leftDeltas[k];
				}
				if (k < xpositions.Length - 1)
				{
					rightDeltas[k] = 0.002f * (ypositions[k] - ypositions[k + 1]);
					velocities[k + 1] += rightDeltas[k];
				}
			}
			for (int l = 0; l < xpositions.Length; l++)
			{
				if (l > 0)
				{
					ypositions[l - 1] += leftDeltas[l];
				}
				if (l < xpositions.Length - 1)
				{
					ypositions[l + 1] += rightDeltas[l];
				}
			}
		}
		UpdateMeshes();
	}

	private void UpdateMeshes()
	{
		for (int i = 0; i <= edgecount; i++)
		{
			vertices[i + edgecount + 1] = new Vector3(xpositions[i], ypositions[i], zPos);
		}
		mesh.vertices = vertices;
		if (!Use3dWater)
		{
			return;
		}
		int num = 0;
		for (int j = 0; j <= zSize; j++)
		{
			for (int k = 0; k <= edgecount; k++)
			{
				int num2 = ((k + j >= ypositions.Length) ? k : (k + j));
				int num3 = ((k - j >= 0) ? (k - j) : k);
				int num4 = ((Mathf.Abs(ypositions[num2] - surfacePosY) > Mathf.Abs(ypositions[num3] - surfacePosY)) ? num3 : num2);
				float y = Mathf.Lerp(ypositions[num4], surfacePosY, (float)j / wavesDamping);
				vertices_3d[num] = new Vector3(xpositions[k], y, 0.25f + (float)j / 6f * 2f);
				num++;
			}
		}
		mesh_3d.vertices = vertices_3d;
		mesh_3d.RecalculateNormals();
	}

	public void SetSurfaceLineEnabled(bool enabled)
	{
		UseSurfaceLine = enabled;
		if (smoothSurfaceLine != null)
		{
			smoothSurfaceLine.EnableLineRenderer(enabled);
		}
	}
}
