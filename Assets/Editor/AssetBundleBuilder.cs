using UnityEditor;
using UnityEngine;
using System.IO;

public class AssetBundleBuilder : EditorWindow
{
    private string assetBundleName = "MyAssetBundle";
    private string outputPath = "";

    private const string AssetBundleNameKey = "AssetBundleBuilder_AssetBundleName";
    private const string OutputPathKey = "AssetBundleBuilder_OutputPath";

    [MenuItem("Map Tools/Build AssetBundle")]
    public static void ShowWindow()
    {
        AssetBundleBuilder window = EditorWindow.GetWindow<AssetBundleBuilder>();
        window.LoadSettings();
        window.Show();
    }

    private void OnGUI()
    {
        GUILayout.Label("AssetBundle Settings", EditorStyles.boldLabel);

        assetBundleName = EditorGUILayout.TextField("AssetBundle Name:", assetBundleName);
        outputPath = EditorGUILayout.TextField("Output Path:", outputPath);

        if (GUILayout.Button("Build AssetBundle"))
        {
            BuildAssetBundle();
        }

        if (GUILayout.Button("Select Output Folder"))
        {
            string selectedPath = EditorUtility.OpenFolderPanel("Select Output Folder", "", "");
            if (!string.IsNullOrEmpty(selectedPath))
            {
                outputPath = selectedPath + "/";
                SaveSettings();
                GUI.FocusControl(null); // Remove focus from the text field to trigger repaint
            }
        }
    }

    private void BuildAssetBundle()
    {
        if (string.IsNullOrEmpty(outputPath))
        {
            Debug.LogError("Output path is not set.");
            return;
        }

        string path = outputPath + assetBundleName + ".unity3d";
        string[] assets = AssetDatabase.GetAssetPathsFromAssetBundle(assetBundleName);

        if (assets.Length == 0)
        {
            Debug.LogWarning("No assets found for the specified AssetBundle name: " + assetBundleName);
            return;
        }

        AssetBundleBuild[] assetBundleBuilds = new AssetBundleBuild[1];
        assetBundleBuilds[0].assetBundleName = assetBundleName;
        assetBundleBuilds[0].assetNames = assets;

        BuildPipeline.BuildAssetBundles(outputPath, assetBundleBuilds, BuildAssetBundleOptions.None, EditorUserBuildSettings.activeBuildTarget);

        Debug.Log("AssetBundle built to: " + path);

        // Delete manifest file
        string manifestPath = path + ".manifest";
        if (File.Exists(manifestPath))
        {
            File.Delete(manifestPath);
            Debug.Log("Manifest file deleted: " + manifestPath);
        }
        else
        {
            Debug.Log("Manifest file not found: " + manifestPath);
        }
    }

    private void SaveSettings()
    {
        EditorPrefs.SetString(OutputPathKey, outputPath);
        EditorPrefs.SetString(AssetBundleNameKey, assetBundleName);
    }

    private void LoadSettings()
    {
        outputPath = EditorPrefs.GetString(OutputPathKey, "");
        assetBundleName = EditorPrefs.GetString(AssetBundleNameKey, "MyAssetBundle");
    }

    private void OnDestroy()
    {
        SaveSettings();
    }
}
