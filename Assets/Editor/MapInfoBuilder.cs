using System.IO;
using UnityEditor;
using UnityEngine;
using Newtonsoft.Json;

public class MapInfoBuilder : EditorWindow
{
    private string selectedPath = "";
    public string mapName;
    public string mapCreator;
    public string mapDescription;
    public Texture2D mapThumbnail;
    public SceneAsset mapScene;
    private const string prefsKey = "MapInfoBuilderSettings";

    [MenuItem("Map Tools/Generate Map Folder")]
    public static void ShowWindow()
    {
        GetWindow<MapInfoBuilder>("Map Tools - Generate Map Folder");
    }

    private void OnEnable()
    {
        LoadSettings();
    }

    private void OnDisable()
    {
        SaveSettings();
    }

    private void OnGUI()
    {
        GUILayout.Label("Map Information", EditorStyles.boldLabel);

        mapName = EditorGUILayout.TextField("Map Name:", mapName);
        mapCreator = EditorGUILayout.TextField("Map Creator:", mapCreator);

        GUILayout.Label("Map Description:");
        mapDescription = EditorGUILayout.TextArea(mapDescription, GUILayout.Height(60));

        mapThumbnail = (Texture2D)EditorGUILayout.ObjectField("Map Thumbnail:", mapThumbnail, typeof(Texture2D), false);
        mapScene = (SceneAsset)EditorGUILayout.ObjectField("Map Scene:", mapScene, typeof(SceneAsset), false);

        GUILayout.Space(20);
        GUILayout.Label("File Path Selector", EditorStyles.boldLabel);
        EditorGUILayout.LabelField("Selected Path:", selectedPath);

        if (GUILayout.Button("Select Path"))
        {
            string path = EditorUtility.OpenFolderPanel("Select a Folder", "", "");
            if (!string.IsNullOrEmpty(path))
            {
                selectedPath = path;
                Debug.Log($"Selected Path: {selectedPath}");
            }
        }

        GUILayout.Space(10);
        if (GUILayout.Button("Generate Map Folder"))
        {
            GenerateMapFolder();
        }
    }

    private void GenerateMapFolder()
    {
        if (string.IsNullOrEmpty(selectedPath))
        {
            Debug.LogError("No path selected! Please select a folder first.");
            return;
        }

        Debug.Log($"Generating map folder at {selectedPath} with map information.");

        var mapFolder = Directory.CreateDirectory(Path.Combine(selectedPath, mapName));

        var wrapper = new MapInfoWrapper
        {
            mapName = mapName,
            mapCreator = mapCreator,
            mapDescription = mapDescription
        };

        string json = JsonConvert.SerializeObject(wrapper, Formatting.Indented);
        File.WriteAllText(Path.Combine(mapFolder.FullName, "mapInfo.txt"), json);

        CreateThumbnailImage(mapThumbnail);
        BuildSceneAssetBundle();
    }

    private void CreateThumbnailImage(Texture2D texture)
    {
        if (texture != null)
        {
            byte[] textureBytes = texture.EncodeToPNG();
            File.WriteAllBytes(Path.Combine(selectedPath, mapName, "thumbnail.png"), textureBytes);
        }
    }

    private void BuildSceneAssetBundle()
    {
        string scenePath = AssetDatabase.GetAssetPath(mapScene);
        if (!string.IsNullOrEmpty(scenePath))
        {
            AssetImporter assetImporter = AssetImporter.GetAtPath(scenePath);
            assetImporter.assetBundleName = $"{mapName}_assets";

            AssetBundleBuild[] buildMap =
            {
                new AssetBundleBuild
                {
                    assetBundleName = $"{mapName}_assets",
                    assetNames = new[] { scenePath }
                }
            };

            BuildPipeline.BuildAssetBundles(
                Path.Combine(selectedPath, mapName),
                buildMap,
                BuildAssetBundleOptions.None,
                BuildTarget.StandaloneWindows
            );
        }
        else
        {
            Debug.LogError("Scene not found! Ensure it is assigned.");
        }
    }

    private void SaveSettings()
    {
        var settings = new MapInfoWrapper
        {
            mapName = mapName,
            mapCreator = mapCreator,
            mapDescription = mapDescription,
            selectedPath = selectedPath
        };

        string json = JsonConvert.SerializeObject(settings);
        EditorPrefs.SetString(prefsKey, json);
    }

    private void LoadSettings()
    {
        if (EditorPrefs.HasKey(prefsKey))
        {
            string json = EditorPrefs.GetString(prefsKey);
            var settings = JsonConvert.DeserializeObject<MapInfoWrapper>(json);

            mapName = settings.mapName;
            mapCreator = settings.mapCreator;
            mapDescription = settings.mapDescription;
            selectedPath = settings.selectedPath;
        }
    }
}

[System.Serializable]
class MapInfoWrapper
{
    public string mapName;
    public string mapCreator;
    public string mapDescription;
    public string selectedPath;
}
