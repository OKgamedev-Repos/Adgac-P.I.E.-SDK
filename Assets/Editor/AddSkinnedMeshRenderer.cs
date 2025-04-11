using System.Linq;
using UnityEditor;
using UnityEngine;

public class AddSkinnedMeshRenderer : EditorWindow
{
    private SkinnedMeshRenderer sourceRenderer;
    private SkinnedMeshRenderer targetRenderer;

    [MenuItem("Tools/Add Skinned Mesh Renderer")]
    private static void ShowWindow()
    {
        GetWindow<AddSkinnedMeshRenderer>("Add Skinned Mesh Renderer");
    }

    private void OnGUI()
    {
        GUILayout.Label("Add Skinned Mesh Renderer", EditorStyles.boldLabel);

        sourceRenderer = (SkinnedMeshRenderer)EditorGUILayout.ObjectField(
            "Source Renderer", sourceRenderer, typeof(SkinnedMeshRenderer), true);

        targetRenderer = (SkinnedMeshRenderer)EditorGUILayout.ObjectField(
            "Target Renderer", targetRenderer, typeof(SkinnedMeshRenderer), true);

        if (GUILayout.Button("Add Renderer"))
        {
            if (sourceRenderer == null || targetRenderer == null)
            {
                Debug.LogError("Both source and target renderers must be assigned!");
                return;
            }

            AddRenderer();
        }
    }

    private void AddRenderer()
    {
        Transform[] sourceBones = sourceRenderer.bones;
        Transform[] targetBones = targetRenderer.bones;

        // Log all source bones
        Debug.Log("Source Bones (" + sourceBones.Length + "): " + string.Join(", ", sourceBones.Select(b => b?.name ?? "null")));

        // Log all target bones
        Debug.Log("Target Bones (" + targetBones.Length + "): " + string.Join(", ", targetBones.Select(b => b?.name ?? "null")));

        // Check bone counts
        if (sourceBones.Length != targetBones.Length)
        {
            Debug.LogError($"Bone counts do not match! Source: {sourceBones.Length}, Target: {targetBones.Length}");
            return;
        }

        // Map bones
        Transform[] mappedBones = new Transform[sourceBones.Length];
        Transform root = targetRenderer.rootBone;

        for (int i = 0; i < sourceBones.Length; i++)
        {
            string boneName = sourceBones[i]?.name;
            if (boneName == null)
            {
                Debug.LogError($"Source bone at index {i} is null!");
                return;
            }

            Transform matchingBone = FindChildByName(root, boneName);
            if (matchingBone == null)
            {
                Debug.LogError($"Bone '{boneName}' not found in the target rig!");
                Debug.LogError($"Issue occurred at index {i}. Source hierarchy might differ from target.");
                return;
            }

            mappedBones[i] = matchingBone;
        }

        // Add the SkinnedMeshRenderer to the target
        GameObject newMeshObject = new GameObject(sourceRenderer.name + "_Copy");
        SkinnedMeshRenderer newRenderer = newMeshObject.AddComponent<SkinnedMeshRenderer>();

        newRenderer.sharedMesh = sourceRenderer.sharedMesh;
        newRenderer.materials = sourceRenderer.sharedMaterials;
        newRenderer.bones = mappedBones;
        newRenderer.rootBone = root;

        // Parent the new SkinnedMeshRenderer to the target GameObject
        newMeshObject.transform.SetParent(targetRenderer.transform, false);

        Debug.Log($"Successfully added SkinnedMeshRenderer from '{sourceRenderer.name}' to '{targetRenderer.name}'.");
    }

    private Transform FindChildByName(Transform parent, string name)
    {
        if (parent.name == name) return parent;

        foreach (Transform child in parent)
        {
            Transform found = FindChildByName(child, name);
            if (found != null) return found;
        }

        return null;
    }
}
