using UnityEngine;
using UnityEngine.Rendering;

[ExecuteAlways]
public class SceneColorSetup : MonoBehaviour
{
	private Camera cam;

	private CommandBuffer cmd;

	private CommandBuffer cmd2;

	private void OnEnable()
	{
		cam = GetComponent<Camera>();
		int num = Shader.PropertyToID("_CameraOpaqueTexture");
		if (cmd == null)
		{
			cmd = new CommandBuffer();
			cmd.name = "Setup Opaque Texture";
			cmd.GetTemporaryRT(num, cam.pixelWidth, cam.pixelHeight, 0);
			cmd.Blit(null, num);
		}
		if (cmd2 == null)
		{
			cmd2 = new CommandBuffer();
			cmd2.name = "Release Opaque Texture";
			cmd2.ReleaseTemporaryRT(num);
		}
		cam.AddCommandBuffer(CameraEvent.AfterForwardOpaque, cmd);
		cam.AddCommandBuffer(CameraEvent.AfterEverything, cmd2);
	}

	private void Update()
	{
		Input.GetKeyDown(KeyCode.G);
	}

	private void OnDisable()
	{
		cam.RemoveCommandBuffer(CameraEvent.AfterForwardOpaque, cmd);
		cam.RemoveCommandBuffer(CameraEvent.AfterEverything, cmd2);
	}
}
