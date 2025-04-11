Shader "DefaultDeformShaderGraph"
{
    Properties
    {
        [NoScaleOffset]_Albedo("Albedo", 2D) = "white" {}
        [Normal][NoScaleOffset]_Normal("Normal", 2D) = "bump" {}
        [NoScaleOffset]_Metallic("Metallic", 2D) = "black" {}
        [NoScaleOffset]_Roughness("Roughness", 2D) = "white" {}
        [NoScaleOffset]_Emission("Emission", 2D) = "black" {}
        [NoScaleOffset]_Occlusion("Occlusion", 2D) = "black" {}
        _HandDistance_L("HandDistance_L", Float) = 1
        _HandDistance_R("HandDistance_R", Float) = 1
        [NonModifiableTextureData][NoScaleOffset]_SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_Texture_1("Texture2D", 2D) = "white" {}
        [HideInInspector]_BUILTIN_QueueOffset("Float", Float) = 0
        [HideInInspector]_BUILTIN_QueueControl("Float", Float) = -1
    }
    SubShader
    {
        Tags
        {
            // RenderPipeline: <None>
            "RenderType"="Opaque"
            "BuiltInMaterialType" = "Lit"
            "Queue"="Geometry"
            "ShaderGraphShader"="true"
            "ShaderGraphTargetId"="BuiltInLitSubTarget"
        }
        Pass
        {
            Stencil
            {
                Ref 2
                Comp Always
                Pass Replace
                Fail Replace
            }

            Name "BuiltIn Forward"
            Tags
            {
                "LightMode" = "ForwardBase"
            }
        
        // Render State
        Cull Back
        Blend One Zero
        ZTest LEqual
        ZWrite On
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 3.0
        #pragma multi_compile_instancing
        #pragma multi_compile_fog
        #pragma multi_compile_fwdbase
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        #pragma multi_compile _ _SCREEN_SPACE_OCCLUSION
        #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
        #pragma multi_compile _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS _ADDITIONAL_OFF
        #pragma multi_compile _ _ADDITIONAL_LIGHT_SHADOWS
        #pragma multi_compile _ _SHADOWS_SOFT
        #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
        #pragma multi_compile _ SHADOWS_SHADOWMASK
        // GraphKeywords: <None>
        
        // Defines
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_VIEWDIRECTION_WS
        #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_FORWARD
        #define BUILTIN_TARGET_API 1
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        #ifdef _BUILTIN_SURFACE_TYPE_TRANSPARENT
        #define _SURFACE_TYPE_TRANSPARENT _BUILTIN_SURFACE_TYPE_TRANSPARENT
        #endif
        #ifdef _BUILTIN_ALPHATEST_ON
        #define _ALPHATEST_ON _BUILTIN_ALPHATEST_ON
        #endif
        #ifdef _BUILTIN_AlphaClip
        #define _AlphaClip _BUILTIN_AlphaClip
        #endif
        #ifdef _BUILTIN_ALPHAPREMULTIPLY_ON
        #define _ALPHAPREMULTIPLY_ON _BUILTIN_ALPHAPREMULTIPLY_ON
        #endif
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Shim/Shims.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/LegacySurfaceVertex.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/ShaderGraphFunctions.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 tangentWS;
             float4 texCoord0;
             float3 viewDirectionWS;
            #if defined(LIGHTMAP_ON)
             float2 lightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh;
            #endif
             float4 fogFactorAndVertexLight;
             float4 shadowCoord;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 TangentSpaceNormal;
             float4 uv0;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 WorldSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 WorldSpaceTangent;
             float3 ObjectSpaceBiTangent;
             float3 WorldSpaceBiTangent;
             float3 ObjectSpacePosition;
             float3 WorldSpacePosition;
             float4 uv0;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float3 interp1 : INTERP1;
             float4 interp2 : INTERP2;
             float4 interp3 : INTERP3;
             float3 interp4 : INTERP4;
             float2 interp5 : INTERP5;
             float3 interp6 : INTERP6;
             float4 interp7 : INTERP7;
             float4 interp8 : INTERP8;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyz =  input.normalWS;
            output.interp2.xyzw =  input.tangentWS;
            output.interp3.xyzw =  input.texCoord0;
            output.interp4.xyz =  input.viewDirectionWS;
            #if defined(LIGHTMAP_ON)
            output.interp5.xy =  input.lightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.interp6.xyz =  input.sh;
            #endif
            output.interp7.xyzw =  input.fogFactorAndVertexLight;
            output.interp8.xyzw =  input.shadowCoord;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.normalWS = input.interp1.xyz;
            output.tangentWS = input.interp2.xyzw;
            output.texCoord0 = input.interp3.xyzw;
            output.viewDirectionWS = input.interp4.xyz;
            #if defined(LIGHTMAP_ON)
            output.lightmapUV = input.interp5.xy;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.interp6.xyz;
            #endif
            output.fogFactorAndVertexLight = input.interp7.xyzw;
            output.shadowCoord = input.interp8.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_Texture_1_TexelSize;
        float4 _Albedo_TexelSize;
        float _HandDistance_L;
        float4 _Normal_TexelSize;
        float4 _Metallic_TexelSize;
        float4 _Roughness_TexelSize;
        float4 _Emission_TexelSize;
        float4 _Occlusion_TexelSize;
        float _HandDistance_R;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_Texture_1);
        SAMPLER(sampler_SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_Texture_1);
        TEXTURE2D(_Albedo);
        SAMPLER(sampler_Albedo);
        TEXTURE2D(_Normal);
        SAMPLER(sampler_Normal);
        TEXTURE2D(_Metallic);
        SAMPLER(sampler_Metallic);
        TEXTURE2D(_Roughness);
        SAMPLER(sampler_Roughness);
        TEXTURE2D(_Emission);
        SAMPLER(sampler_Emission);
        TEXTURE2D(_Occlusion);
        SAMPLER(sampler_Occlusion);
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // Graph Functions
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_OneMinus_float4(float4 In, out float4 Out)
        {
            Out = 1 - In;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            #if defined(SHADER_API_GLES) && (SHADER_TARGET < 30)
              float4 _SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_RGBA_0 = float4(0.0f, 0.0f, 0.0f, 1.0f);
            #else
              float4 _SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_RGBA_0 = SAMPLE_TEXTURE2D_LOD(UnityBuildTexture2DStructNoScale(_SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_Texture_1).tex, UnityBuildTexture2DStructNoScale(_SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_Texture_1).samplerstate, UnityBuildTexture2DStructNoScale(_SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_Texture_1).GetTransformedUV(IN.uv0.xy), 0);
            #endif
            float _SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_R_5 = _SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_RGBA_0.r;
            float _SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_G_6 = _SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_RGBA_0.g;
            float _SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_B_7 = _SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_RGBA_0.b;
            float _SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_A_8 = _SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_RGBA_0.a;
            float _Multiply_3722f1dcbb504b98821a250ed076687d_Out_2;
            Unity_Multiply_float_float(_SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_R_5, 1.3, _Multiply_3722f1dcbb504b98821a250ed076687d_Out_2);
            float _Clamp_835360209d6940809420ab76954e5e36_Out_3;
            Unity_Clamp_float(_Multiply_3722f1dcbb504b98821a250ed076687d_Out_2, 0, 1, _Clamp_835360209d6940809420ab76954e5e36_Out_3);
            float _Property_1c42fce47b3f4b1db15420e92567006d_Out_0 = _HandDistance_L;
            float _Multiply_e4f81bfc79184bd398766f0bf3cf5f00_Out_2;
            Unity_Multiply_float_float(_Clamp_835360209d6940809420ab76954e5e36_Out_3, _Property_1c42fce47b3f4b1db15420e92567006d_Out_0, _Multiply_e4f81bfc79184bd398766f0bf3cf5f00_Out_2);
            float _Multiply_58186ae33c614c29bed49bee32988cd9_Out_2;
            Unity_Multiply_float_float(_SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_G_6, 1.3, _Multiply_58186ae33c614c29bed49bee32988cd9_Out_2);
            float _Clamp_84eee08b18294114ba35fb263e0fe982_Out_3;
            Unity_Clamp_float(_Multiply_58186ae33c614c29bed49bee32988cd9_Out_2, 0, 1, _Clamp_84eee08b18294114ba35fb263e0fe982_Out_3);
            float _Property_96b741f01e574648a09d7b471ae97bae_Out_0 = _HandDistance_R;
            float _Multiply_9066e2b7464c4bbf895c46cc12ad156c_Out_2;
            Unity_Multiply_float_float(_Clamp_84eee08b18294114ba35fb263e0fe982_Out_3, _Property_96b741f01e574648a09d7b471ae97bae_Out_0, _Multiply_9066e2b7464c4bbf895c46cc12ad156c_Out_2);
            float _Add_4373991dbe21413198ca5ded3b50d2f6_Out_2;
            Unity_Add_float(_Multiply_e4f81bfc79184bd398766f0bf3cf5f00_Out_2, _Multiply_9066e2b7464c4bbf895c46cc12ad156c_Out_2, _Add_4373991dbe21413198ca5ded3b50d2f6_Out_2);
            float3 _Vector3_aa5d0d0ece754e84b6089860217831bf_Out_0 = float3(0, 0, _Add_4373991dbe21413198ca5ded3b50d2f6_Out_2);
            float3 _Add_77a2907b2a57445c8f175a25fea45b0c_Out_2;
            Unity_Add_float3(_Vector3_aa5d0d0ece754e84b6089860217831bf_Out_0, IN.WorldSpacePosition, _Add_77a2907b2a57445c8f175a25fea45b0c_Out_2);
            float3 _Transform_a820f406e38f454d87eb4c62cf49bfbf_Out_1 = TransformWorldToObject(_Add_77a2907b2a57445c8f175a25fea45b0c_Out_2.xyz);
            description.Position = _Transform_a820f406e38f454d87eb4c62cf49bfbf_Out_1;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float3 NormalTS;
            float3 Emission;
            float Metallic;
            float Smoothness;
            float Occlusion;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_e991778624504ffda05f55fc103af028_Out_0 = UnityBuildTexture2DStructNoScale(_Albedo);
            float4 _SampleTexture2D_10139d833f154393bcf2cf2ccfcd4113_RGBA_0 = SAMPLE_TEXTURE2D(_Property_e991778624504ffda05f55fc103af028_Out_0.tex, _Property_e991778624504ffda05f55fc103af028_Out_0.samplerstate, _Property_e991778624504ffda05f55fc103af028_Out_0.GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_10139d833f154393bcf2cf2ccfcd4113_R_4 = _SampleTexture2D_10139d833f154393bcf2cf2ccfcd4113_RGBA_0.r;
            float _SampleTexture2D_10139d833f154393bcf2cf2ccfcd4113_G_5 = _SampleTexture2D_10139d833f154393bcf2cf2ccfcd4113_RGBA_0.g;
            float _SampleTexture2D_10139d833f154393bcf2cf2ccfcd4113_B_6 = _SampleTexture2D_10139d833f154393bcf2cf2ccfcd4113_RGBA_0.b;
            float _SampleTexture2D_10139d833f154393bcf2cf2ccfcd4113_A_7 = _SampleTexture2D_10139d833f154393bcf2cf2ccfcd4113_RGBA_0.a;
            UnityTexture2D _Property_1adb468aaedb4e5baa6d8955c85a9cf5_Out_0 = UnityBuildTexture2DStructNoScale(_Normal);
            float4 _SampleTexture2D_d498ae757b6844d898c057015bc62b59_RGBA_0 = SAMPLE_TEXTURE2D(_Property_1adb468aaedb4e5baa6d8955c85a9cf5_Out_0.tex, _Property_1adb468aaedb4e5baa6d8955c85a9cf5_Out_0.samplerstate, _Property_1adb468aaedb4e5baa6d8955c85a9cf5_Out_0.GetTransformedUV(IN.uv0.xy));
            _SampleTexture2D_d498ae757b6844d898c057015bc62b59_RGBA_0.rgb = UnpackNormal(_SampleTexture2D_d498ae757b6844d898c057015bc62b59_RGBA_0);
            float _SampleTexture2D_d498ae757b6844d898c057015bc62b59_R_4 = _SampleTexture2D_d498ae757b6844d898c057015bc62b59_RGBA_0.r;
            float _SampleTexture2D_d498ae757b6844d898c057015bc62b59_G_5 = _SampleTexture2D_d498ae757b6844d898c057015bc62b59_RGBA_0.g;
            float _SampleTexture2D_d498ae757b6844d898c057015bc62b59_B_6 = _SampleTexture2D_d498ae757b6844d898c057015bc62b59_RGBA_0.b;
            float _SampleTexture2D_d498ae757b6844d898c057015bc62b59_A_7 = _SampleTexture2D_d498ae757b6844d898c057015bc62b59_RGBA_0.a;
            UnityTexture2D _Property_72d2e42c3d4f4caa8641fb6fd15fc903_Out_0 = UnityBuildTexture2DStructNoScale(_Emission);
            float4 _SampleTexture2D_c17aa1c69b964772bcdb3e44974660dc_RGBA_0 = SAMPLE_TEXTURE2D(_Property_72d2e42c3d4f4caa8641fb6fd15fc903_Out_0.tex, _Property_72d2e42c3d4f4caa8641fb6fd15fc903_Out_0.samplerstate, _Property_72d2e42c3d4f4caa8641fb6fd15fc903_Out_0.GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_c17aa1c69b964772bcdb3e44974660dc_R_4 = _SampleTexture2D_c17aa1c69b964772bcdb3e44974660dc_RGBA_0.r;
            float _SampleTexture2D_c17aa1c69b964772bcdb3e44974660dc_G_5 = _SampleTexture2D_c17aa1c69b964772bcdb3e44974660dc_RGBA_0.g;
            float _SampleTexture2D_c17aa1c69b964772bcdb3e44974660dc_B_6 = _SampleTexture2D_c17aa1c69b964772bcdb3e44974660dc_RGBA_0.b;
            float _SampleTexture2D_c17aa1c69b964772bcdb3e44974660dc_A_7 = _SampleTexture2D_c17aa1c69b964772bcdb3e44974660dc_RGBA_0.a;
            UnityTexture2D _Property_286ea53ab1b64026a2d006d03e4f81d2_Out_0 = UnityBuildTexture2DStructNoScale(_Metallic);
            float4 _SampleTexture2D_df52417bcc7f46139ad56a542810709f_RGBA_0 = SAMPLE_TEXTURE2D(_Property_286ea53ab1b64026a2d006d03e4f81d2_Out_0.tex, _Property_286ea53ab1b64026a2d006d03e4f81d2_Out_0.samplerstate, _Property_286ea53ab1b64026a2d006d03e4f81d2_Out_0.GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_df52417bcc7f46139ad56a542810709f_R_4 = _SampleTexture2D_df52417bcc7f46139ad56a542810709f_RGBA_0.r;
            float _SampleTexture2D_df52417bcc7f46139ad56a542810709f_G_5 = _SampleTexture2D_df52417bcc7f46139ad56a542810709f_RGBA_0.g;
            float _SampleTexture2D_df52417bcc7f46139ad56a542810709f_B_6 = _SampleTexture2D_df52417bcc7f46139ad56a542810709f_RGBA_0.b;
            float _SampleTexture2D_df52417bcc7f46139ad56a542810709f_A_7 = _SampleTexture2D_df52417bcc7f46139ad56a542810709f_RGBA_0.a;
            UnityTexture2D _Property_0985c7593c924cbfbc046a54e0901caa_Out_0 = UnityBuildTexture2DStructNoScale(_Roughness);
            float4 _SampleTexture2D_717d5678194943b6b3bbc39e67544885_RGBA_0 = SAMPLE_TEXTURE2D(_Property_0985c7593c924cbfbc046a54e0901caa_Out_0.tex, _Property_0985c7593c924cbfbc046a54e0901caa_Out_0.samplerstate, _Property_0985c7593c924cbfbc046a54e0901caa_Out_0.GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_717d5678194943b6b3bbc39e67544885_R_4 = _SampleTexture2D_717d5678194943b6b3bbc39e67544885_RGBA_0.r;
            float _SampleTexture2D_717d5678194943b6b3bbc39e67544885_G_5 = _SampleTexture2D_717d5678194943b6b3bbc39e67544885_RGBA_0.g;
            float _SampleTexture2D_717d5678194943b6b3bbc39e67544885_B_6 = _SampleTexture2D_717d5678194943b6b3bbc39e67544885_RGBA_0.b;
            float _SampleTexture2D_717d5678194943b6b3bbc39e67544885_A_7 = _SampleTexture2D_717d5678194943b6b3bbc39e67544885_RGBA_0.a;
            float4 _OneMinus_38b031183bd24c4d820e4235d7b2f28d_Out_1;
            Unity_OneMinus_float4(_SampleTexture2D_717d5678194943b6b3bbc39e67544885_RGBA_0, _OneMinus_38b031183bd24c4d820e4235d7b2f28d_Out_1);
            UnityTexture2D _Property_7bfa647fbffc455582b42c9d24787717_Out_0 = UnityBuildTexture2DStructNoScale(_Occlusion);
            float4 _SampleTexture2D_defe923be56f4c978caf7581962d38e7_RGBA_0 = SAMPLE_TEXTURE2D(_Property_7bfa647fbffc455582b42c9d24787717_Out_0.tex, _Property_7bfa647fbffc455582b42c9d24787717_Out_0.samplerstate, _Property_7bfa647fbffc455582b42c9d24787717_Out_0.GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_defe923be56f4c978caf7581962d38e7_R_4 = _SampleTexture2D_defe923be56f4c978caf7581962d38e7_RGBA_0.r;
            float _SampleTexture2D_defe923be56f4c978caf7581962d38e7_G_5 = _SampleTexture2D_defe923be56f4c978caf7581962d38e7_RGBA_0.g;
            float _SampleTexture2D_defe923be56f4c978caf7581962d38e7_B_6 = _SampleTexture2D_defe923be56f4c978caf7581962d38e7_RGBA_0.b;
            float _SampleTexture2D_defe923be56f4c978caf7581962d38e7_A_7 = _SampleTexture2D_defe923be56f4c978caf7581962d38e7_RGBA_0.a;
            surface.BaseColor = (_SampleTexture2D_10139d833f154393bcf2cf2ccfcd4113_RGBA_0.xyz);
            surface.NormalTS = (_SampleTexture2D_d498ae757b6844d898c057015bc62b59_RGBA_0.xyz);
            surface.Emission = (_SampleTexture2D_c17aa1c69b964772bcdb3e44974660dc_RGBA_0.xyz);
            surface.Metallic = (_SampleTexture2D_df52417bcc7f46139ad56a542810709f_RGBA_0).x;
            surface.Smoothness = (_OneMinus_38b031183bd24c4d820e4235d7b2f28d_Out_1).x;
            surface.Occlusion = (_SampleTexture2D_defe923be56f4c978caf7581962d38e7_RGBA_0).x;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.WorldSpaceNormal =                           TransformObjectToWorldNormal(input.normalOS);
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.WorldSpaceTangent =                          TransformObjectToWorldDir(input.tangentOS.xyz);
            output.ObjectSpaceBiTangent =                       normalize(cross(input.normalOS, input.tangentOS.xyz) * (input.tangentOS.w > 0.0f ? 1.0f : -1.0f) * GetOddNegativeScale());
            output.WorldSpaceBiTangent =                        TransformObjectToWorldDir(output.ObjectSpaceBiTangent);
            output.ObjectSpacePosition =                        input.positionOS;
            output.WorldSpacePosition =                         TransformObjectToWorld(input.positionOS);
            output.uv0 =                                        input.uv0;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
            
        
        
        
            output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        
        
            output.uv0 = input.texCoord0;
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        void BuildAppDataFull(Attributes attributes, VertexDescription vertexDescription, inout appdata_full result)
        {
            result.vertex     = float4(attributes.positionOS, 1);
            result.tangent    = attributes.tangentOS;
            result.normal     = attributes.normalOS;
            result.texcoord   = attributes.uv0;
            result.texcoord1  = attributes.uv1;
            result.vertex     = float4(vertexDescription.Position, 1);
            result.normal     = vertexDescription.Normal;
            result.tangent    = float4(vertexDescription.Tangent, 0);
            #if UNITY_ANY_INSTANCING_ENABLED
            #endif
        }
        
        void VaryingsToSurfaceVertex(Varyings varyings, inout v2f_surf result)
        {
            result.pos = varyings.positionCS;
            result.worldPos = varyings.positionWS;
            result.worldNormal = varyings.normalWS;
            result.viewDir = varyings.viewDirectionWS;
            // World Tangent isn't an available input on v2f_surf
        
            result._ShadowCoord = varyings.shadowCoord;
        
            #if UNITY_ANY_INSTANCING_ENABLED
            #endif
            #if !defined(LIGHTMAP_ON)
            #if UNITY_SHOULD_SAMPLE_SH
            result.sh = varyings.sh;
            #endif
            #endif
            #if defined(LIGHTMAP_ON)
            result.lmap.xy = varyings.lightmapUV;
            #endif
            #ifdef VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
                result.fogCoord = varyings.fogFactorAndVertexLight.x;
                COPY_TO_LIGHT_COORDS(result, varyings.fogFactorAndVertexLight.yzw);
            #endif
        
            DEFAULT_UNITY_TRANSFER_VERTEX_OUTPUT_STEREO(varyings, result);
        }
        
        void SurfaceVertexToVaryings(v2f_surf surfVertex, inout Varyings result)
        {
            result.positionCS = surfVertex.pos;
            result.positionWS = surfVertex.worldPos;
            result.normalWS = surfVertex.worldNormal;
            // viewDirectionWS is never filled out in the legacy pass' function. Always use the value computed by SRP
            // World Tangent isn't an available input on v2f_surf
            result.shadowCoord = surfVertex._ShadowCoord;
        
            #if UNITY_ANY_INSTANCING_ENABLED
            #endif
            #if !defined(LIGHTMAP_ON)
            #if UNITY_SHOULD_SAMPLE_SH
            result.sh = surfVertex.sh;
            #endif
            #endif
            #if defined(LIGHTMAP_ON)
            result.lightmapUV = surfVertex.lmap.xy;
            #endif
            #ifdef VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
                result.fogFactorAndVertexLight.x = surfVertex.fogCoord;
                COPY_FROM_LIGHT_COORDS(result.fogFactorAndVertexLight.yzw, surfVertex);
            #endif
        
            DEFAULT_UNITY_TRANSFER_VERTEX_OUTPUT_STEREO(surfVertex, result);
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/PBRForwardPass.hlsl"
        
        ENDHLSL
        }
        Pass
        {
            Name "BuiltIn ForwardAdd"
            Tags
            {
                "LightMode" = "ForwardAdd"
            }
        
        // Render State
        Blend SrcAlpha One, One One
        ZWrite Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 3.0
        #pragma multi_compile_instancing
        #pragma multi_compile_fog
        #pragma multi_compile_fwdadd_fullshadows
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        #pragma multi_compile _ _SCREEN_SPACE_OCCLUSION
        #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
        #pragma multi_compile _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS _ADDITIONAL_OFF
        #pragma multi_compile _ _ADDITIONAL_LIGHT_SHADOWS
        #pragma multi_compile _ _SHADOWS_SOFT
        #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
        #pragma multi_compile _ SHADOWS_SHADOWMASK
        // GraphKeywords: <None>
        
        // Defines
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_VIEWDIRECTION_WS
        #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_FORWARD_ADD
        #define BUILTIN_TARGET_API 1
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        #ifdef _BUILTIN_SURFACE_TYPE_TRANSPARENT
        #define _SURFACE_TYPE_TRANSPARENT _BUILTIN_SURFACE_TYPE_TRANSPARENT
        #endif
        #ifdef _BUILTIN_ALPHATEST_ON
        #define _ALPHATEST_ON _BUILTIN_ALPHATEST_ON
        #endif
        #ifdef _BUILTIN_AlphaClip
        #define _AlphaClip _BUILTIN_AlphaClip
        #endif
        #ifdef _BUILTIN_ALPHAPREMULTIPLY_ON
        #define _ALPHAPREMULTIPLY_ON _BUILTIN_ALPHAPREMULTIPLY_ON
        #endif
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Shim/Shims.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/LegacySurfaceVertex.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/ShaderGraphFunctions.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 tangentWS;
             float4 texCoord0;
             float3 viewDirectionWS;
            #if defined(LIGHTMAP_ON)
             float2 lightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh;
            #endif
             float4 fogFactorAndVertexLight;
             float4 shadowCoord;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 TangentSpaceNormal;
             float4 uv0;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 WorldSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 WorldSpaceTangent;
             float3 ObjectSpaceBiTangent;
             float3 WorldSpaceBiTangent;
             float3 ObjectSpacePosition;
             float3 WorldSpacePosition;
             float4 uv0;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float3 interp1 : INTERP1;
             float4 interp2 : INTERP2;
             float4 interp3 : INTERP3;
             float3 interp4 : INTERP4;
             float2 interp5 : INTERP5;
             float3 interp6 : INTERP6;
             float4 interp7 : INTERP7;
             float4 interp8 : INTERP8;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyz =  input.normalWS;
            output.interp2.xyzw =  input.tangentWS;
            output.interp3.xyzw =  input.texCoord0;
            output.interp4.xyz =  input.viewDirectionWS;
            #if defined(LIGHTMAP_ON)
            output.interp5.xy =  input.lightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.interp6.xyz =  input.sh;
            #endif
            output.interp7.xyzw =  input.fogFactorAndVertexLight;
            output.interp8.xyzw =  input.shadowCoord;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.normalWS = input.interp1.xyz;
            output.tangentWS = input.interp2.xyzw;
            output.texCoord0 = input.interp3.xyzw;
            output.viewDirectionWS = input.interp4.xyz;
            #if defined(LIGHTMAP_ON)
            output.lightmapUV = input.interp5.xy;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.interp6.xyz;
            #endif
            output.fogFactorAndVertexLight = input.interp7.xyzw;
            output.shadowCoord = input.interp8.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_Texture_1_TexelSize;
        float4 _Albedo_TexelSize;
        float _HandDistance_L;
        float4 _Normal_TexelSize;
        float4 _Metallic_TexelSize;
        float4 _Roughness_TexelSize;
        float4 _Emission_TexelSize;
        float4 _Occlusion_TexelSize;
        float _HandDistance_R;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_Texture_1);
        SAMPLER(sampler_SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_Texture_1);
        TEXTURE2D(_Albedo);
        SAMPLER(sampler_Albedo);
        TEXTURE2D(_Normal);
        SAMPLER(sampler_Normal);
        TEXTURE2D(_Metallic);
        SAMPLER(sampler_Metallic);
        TEXTURE2D(_Roughness);
        SAMPLER(sampler_Roughness);
        TEXTURE2D(_Emission);
        SAMPLER(sampler_Emission);
        TEXTURE2D(_Occlusion);
        SAMPLER(sampler_Occlusion);
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // Graph Functions
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_OneMinus_float4(float4 In, out float4 Out)
        {
            Out = 1 - In;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            #if defined(SHADER_API_GLES) && (SHADER_TARGET < 30)
              float4 _SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_RGBA_0 = float4(0.0f, 0.0f, 0.0f, 1.0f);
            #else
              float4 _SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_RGBA_0 = SAMPLE_TEXTURE2D_LOD(UnityBuildTexture2DStructNoScale(_SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_Texture_1).tex, UnityBuildTexture2DStructNoScale(_SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_Texture_1).samplerstate, UnityBuildTexture2DStructNoScale(_SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_Texture_1).GetTransformedUV(IN.uv0.xy), 0);
            #endif
            float _SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_R_5 = _SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_RGBA_0.r;
            float _SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_G_6 = _SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_RGBA_0.g;
            float _SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_B_7 = _SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_RGBA_0.b;
            float _SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_A_8 = _SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_RGBA_0.a;
            float _Multiply_3722f1dcbb504b98821a250ed076687d_Out_2;
            Unity_Multiply_float_float(_SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_R_5, 1.3, _Multiply_3722f1dcbb504b98821a250ed076687d_Out_2);
            float _Clamp_835360209d6940809420ab76954e5e36_Out_3;
            Unity_Clamp_float(_Multiply_3722f1dcbb504b98821a250ed076687d_Out_2, 0, 1, _Clamp_835360209d6940809420ab76954e5e36_Out_3);
            float _Property_1c42fce47b3f4b1db15420e92567006d_Out_0 = _HandDistance_L;
            float _Multiply_e4f81bfc79184bd398766f0bf3cf5f00_Out_2;
            Unity_Multiply_float_float(_Clamp_835360209d6940809420ab76954e5e36_Out_3, _Property_1c42fce47b3f4b1db15420e92567006d_Out_0, _Multiply_e4f81bfc79184bd398766f0bf3cf5f00_Out_2);
            float _Multiply_58186ae33c614c29bed49bee32988cd9_Out_2;
            Unity_Multiply_float_float(_SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_G_6, 1.3, _Multiply_58186ae33c614c29bed49bee32988cd9_Out_2);
            float _Clamp_84eee08b18294114ba35fb263e0fe982_Out_3;
            Unity_Clamp_float(_Multiply_58186ae33c614c29bed49bee32988cd9_Out_2, 0, 1, _Clamp_84eee08b18294114ba35fb263e0fe982_Out_3);
            float _Property_96b741f01e574648a09d7b471ae97bae_Out_0 = _HandDistance_R;
            float _Multiply_9066e2b7464c4bbf895c46cc12ad156c_Out_2;
            Unity_Multiply_float_float(_Clamp_84eee08b18294114ba35fb263e0fe982_Out_3, _Property_96b741f01e574648a09d7b471ae97bae_Out_0, _Multiply_9066e2b7464c4bbf895c46cc12ad156c_Out_2);
            float _Add_4373991dbe21413198ca5ded3b50d2f6_Out_2;
            Unity_Add_float(_Multiply_e4f81bfc79184bd398766f0bf3cf5f00_Out_2, _Multiply_9066e2b7464c4bbf895c46cc12ad156c_Out_2, _Add_4373991dbe21413198ca5ded3b50d2f6_Out_2);
            float3 _Vector3_aa5d0d0ece754e84b6089860217831bf_Out_0 = float3(0, 0, _Add_4373991dbe21413198ca5ded3b50d2f6_Out_2);
            float3 _Add_77a2907b2a57445c8f175a25fea45b0c_Out_2;
            Unity_Add_float3(_Vector3_aa5d0d0ece754e84b6089860217831bf_Out_0, IN.WorldSpacePosition, _Add_77a2907b2a57445c8f175a25fea45b0c_Out_2);
            float3 _Transform_a820f406e38f454d87eb4c62cf49bfbf_Out_1 = TransformWorldToObject(_Add_77a2907b2a57445c8f175a25fea45b0c_Out_2.xyz);
            description.Position = _Transform_a820f406e38f454d87eb4c62cf49bfbf_Out_1;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float3 NormalTS;
            float3 Emission;
            float Metallic;
            float Smoothness;
            float Occlusion;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_e991778624504ffda05f55fc103af028_Out_0 = UnityBuildTexture2DStructNoScale(_Albedo);
            float4 _SampleTexture2D_10139d833f154393bcf2cf2ccfcd4113_RGBA_0 = SAMPLE_TEXTURE2D(_Property_e991778624504ffda05f55fc103af028_Out_0.tex, _Property_e991778624504ffda05f55fc103af028_Out_0.samplerstate, _Property_e991778624504ffda05f55fc103af028_Out_0.GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_10139d833f154393bcf2cf2ccfcd4113_R_4 = _SampleTexture2D_10139d833f154393bcf2cf2ccfcd4113_RGBA_0.r;
            float _SampleTexture2D_10139d833f154393bcf2cf2ccfcd4113_G_5 = _SampleTexture2D_10139d833f154393bcf2cf2ccfcd4113_RGBA_0.g;
            float _SampleTexture2D_10139d833f154393bcf2cf2ccfcd4113_B_6 = _SampleTexture2D_10139d833f154393bcf2cf2ccfcd4113_RGBA_0.b;
            float _SampleTexture2D_10139d833f154393bcf2cf2ccfcd4113_A_7 = _SampleTexture2D_10139d833f154393bcf2cf2ccfcd4113_RGBA_0.a;
            UnityTexture2D _Property_1adb468aaedb4e5baa6d8955c85a9cf5_Out_0 = UnityBuildTexture2DStructNoScale(_Normal);
            float4 _SampleTexture2D_d498ae757b6844d898c057015bc62b59_RGBA_0 = SAMPLE_TEXTURE2D(_Property_1adb468aaedb4e5baa6d8955c85a9cf5_Out_0.tex, _Property_1adb468aaedb4e5baa6d8955c85a9cf5_Out_0.samplerstate, _Property_1adb468aaedb4e5baa6d8955c85a9cf5_Out_0.GetTransformedUV(IN.uv0.xy));
            _SampleTexture2D_d498ae757b6844d898c057015bc62b59_RGBA_0.rgb = UnpackNormal(_SampleTexture2D_d498ae757b6844d898c057015bc62b59_RGBA_0);
            float _SampleTexture2D_d498ae757b6844d898c057015bc62b59_R_4 = _SampleTexture2D_d498ae757b6844d898c057015bc62b59_RGBA_0.r;
            float _SampleTexture2D_d498ae757b6844d898c057015bc62b59_G_5 = _SampleTexture2D_d498ae757b6844d898c057015bc62b59_RGBA_0.g;
            float _SampleTexture2D_d498ae757b6844d898c057015bc62b59_B_6 = _SampleTexture2D_d498ae757b6844d898c057015bc62b59_RGBA_0.b;
            float _SampleTexture2D_d498ae757b6844d898c057015bc62b59_A_7 = _SampleTexture2D_d498ae757b6844d898c057015bc62b59_RGBA_0.a;
            UnityTexture2D _Property_72d2e42c3d4f4caa8641fb6fd15fc903_Out_0 = UnityBuildTexture2DStructNoScale(_Emission);
            float4 _SampleTexture2D_c17aa1c69b964772bcdb3e44974660dc_RGBA_0 = SAMPLE_TEXTURE2D(_Property_72d2e42c3d4f4caa8641fb6fd15fc903_Out_0.tex, _Property_72d2e42c3d4f4caa8641fb6fd15fc903_Out_0.samplerstate, _Property_72d2e42c3d4f4caa8641fb6fd15fc903_Out_0.GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_c17aa1c69b964772bcdb3e44974660dc_R_4 = _SampleTexture2D_c17aa1c69b964772bcdb3e44974660dc_RGBA_0.r;
            float _SampleTexture2D_c17aa1c69b964772bcdb3e44974660dc_G_5 = _SampleTexture2D_c17aa1c69b964772bcdb3e44974660dc_RGBA_0.g;
            float _SampleTexture2D_c17aa1c69b964772bcdb3e44974660dc_B_6 = _SampleTexture2D_c17aa1c69b964772bcdb3e44974660dc_RGBA_0.b;
            float _SampleTexture2D_c17aa1c69b964772bcdb3e44974660dc_A_7 = _SampleTexture2D_c17aa1c69b964772bcdb3e44974660dc_RGBA_0.a;
            UnityTexture2D _Property_286ea53ab1b64026a2d006d03e4f81d2_Out_0 = UnityBuildTexture2DStructNoScale(_Metallic);
            float4 _SampleTexture2D_df52417bcc7f46139ad56a542810709f_RGBA_0 = SAMPLE_TEXTURE2D(_Property_286ea53ab1b64026a2d006d03e4f81d2_Out_0.tex, _Property_286ea53ab1b64026a2d006d03e4f81d2_Out_0.samplerstate, _Property_286ea53ab1b64026a2d006d03e4f81d2_Out_0.GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_df52417bcc7f46139ad56a542810709f_R_4 = _SampleTexture2D_df52417bcc7f46139ad56a542810709f_RGBA_0.r;
            float _SampleTexture2D_df52417bcc7f46139ad56a542810709f_G_5 = _SampleTexture2D_df52417bcc7f46139ad56a542810709f_RGBA_0.g;
            float _SampleTexture2D_df52417bcc7f46139ad56a542810709f_B_6 = _SampleTexture2D_df52417bcc7f46139ad56a542810709f_RGBA_0.b;
            float _SampleTexture2D_df52417bcc7f46139ad56a542810709f_A_7 = _SampleTexture2D_df52417bcc7f46139ad56a542810709f_RGBA_0.a;
            UnityTexture2D _Property_0985c7593c924cbfbc046a54e0901caa_Out_0 = UnityBuildTexture2DStructNoScale(_Roughness);
            float4 _SampleTexture2D_717d5678194943b6b3bbc39e67544885_RGBA_0 = SAMPLE_TEXTURE2D(_Property_0985c7593c924cbfbc046a54e0901caa_Out_0.tex, _Property_0985c7593c924cbfbc046a54e0901caa_Out_0.samplerstate, _Property_0985c7593c924cbfbc046a54e0901caa_Out_0.GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_717d5678194943b6b3bbc39e67544885_R_4 = _SampleTexture2D_717d5678194943b6b3bbc39e67544885_RGBA_0.r;
            float _SampleTexture2D_717d5678194943b6b3bbc39e67544885_G_5 = _SampleTexture2D_717d5678194943b6b3bbc39e67544885_RGBA_0.g;
            float _SampleTexture2D_717d5678194943b6b3bbc39e67544885_B_6 = _SampleTexture2D_717d5678194943b6b3bbc39e67544885_RGBA_0.b;
            float _SampleTexture2D_717d5678194943b6b3bbc39e67544885_A_7 = _SampleTexture2D_717d5678194943b6b3bbc39e67544885_RGBA_0.a;
            float4 _OneMinus_38b031183bd24c4d820e4235d7b2f28d_Out_1;
            Unity_OneMinus_float4(_SampleTexture2D_717d5678194943b6b3bbc39e67544885_RGBA_0, _OneMinus_38b031183bd24c4d820e4235d7b2f28d_Out_1);
            UnityTexture2D _Property_7bfa647fbffc455582b42c9d24787717_Out_0 = UnityBuildTexture2DStructNoScale(_Occlusion);
            float4 _SampleTexture2D_defe923be56f4c978caf7581962d38e7_RGBA_0 = SAMPLE_TEXTURE2D(_Property_7bfa647fbffc455582b42c9d24787717_Out_0.tex, _Property_7bfa647fbffc455582b42c9d24787717_Out_0.samplerstate, _Property_7bfa647fbffc455582b42c9d24787717_Out_0.GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_defe923be56f4c978caf7581962d38e7_R_4 = _SampleTexture2D_defe923be56f4c978caf7581962d38e7_RGBA_0.r;
            float _SampleTexture2D_defe923be56f4c978caf7581962d38e7_G_5 = _SampleTexture2D_defe923be56f4c978caf7581962d38e7_RGBA_0.g;
            float _SampleTexture2D_defe923be56f4c978caf7581962d38e7_B_6 = _SampleTexture2D_defe923be56f4c978caf7581962d38e7_RGBA_0.b;
            float _SampleTexture2D_defe923be56f4c978caf7581962d38e7_A_7 = _SampleTexture2D_defe923be56f4c978caf7581962d38e7_RGBA_0.a;
            surface.BaseColor = (_SampleTexture2D_10139d833f154393bcf2cf2ccfcd4113_RGBA_0.xyz);
            surface.NormalTS = (_SampleTexture2D_d498ae757b6844d898c057015bc62b59_RGBA_0.xyz);
            surface.Emission = (_SampleTexture2D_c17aa1c69b964772bcdb3e44974660dc_RGBA_0.xyz);
            surface.Metallic = (_SampleTexture2D_df52417bcc7f46139ad56a542810709f_RGBA_0).x;
            surface.Smoothness = (_OneMinus_38b031183bd24c4d820e4235d7b2f28d_Out_1).x;
            surface.Occlusion = (_SampleTexture2D_defe923be56f4c978caf7581962d38e7_RGBA_0).x;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.WorldSpaceNormal =                           TransformObjectToWorldNormal(input.normalOS);
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.WorldSpaceTangent =                          TransformObjectToWorldDir(input.tangentOS.xyz);
            output.ObjectSpaceBiTangent =                       normalize(cross(input.normalOS, input.tangentOS.xyz) * (input.tangentOS.w > 0.0f ? 1.0f : -1.0f) * GetOddNegativeScale());
            output.WorldSpaceBiTangent =                        TransformObjectToWorldDir(output.ObjectSpaceBiTangent);
            output.ObjectSpacePosition =                        input.positionOS;
            output.WorldSpacePosition =                         TransformObjectToWorld(input.positionOS);
            output.uv0 =                                        input.uv0;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
            
        
        
        
            output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        
        
            output.uv0 = input.texCoord0;
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        void BuildAppDataFull(Attributes attributes, VertexDescription vertexDescription, inout appdata_full result)
        {
            result.vertex     = float4(attributes.positionOS, 1);
            result.tangent    = attributes.tangentOS;
            result.normal     = attributes.normalOS;
            result.texcoord   = attributes.uv0;
            result.texcoord1  = attributes.uv1;
            result.vertex     = float4(vertexDescription.Position, 1);
            result.normal     = vertexDescription.Normal;
            result.tangent    = float4(vertexDescription.Tangent, 0);
            #if UNITY_ANY_INSTANCING_ENABLED
            #endif
        }
        
        void VaryingsToSurfaceVertex(Varyings varyings, inout v2f_surf result)
        {
            result.pos = varyings.positionCS;
            result.worldPos = varyings.positionWS;
            result.worldNormal = varyings.normalWS;
            result.viewDir = varyings.viewDirectionWS;
            // World Tangent isn't an available input on v2f_surf
        
            result._ShadowCoord = varyings.shadowCoord;
        
            #if UNITY_ANY_INSTANCING_ENABLED
            #endif
            #if !defined(LIGHTMAP_ON)
            #if UNITY_SHOULD_SAMPLE_SH
            result.sh = varyings.sh;
            #endif
            #endif
            #if defined(LIGHTMAP_ON)
            result.lmap.xy = varyings.lightmapUV;
            #endif
            #ifdef VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
                result.fogCoord = varyings.fogFactorAndVertexLight.x;
                COPY_TO_LIGHT_COORDS(result, varyings.fogFactorAndVertexLight.yzw);
            #endif
        
            DEFAULT_UNITY_TRANSFER_VERTEX_OUTPUT_STEREO(varyings, result);
        }
        
        void SurfaceVertexToVaryings(v2f_surf surfVertex, inout Varyings result)
        {
            result.positionCS = surfVertex.pos;
            result.positionWS = surfVertex.worldPos;
            result.normalWS = surfVertex.worldNormal;
            // viewDirectionWS is never filled out in the legacy pass' function. Always use the value computed by SRP
            // World Tangent isn't an available input on v2f_surf
            result.shadowCoord = surfVertex._ShadowCoord;
        
            #if UNITY_ANY_INSTANCING_ENABLED
            #endif
            #if !defined(LIGHTMAP_ON)
            #if UNITY_SHOULD_SAMPLE_SH
            result.sh = surfVertex.sh;
            #endif
            #endif
            #if defined(LIGHTMAP_ON)
            result.lightmapUV = surfVertex.lmap.xy;
            #endif
            #ifdef VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
                result.fogFactorAndVertexLight.x = surfVertex.fogCoord;
                COPY_FROM_LIGHT_COORDS(result.fogFactorAndVertexLight.yzw, surfVertex);
            #endif
        
            DEFAULT_UNITY_TRANSFER_VERTEX_OUTPUT_STEREO(surfVertex, result);
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/PBRForwardAddPass.hlsl"
        
        ENDHLSL
        }
        Pass
        {
            Name "BuiltIn Deferred"
            Tags
            {
                "LightMode" = "Deferred"
            }
        
        // Render State
        Cull Back
        Blend One Zero
        ZTest LEqual
        ZWrite On
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 4.5
        #pragma multi_compile_instancing
        #pragma exclude_renderers nomrt
        #pragma multi_compile_prepassfinal
        #pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
        #pragma multi_compile _ _SHADOWS_SOFT
        #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
        #pragma multi_compile _ _MIXED_LIGHTING_SUBTRACTIVE
        #pragma multi_compile _ _GBUFFER_NORMALS_OCT
        // GraphKeywords: <None>
        
        // Defines
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_VIEWDIRECTION_WS
        #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEFERRED
        #define BUILTIN_TARGET_API 1
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        #ifdef _BUILTIN_SURFACE_TYPE_TRANSPARENT
        #define _SURFACE_TYPE_TRANSPARENT _BUILTIN_SURFACE_TYPE_TRANSPARENT
        #endif
        #ifdef _BUILTIN_ALPHATEST_ON
        #define _ALPHATEST_ON _BUILTIN_ALPHATEST_ON
        #endif
        #ifdef _BUILTIN_AlphaClip
        #define _AlphaClip _BUILTIN_AlphaClip
        #endif
        #ifdef _BUILTIN_ALPHAPREMULTIPLY_ON
        #define _ALPHAPREMULTIPLY_ON _BUILTIN_ALPHAPREMULTIPLY_ON
        #endif
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Shim/Shims.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/LegacySurfaceVertex.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/ShaderGraphFunctions.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 tangentWS;
             float4 texCoord0;
             float3 viewDirectionWS;
            #if defined(LIGHTMAP_ON)
             float2 lightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh;
            #endif
             float4 fogFactorAndVertexLight;
             float4 shadowCoord;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 TangentSpaceNormal;
             float4 uv0;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 WorldSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 WorldSpaceTangent;
             float3 ObjectSpaceBiTangent;
             float3 WorldSpaceBiTangent;
             float3 ObjectSpacePosition;
             float3 WorldSpacePosition;
             float4 uv0;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float3 interp1 : INTERP1;
             float4 interp2 : INTERP2;
             float4 interp3 : INTERP3;
             float3 interp4 : INTERP4;
             float2 interp5 : INTERP5;
             float3 interp6 : INTERP6;
             float4 interp7 : INTERP7;
             float4 interp8 : INTERP8;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyz =  input.normalWS;
            output.interp2.xyzw =  input.tangentWS;
            output.interp3.xyzw =  input.texCoord0;
            output.interp4.xyz =  input.viewDirectionWS;
            #if defined(LIGHTMAP_ON)
            output.interp5.xy =  input.lightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.interp6.xyz =  input.sh;
            #endif
            output.interp7.xyzw =  input.fogFactorAndVertexLight;
            output.interp8.xyzw =  input.shadowCoord;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.normalWS = input.interp1.xyz;
            output.tangentWS = input.interp2.xyzw;
            output.texCoord0 = input.interp3.xyzw;
            output.viewDirectionWS = input.interp4.xyz;
            #if defined(LIGHTMAP_ON)
            output.lightmapUV = input.interp5.xy;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.interp6.xyz;
            #endif
            output.fogFactorAndVertexLight = input.interp7.xyzw;
            output.shadowCoord = input.interp8.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_Texture_1_TexelSize;
        float4 _Albedo_TexelSize;
        float _HandDistance_L;
        float4 _Normal_TexelSize;
        float4 _Metallic_TexelSize;
        float4 _Roughness_TexelSize;
        float4 _Emission_TexelSize;
        float4 _Occlusion_TexelSize;
        float _HandDistance_R;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_Texture_1);
        SAMPLER(sampler_SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_Texture_1);
        TEXTURE2D(_Albedo);
        SAMPLER(sampler_Albedo);
        TEXTURE2D(_Normal);
        SAMPLER(sampler_Normal);
        TEXTURE2D(_Metallic);
        SAMPLER(sampler_Metallic);
        TEXTURE2D(_Roughness);
        SAMPLER(sampler_Roughness);
        TEXTURE2D(_Emission);
        SAMPLER(sampler_Emission);
        TEXTURE2D(_Occlusion);
        SAMPLER(sampler_Occlusion);
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // Graph Functions
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_OneMinus_float4(float4 In, out float4 Out)
        {
            Out = 1 - In;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            #if defined(SHADER_API_GLES) && (SHADER_TARGET < 30)
              float4 _SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_RGBA_0 = float4(0.0f, 0.0f, 0.0f, 1.0f);
            #else
              float4 _SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_RGBA_0 = SAMPLE_TEXTURE2D_LOD(UnityBuildTexture2DStructNoScale(_SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_Texture_1).tex, UnityBuildTexture2DStructNoScale(_SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_Texture_1).samplerstate, UnityBuildTexture2DStructNoScale(_SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_Texture_1).GetTransformedUV(IN.uv0.xy), 0);
            #endif
            float _SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_R_5 = _SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_RGBA_0.r;
            float _SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_G_6 = _SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_RGBA_0.g;
            float _SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_B_7 = _SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_RGBA_0.b;
            float _SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_A_8 = _SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_RGBA_0.a;
            float _Multiply_3722f1dcbb504b98821a250ed076687d_Out_2;
            Unity_Multiply_float_float(_SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_R_5, 1.3, _Multiply_3722f1dcbb504b98821a250ed076687d_Out_2);
            float _Clamp_835360209d6940809420ab76954e5e36_Out_3;
            Unity_Clamp_float(_Multiply_3722f1dcbb504b98821a250ed076687d_Out_2, 0, 1, _Clamp_835360209d6940809420ab76954e5e36_Out_3);
            float _Property_1c42fce47b3f4b1db15420e92567006d_Out_0 = _HandDistance_L;
            float _Multiply_e4f81bfc79184bd398766f0bf3cf5f00_Out_2;
            Unity_Multiply_float_float(_Clamp_835360209d6940809420ab76954e5e36_Out_3, _Property_1c42fce47b3f4b1db15420e92567006d_Out_0, _Multiply_e4f81bfc79184bd398766f0bf3cf5f00_Out_2);
            float _Multiply_58186ae33c614c29bed49bee32988cd9_Out_2;
            Unity_Multiply_float_float(_SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_G_6, 1.3, _Multiply_58186ae33c614c29bed49bee32988cd9_Out_2);
            float _Clamp_84eee08b18294114ba35fb263e0fe982_Out_3;
            Unity_Clamp_float(_Multiply_58186ae33c614c29bed49bee32988cd9_Out_2, 0, 1, _Clamp_84eee08b18294114ba35fb263e0fe982_Out_3);
            float _Property_96b741f01e574648a09d7b471ae97bae_Out_0 = _HandDistance_R;
            float _Multiply_9066e2b7464c4bbf895c46cc12ad156c_Out_2;
            Unity_Multiply_float_float(_Clamp_84eee08b18294114ba35fb263e0fe982_Out_3, _Property_96b741f01e574648a09d7b471ae97bae_Out_0, _Multiply_9066e2b7464c4bbf895c46cc12ad156c_Out_2);
            float _Add_4373991dbe21413198ca5ded3b50d2f6_Out_2;
            Unity_Add_float(_Multiply_e4f81bfc79184bd398766f0bf3cf5f00_Out_2, _Multiply_9066e2b7464c4bbf895c46cc12ad156c_Out_2, _Add_4373991dbe21413198ca5ded3b50d2f6_Out_2);
            float3 _Vector3_aa5d0d0ece754e84b6089860217831bf_Out_0 = float3(0, 0, _Add_4373991dbe21413198ca5ded3b50d2f6_Out_2);
            float3 _Add_77a2907b2a57445c8f175a25fea45b0c_Out_2;
            Unity_Add_float3(_Vector3_aa5d0d0ece754e84b6089860217831bf_Out_0, IN.WorldSpacePosition, _Add_77a2907b2a57445c8f175a25fea45b0c_Out_2);
            float3 _Transform_a820f406e38f454d87eb4c62cf49bfbf_Out_1 = TransformWorldToObject(_Add_77a2907b2a57445c8f175a25fea45b0c_Out_2.xyz);
            description.Position = _Transform_a820f406e38f454d87eb4c62cf49bfbf_Out_1;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float3 NormalTS;
            float3 Emission;
            float Metallic;
            float Smoothness;
            float Occlusion;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_e991778624504ffda05f55fc103af028_Out_0 = UnityBuildTexture2DStructNoScale(_Albedo);
            float4 _SampleTexture2D_10139d833f154393bcf2cf2ccfcd4113_RGBA_0 = SAMPLE_TEXTURE2D(_Property_e991778624504ffda05f55fc103af028_Out_0.tex, _Property_e991778624504ffda05f55fc103af028_Out_0.samplerstate, _Property_e991778624504ffda05f55fc103af028_Out_0.GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_10139d833f154393bcf2cf2ccfcd4113_R_4 = _SampleTexture2D_10139d833f154393bcf2cf2ccfcd4113_RGBA_0.r;
            float _SampleTexture2D_10139d833f154393bcf2cf2ccfcd4113_G_5 = _SampleTexture2D_10139d833f154393bcf2cf2ccfcd4113_RGBA_0.g;
            float _SampleTexture2D_10139d833f154393bcf2cf2ccfcd4113_B_6 = _SampleTexture2D_10139d833f154393bcf2cf2ccfcd4113_RGBA_0.b;
            float _SampleTexture2D_10139d833f154393bcf2cf2ccfcd4113_A_7 = _SampleTexture2D_10139d833f154393bcf2cf2ccfcd4113_RGBA_0.a;
            UnityTexture2D _Property_1adb468aaedb4e5baa6d8955c85a9cf5_Out_0 = UnityBuildTexture2DStructNoScale(_Normal);
            float4 _SampleTexture2D_d498ae757b6844d898c057015bc62b59_RGBA_0 = SAMPLE_TEXTURE2D(_Property_1adb468aaedb4e5baa6d8955c85a9cf5_Out_0.tex, _Property_1adb468aaedb4e5baa6d8955c85a9cf5_Out_0.samplerstate, _Property_1adb468aaedb4e5baa6d8955c85a9cf5_Out_0.GetTransformedUV(IN.uv0.xy));
            _SampleTexture2D_d498ae757b6844d898c057015bc62b59_RGBA_0.rgb = UnpackNormal(_SampleTexture2D_d498ae757b6844d898c057015bc62b59_RGBA_0);
            float _SampleTexture2D_d498ae757b6844d898c057015bc62b59_R_4 = _SampleTexture2D_d498ae757b6844d898c057015bc62b59_RGBA_0.r;
            float _SampleTexture2D_d498ae757b6844d898c057015bc62b59_G_5 = _SampleTexture2D_d498ae757b6844d898c057015bc62b59_RGBA_0.g;
            float _SampleTexture2D_d498ae757b6844d898c057015bc62b59_B_6 = _SampleTexture2D_d498ae757b6844d898c057015bc62b59_RGBA_0.b;
            float _SampleTexture2D_d498ae757b6844d898c057015bc62b59_A_7 = _SampleTexture2D_d498ae757b6844d898c057015bc62b59_RGBA_0.a;
            UnityTexture2D _Property_72d2e42c3d4f4caa8641fb6fd15fc903_Out_0 = UnityBuildTexture2DStructNoScale(_Emission);
            float4 _SampleTexture2D_c17aa1c69b964772bcdb3e44974660dc_RGBA_0 = SAMPLE_TEXTURE2D(_Property_72d2e42c3d4f4caa8641fb6fd15fc903_Out_0.tex, _Property_72d2e42c3d4f4caa8641fb6fd15fc903_Out_0.samplerstate, _Property_72d2e42c3d4f4caa8641fb6fd15fc903_Out_0.GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_c17aa1c69b964772bcdb3e44974660dc_R_4 = _SampleTexture2D_c17aa1c69b964772bcdb3e44974660dc_RGBA_0.r;
            float _SampleTexture2D_c17aa1c69b964772bcdb3e44974660dc_G_5 = _SampleTexture2D_c17aa1c69b964772bcdb3e44974660dc_RGBA_0.g;
            float _SampleTexture2D_c17aa1c69b964772bcdb3e44974660dc_B_6 = _SampleTexture2D_c17aa1c69b964772bcdb3e44974660dc_RGBA_0.b;
            float _SampleTexture2D_c17aa1c69b964772bcdb3e44974660dc_A_7 = _SampleTexture2D_c17aa1c69b964772bcdb3e44974660dc_RGBA_0.a;
            UnityTexture2D _Property_286ea53ab1b64026a2d006d03e4f81d2_Out_0 = UnityBuildTexture2DStructNoScale(_Metallic);
            float4 _SampleTexture2D_df52417bcc7f46139ad56a542810709f_RGBA_0 = SAMPLE_TEXTURE2D(_Property_286ea53ab1b64026a2d006d03e4f81d2_Out_0.tex, _Property_286ea53ab1b64026a2d006d03e4f81d2_Out_0.samplerstate, _Property_286ea53ab1b64026a2d006d03e4f81d2_Out_0.GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_df52417bcc7f46139ad56a542810709f_R_4 = _SampleTexture2D_df52417bcc7f46139ad56a542810709f_RGBA_0.r;
            float _SampleTexture2D_df52417bcc7f46139ad56a542810709f_G_5 = _SampleTexture2D_df52417bcc7f46139ad56a542810709f_RGBA_0.g;
            float _SampleTexture2D_df52417bcc7f46139ad56a542810709f_B_6 = _SampleTexture2D_df52417bcc7f46139ad56a542810709f_RGBA_0.b;
            float _SampleTexture2D_df52417bcc7f46139ad56a542810709f_A_7 = _SampleTexture2D_df52417bcc7f46139ad56a542810709f_RGBA_0.a;
            UnityTexture2D _Property_0985c7593c924cbfbc046a54e0901caa_Out_0 = UnityBuildTexture2DStructNoScale(_Roughness);
            float4 _SampleTexture2D_717d5678194943b6b3bbc39e67544885_RGBA_0 = SAMPLE_TEXTURE2D(_Property_0985c7593c924cbfbc046a54e0901caa_Out_0.tex, _Property_0985c7593c924cbfbc046a54e0901caa_Out_0.samplerstate, _Property_0985c7593c924cbfbc046a54e0901caa_Out_0.GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_717d5678194943b6b3bbc39e67544885_R_4 = _SampleTexture2D_717d5678194943b6b3bbc39e67544885_RGBA_0.r;
            float _SampleTexture2D_717d5678194943b6b3bbc39e67544885_G_5 = _SampleTexture2D_717d5678194943b6b3bbc39e67544885_RGBA_0.g;
            float _SampleTexture2D_717d5678194943b6b3bbc39e67544885_B_6 = _SampleTexture2D_717d5678194943b6b3bbc39e67544885_RGBA_0.b;
            float _SampleTexture2D_717d5678194943b6b3bbc39e67544885_A_7 = _SampleTexture2D_717d5678194943b6b3bbc39e67544885_RGBA_0.a;
            float4 _OneMinus_38b031183bd24c4d820e4235d7b2f28d_Out_1;
            Unity_OneMinus_float4(_SampleTexture2D_717d5678194943b6b3bbc39e67544885_RGBA_0, _OneMinus_38b031183bd24c4d820e4235d7b2f28d_Out_1);
            UnityTexture2D _Property_7bfa647fbffc455582b42c9d24787717_Out_0 = UnityBuildTexture2DStructNoScale(_Occlusion);
            float4 _SampleTexture2D_defe923be56f4c978caf7581962d38e7_RGBA_0 = SAMPLE_TEXTURE2D(_Property_7bfa647fbffc455582b42c9d24787717_Out_0.tex, _Property_7bfa647fbffc455582b42c9d24787717_Out_0.samplerstate, _Property_7bfa647fbffc455582b42c9d24787717_Out_0.GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_defe923be56f4c978caf7581962d38e7_R_4 = _SampleTexture2D_defe923be56f4c978caf7581962d38e7_RGBA_0.r;
            float _SampleTexture2D_defe923be56f4c978caf7581962d38e7_G_5 = _SampleTexture2D_defe923be56f4c978caf7581962d38e7_RGBA_0.g;
            float _SampleTexture2D_defe923be56f4c978caf7581962d38e7_B_6 = _SampleTexture2D_defe923be56f4c978caf7581962d38e7_RGBA_0.b;
            float _SampleTexture2D_defe923be56f4c978caf7581962d38e7_A_7 = _SampleTexture2D_defe923be56f4c978caf7581962d38e7_RGBA_0.a;
            surface.BaseColor = (_SampleTexture2D_10139d833f154393bcf2cf2ccfcd4113_RGBA_0.xyz);
            surface.NormalTS = (_SampleTexture2D_d498ae757b6844d898c057015bc62b59_RGBA_0.xyz);
            surface.Emission = (_SampleTexture2D_c17aa1c69b964772bcdb3e44974660dc_RGBA_0.xyz);
            surface.Metallic = (_SampleTexture2D_df52417bcc7f46139ad56a542810709f_RGBA_0).x;
            surface.Smoothness = (_OneMinus_38b031183bd24c4d820e4235d7b2f28d_Out_1).x;
            surface.Occlusion = (_SampleTexture2D_defe923be56f4c978caf7581962d38e7_RGBA_0).x;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.WorldSpaceNormal =                           TransformObjectToWorldNormal(input.normalOS);
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.WorldSpaceTangent =                          TransformObjectToWorldDir(input.tangentOS.xyz);
            output.ObjectSpaceBiTangent =                       normalize(cross(input.normalOS, input.tangentOS.xyz) * (input.tangentOS.w > 0.0f ? 1.0f : -1.0f) * GetOddNegativeScale());
            output.WorldSpaceBiTangent =                        TransformObjectToWorldDir(output.ObjectSpaceBiTangent);
            output.ObjectSpacePosition =                        input.positionOS;
            output.WorldSpacePosition =                         TransformObjectToWorld(input.positionOS);
            output.uv0 =                                        input.uv0;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
            
        
        
        
            output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        
        
            output.uv0 = input.texCoord0;
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        void BuildAppDataFull(Attributes attributes, VertexDescription vertexDescription, inout appdata_full result)
        {
            result.vertex     = float4(attributes.positionOS, 1);
            result.tangent    = attributes.tangentOS;
            result.normal     = attributes.normalOS;
            result.texcoord   = attributes.uv0;
            result.texcoord1  = attributes.uv1;
            result.vertex     = float4(vertexDescription.Position, 1);
            result.normal     = vertexDescription.Normal;
            result.tangent    = float4(vertexDescription.Tangent, 0);
            #if UNITY_ANY_INSTANCING_ENABLED
            #endif
        }
        
        void VaryingsToSurfaceVertex(Varyings varyings, inout v2f_surf result)
        {
            result.pos = varyings.positionCS;
            result.worldPos = varyings.positionWS;
            result.worldNormal = varyings.normalWS;
            result.viewDir = varyings.viewDirectionWS;
            // World Tangent isn't an available input on v2f_surf
        
            result._ShadowCoord = varyings.shadowCoord;
        
            #if UNITY_ANY_INSTANCING_ENABLED
            #endif
            #if !defined(LIGHTMAP_ON)
            #if UNITY_SHOULD_SAMPLE_SH
            result.sh = varyings.sh;
            #endif
            #endif
            #if defined(LIGHTMAP_ON)
            result.lmap.xy = varyings.lightmapUV;
            #endif
            #ifdef VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
                result.fogCoord = varyings.fogFactorAndVertexLight.x;
                COPY_TO_LIGHT_COORDS(result, varyings.fogFactorAndVertexLight.yzw);
            #endif
        
            DEFAULT_UNITY_TRANSFER_VERTEX_OUTPUT_STEREO(varyings, result);
        }
        
        void SurfaceVertexToVaryings(v2f_surf surfVertex, inout Varyings result)
        {
            result.positionCS = surfVertex.pos;
            result.positionWS = surfVertex.worldPos;
            result.normalWS = surfVertex.worldNormal;
            // viewDirectionWS is never filled out in the legacy pass' function. Always use the value computed by SRP
            // World Tangent isn't an available input on v2f_surf
            result.shadowCoord = surfVertex._ShadowCoord;
        
            #if UNITY_ANY_INSTANCING_ENABLED
            #endif
            #if !defined(LIGHTMAP_ON)
            #if UNITY_SHOULD_SAMPLE_SH
            result.sh = surfVertex.sh;
            #endif
            #endif
            #if defined(LIGHTMAP_ON)
            result.lightmapUV = surfVertex.lmap.xy;
            #endif
            #ifdef VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
                result.fogFactorAndVertexLight.x = surfVertex.fogCoord;
                COPY_FROM_LIGHT_COORDS(result.fogFactorAndVertexLight.yzw, surfVertex);
            #endif
        
            DEFAULT_UNITY_TRANSFER_VERTEX_OUTPUT_STEREO(surfVertex, result);
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/PBRDeferredPass.hlsl"
        
        ENDHLSL
        }
        Pass
        {
            Name "ShadowCaster"
            Tags
            {
                "LightMode" = "ShadowCaster"
            }
        
        // Render State
        Cull Back
        Blend One Zero
        ZTest LEqual
        ZWrite On
        ColorMask 0
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 3.0
        #pragma multi_compile_shadowcaster
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        #pragma multi_compile _ _CASTING_PUNCTUAL_LIGHT_SHADOW
        // GraphKeywords: <None>
        
        // Defines
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_SHADOWCASTER
        #define BUILTIN_TARGET_API 1
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        #ifdef _BUILTIN_SURFACE_TYPE_TRANSPARENT
        #define _SURFACE_TYPE_TRANSPARENT _BUILTIN_SURFACE_TYPE_TRANSPARENT
        #endif
        #ifdef _BUILTIN_ALPHATEST_ON
        #define _ALPHATEST_ON _BUILTIN_ALPHATEST_ON
        #endif
        #ifdef _BUILTIN_AlphaClip
        #define _AlphaClip _BUILTIN_AlphaClip
        #endif
        #ifdef _BUILTIN_ALPHAPREMULTIPLY_ON
        #define _ALPHAPREMULTIPLY_ON _BUILTIN_ALPHAPREMULTIPLY_ON
        #endif
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Shim/Shims.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/LegacySurfaceVertex.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/ShaderGraphFunctions.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 WorldSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 WorldSpaceTangent;
             float3 ObjectSpaceBiTangent;
             float3 WorldSpaceBiTangent;
             float3 ObjectSpacePosition;
             float3 WorldSpacePosition;
             float4 uv0;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_Texture_1_TexelSize;
        float4 _Albedo_TexelSize;
        float _HandDistance_L;
        float4 _Normal_TexelSize;
        float4 _Metallic_TexelSize;
        float4 _Roughness_TexelSize;
        float4 _Emission_TexelSize;
        float4 _Occlusion_TexelSize;
        float _HandDistance_R;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_Texture_1);
        SAMPLER(sampler_SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_Texture_1);
        TEXTURE2D(_Albedo);
        SAMPLER(sampler_Albedo);
        TEXTURE2D(_Normal);
        SAMPLER(sampler_Normal);
        TEXTURE2D(_Metallic);
        SAMPLER(sampler_Metallic);
        TEXTURE2D(_Roughness);
        SAMPLER(sampler_Roughness);
        TEXTURE2D(_Emission);
        SAMPLER(sampler_Emission);
        TEXTURE2D(_Occlusion);
        SAMPLER(sampler_Occlusion);
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // Graph Functions
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            #if defined(SHADER_API_GLES) && (SHADER_TARGET < 30)
              float4 _SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_RGBA_0 = float4(0.0f, 0.0f, 0.0f, 1.0f);
            #else
              float4 _SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_RGBA_0 = SAMPLE_TEXTURE2D_LOD(UnityBuildTexture2DStructNoScale(_SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_Texture_1).tex, UnityBuildTexture2DStructNoScale(_SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_Texture_1).samplerstate, UnityBuildTexture2DStructNoScale(_SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_Texture_1).GetTransformedUV(IN.uv0.xy), 0);
            #endif
            float _SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_R_5 = _SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_RGBA_0.r;
            float _SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_G_6 = _SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_RGBA_0.g;
            float _SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_B_7 = _SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_RGBA_0.b;
            float _SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_A_8 = _SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_RGBA_0.a;
            float _Multiply_3722f1dcbb504b98821a250ed076687d_Out_2;
            Unity_Multiply_float_float(_SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_R_5, 1.3, _Multiply_3722f1dcbb504b98821a250ed076687d_Out_2);
            float _Clamp_835360209d6940809420ab76954e5e36_Out_3;
            Unity_Clamp_float(_Multiply_3722f1dcbb504b98821a250ed076687d_Out_2, 0, 1, _Clamp_835360209d6940809420ab76954e5e36_Out_3);
            float _Property_1c42fce47b3f4b1db15420e92567006d_Out_0 = _HandDistance_L;
            float _Multiply_e4f81bfc79184bd398766f0bf3cf5f00_Out_2;
            Unity_Multiply_float_float(_Clamp_835360209d6940809420ab76954e5e36_Out_3, _Property_1c42fce47b3f4b1db15420e92567006d_Out_0, _Multiply_e4f81bfc79184bd398766f0bf3cf5f00_Out_2);
            float _Multiply_58186ae33c614c29bed49bee32988cd9_Out_2;
            Unity_Multiply_float_float(_SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_G_6, 1.3, _Multiply_58186ae33c614c29bed49bee32988cd9_Out_2);
            float _Clamp_84eee08b18294114ba35fb263e0fe982_Out_3;
            Unity_Clamp_float(_Multiply_58186ae33c614c29bed49bee32988cd9_Out_2, 0, 1, _Clamp_84eee08b18294114ba35fb263e0fe982_Out_3);
            float _Property_96b741f01e574648a09d7b471ae97bae_Out_0 = _HandDistance_R;
            float _Multiply_9066e2b7464c4bbf895c46cc12ad156c_Out_2;
            Unity_Multiply_float_float(_Clamp_84eee08b18294114ba35fb263e0fe982_Out_3, _Property_96b741f01e574648a09d7b471ae97bae_Out_0, _Multiply_9066e2b7464c4bbf895c46cc12ad156c_Out_2);
            float _Add_4373991dbe21413198ca5ded3b50d2f6_Out_2;
            Unity_Add_float(_Multiply_e4f81bfc79184bd398766f0bf3cf5f00_Out_2, _Multiply_9066e2b7464c4bbf895c46cc12ad156c_Out_2, _Add_4373991dbe21413198ca5ded3b50d2f6_Out_2);
            float3 _Vector3_aa5d0d0ece754e84b6089860217831bf_Out_0 = float3(0, 0, _Add_4373991dbe21413198ca5ded3b50d2f6_Out_2);
            float3 _Add_77a2907b2a57445c8f175a25fea45b0c_Out_2;
            Unity_Add_float3(_Vector3_aa5d0d0ece754e84b6089860217831bf_Out_0, IN.WorldSpacePosition, _Add_77a2907b2a57445c8f175a25fea45b0c_Out_2);
            float3 _Transform_a820f406e38f454d87eb4c62cf49bfbf_Out_1 = TransformWorldToObject(_Add_77a2907b2a57445c8f175a25fea45b0c_Out_2.xyz);
            description.Position = _Transform_a820f406e38f454d87eb4c62cf49bfbf_Out_1;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.WorldSpaceNormal =                           TransformObjectToWorldNormal(input.normalOS);
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.WorldSpaceTangent =                          TransformObjectToWorldDir(input.tangentOS.xyz);
            output.ObjectSpaceBiTangent =                       normalize(cross(input.normalOS, input.tangentOS.xyz) * (input.tangentOS.w > 0.0f ? 1.0f : -1.0f) * GetOddNegativeScale());
            output.WorldSpaceBiTangent =                        TransformObjectToWorldDir(output.ObjectSpaceBiTangent);
            output.ObjectSpacePosition =                        input.positionOS;
            output.WorldSpacePosition =                         TransformObjectToWorld(input.positionOS);
            output.uv0 =                                        input.uv0;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
            
        
        
        
        
        
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        void BuildAppDataFull(Attributes attributes, VertexDescription vertexDescription, inout appdata_full result)
        {
            result.vertex     = float4(attributes.positionOS, 1);
            result.tangent    = attributes.tangentOS;
            result.normal     = attributes.normalOS;
            result.texcoord   = attributes.uv0;
            result.vertex     = float4(vertexDescription.Position, 1);
            result.normal     = vertexDescription.Normal;
            result.tangent    = float4(vertexDescription.Tangent, 0);
            #if UNITY_ANY_INSTANCING_ENABLED
            #endif
        }
        
        void VaryingsToSurfaceVertex(Varyings varyings, inout v2f_surf result)
        {
            result.pos = varyings.positionCS;
            // World Tangent isn't an available input on v2f_surf
        
        
            #if UNITY_ANY_INSTANCING_ENABLED
            #endif
            #if !defined(LIGHTMAP_ON)
            #if UNITY_SHOULD_SAMPLE_SH
            #endif
            #endif
            #if defined(LIGHTMAP_ON)
            #endif
            #ifdef VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
                result.fogCoord = varyings.fogFactorAndVertexLight.x;
                COPY_TO_LIGHT_COORDS(result, varyings.fogFactorAndVertexLight.yzw);
            #endif
        
            DEFAULT_UNITY_TRANSFER_VERTEX_OUTPUT_STEREO(varyings, result);
        }
        
        void SurfaceVertexToVaryings(v2f_surf surfVertex, inout Varyings result)
        {
            result.positionCS = surfVertex.pos;
            // viewDirectionWS is never filled out in the legacy pass' function. Always use the value computed by SRP
            // World Tangent isn't an available input on v2f_surf
        
            #if UNITY_ANY_INSTANCING_ENABLED
            #endif
            #if !defined(LIGHTMAP_ON)
            #if UNITY_SHOULD_SAMPLE_SH
            #endif
            #endif
            #if defined(LIGHTMAP_ON)
            #endif
            #ifdef VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
                result.fogFactorAndVertexLight.x = surfVertex.fogCoord;
                COPY_FROM_LIGHT_COORDS(result.fogFactorAndVertexLight.yzw, surfVertex);
            #endif
        
            DEFAULT_UNITY_TRANSFER_VERTEX_OUTPUT_STEREO(surfVertex, result);
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/ShadowCasterPass.hlsl"
        
        ENDHLSL
        }
        Pass
        {
            Name "DepthOnly"
            Tags
            {
                "LightMode" = "DepthOnly"
            }
        
        // Render State
        Cull Back
        Blend One Zero
        ZTest LEqual
        ZWrite On
        ColorMask 0
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 3.0
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        #define BUILTIN_TARGET_API 1
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        #ifdef _BUILTIN_SURFACE_TYPE_TRANSPARENT
        #define _SURFACE_TYPE_TRANSPARENT _BUILTIN_SURFACE_TYPE_TRANSPARENT
        #endif
        #ifdef _BUILTIN_ALPHATEST_ON
        #define _ALPHATEST_ON _BUILTIN_ALPHATEST_ON
        #endif
        #ifdef _BUILTIN_AlphaClip
        #define _AlphaClip _BUILTIN_AlphaClip
        #endif
        #ifdef _BUILTIN_ALPHAPREMULTIPLY_ON
        #define _ALPHAPREMULTIPLY_ON _BUILTIN_ALPHAPREMULTIPLY_ON
        #endif
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Shim/Shims.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/LegacySurfaceVertex.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/ShaderGraphFunctions.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 WorldSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 WorldSpaceTangent;
             float3 ObjectSpaceBiTangent;
             float3 WorldSpaceBiTangent;
             float3 ObjectSpacePosition;
             float3 WorldSpacePosition;
             float4 uv0;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_Texture_1_TexelSize;
        float4 _Albedo_TexelSize;
        float _HandDistance_L;
        float4 _Normal_TexelSize;
        float4 _Metallic_TexelSize;
        float4 _Roughness_TexelSize;
        float4 _Emission_TexelSize;
        float4 _Occlusion_TexelSize;
        float _HandDistance_R;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_Texture_1);
        SAMPLER(sampler_SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_Texture_1);
        TEXTURE2D(_Albedo);
        SAMPLER(sampler_Albedo);
        TEXTURE2D(_Normal);
        SAMPLER(sampler_Normal);
        TEXTURE2D(_Metallic);
        SAMPLER(sampler_Metallic);
        TEXTURE2D(_Roughness);
        SAMPLER(sampler_Roughness);
        TEXTURE2D(_Emission);
        SAMPLER(sampler_Emission);
        TEXTURE2D(_Occlusion);
        SAMPLER(sampler_Occlusion);
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // Graph Functions
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            #if defined(SHADER_API_GLES) && (SHADER_TARGET < 30)
              float4 _SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_RGBA_0 = float4(0.0f, 0.0f, 0.0f, 1.0f);
            #else
              float4 _SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_RGBA_0 = SAMPLE_TEXTURE2D_LOD(UnityBuildTexture2DStructNoScale(_SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_Texture_1).tex, UnityBuildTexture2DStructNoScale(_SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_Texture_1).samplerstate, UnityBuildTexture2DStructNoScale(_SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_Texture_1).GetTransformedUV(IN.uv0.xy), 0);
            #endif
            float _SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_R_5 = _SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_RGBA_0.r;
            float _SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_G_6 = _SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_RGBA_0.g;
            float _SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_B_7 = _SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_RGBA_0.b;
            float _SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_A_8 = _SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_RGBA_0.a;
            float _Multiply_3722f1dcbb504b98821a250ed076687d_Out_2;
            Unity_Multiply_float_float(_SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_R_5, 1.3, _Multiply_3722f1dcbb504b98821a250ed076687d_Out_2);
            float _Clamp_835360209d6940809420ab76954e5e36_Out_3;
            Unity_Clamp_float(_Multiply_3722f1dcbb504b98821a250ed076687d_Out_2, 0, 1, _Clamp_835360209d6940809420ab76954e5e36_Out_3);
            float _Property_1c42fce47b3f4b1db15420e92567006d_Out_0 = _HandDistance_L;
            float _Multiply_e4f81bfc79184bd398766f0bf3cf5f00_Out_2;
            Unity_Multiply_float_float(_Clamp_835360209d6940809420ab76954e5e36_Out_3, _Property_1c42fce47b3f4b1db15420e92567006d_Out_0, _Multiply_e4f81bfc79184bd398766f0bf3cf5f00_Out_2);
            float _Multiply_58186ae33c614c29bed49bee32988cd9_Out_2;
            Unity_Multiply_float_float(_SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_G_6, 1.3, _Multiply_58186ae33c614c29bed49bee32988cd9_Out_2);
            float _Clamp_84eee08b18294114ba35fb263e0fe982_Out_3;
            Unity_Clamp_float(_Multiply_58186ae33c614c29bed49bee32988cd9_Out_2, 0, 1, _Clamp_84eee08b18294114ba35fb263e0fe982_Out_3);
            float _Property_96b741f01e574648a09d7b471ae97bae_Out_0 = _HandDistance_R;
            float _Multiply_9066e2b7464c4bbf895c46cc12ad156c_Out_2;
            Unity_Multiply_float_float(_Clamp_84eee08b18294114ba35fb263e0fe982_Out_3, _Property_96b741f01e574648a09d7b471ae97bae_Out_0, _Multiply_9066e2b7464c4bbf895c46cc12ad156c_Out_2);
            float _Add_4373991dbe21413198ca5ded3b50d2f6_Out_2;
            Unity_Add_float(_Multiply_e4f81bfc79184bd398766f0bf3cf5f00_Out_2, _Multiply_9066e2b7464c4bbf895c46cc12ad156c_Out_2, _Add_4373991dbe21413198ca5ded3b50d2f6_Out_2);
            float3 _Vector3_aa5d0d0ece754e84b6089860217831bf_Out_0 = float3(0, 0, _Add_4373991dbe21413198ca5ded3b50d2f6_Out_2);
            float3 _Add_77a2907b2a57445c8f175a25fea45b0c_Out_2;
            Unity_Add_float3(_Vector3_aa5d0d0ece754e84b6089860217831bf_Out_0, IN.WorldSpacePosition, _Add_77a2907b2a57445c8f175a25fea45b0c_Out_2);
            float3 _Transform_a820f406e38f454d87eb4c62cf49bfbf_Out_1 = TransformWorldToObject(_Add_77a2907b2a57445c8f175a25fea45b0c_Out_2.xyz);
            description.Position = _Transform_a820f406e38f454d87eb4c62cf49bfbf_Out_1;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.WorldSpaceNormal =                           TransformObjectToWorldNormal(input.normalOS);
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.WorldSpaceTangent =                          TransformObjectToWorldDir(input.tangentOS.xyz);
            output.ObjectSpaceBiTangent =                       normalize(cross(input.normalOS, input.tangentOS.xyz) * (input.tangentOS.w > 0.0f ? 1.0f : -1.0f) * GetOddNegativeScale());
            output.WorldSpaceBiTangent =                        TransformObjectToWorldDir(output.ObjectSpaceBiTangent);
            output.ObjectSpacePosition =                        input.positionOS;
            output.WorldSpacePosition =                         TransformObjectToWorld(input.positionOS);
            output.uv0 =                                        input.uv0;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
            
        
        
        
        
        
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        void BuildAppDataFull(Attributes attributes, VertexDescription vertexDescription, inout appdata_full result)
        {
            result.vertex     = float4(attributes.positionOS, 1);
            result.tangent    = attributes.tangentOS;
            result.normal     = attributes.normalOS;
            result.texcoord   = attributes.uv0;
            result.vertex     = float4(vertexDescription.Position, 1);
            result.normal     = vertexDescription.Normal;
            result.tangent    = float4(vertexDescription.Tangent, 0);
            #if UNITY_ANY_INSTANCING_ENABLED
            #endif
        }
        
        void VaryingsToSurfaceVertex(Varyings varyings, inout v2f_surf result)
        {
            result.pos = varyings.positionCS;
            // World Tangent isn't an available input on v2f_surf
        
        
            #if UNITY_ANY_INSTANCING_ENABLED
            #endif
            #if !defined(LIGHTMAP_ON)
            #if UNITY_SHOULD_SAMPLE_SH
            #endif
            #endif
            #if defined(LIGHTMAP_ON)
            #endif
            #ifdef VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
                result.fogCoord = varyings.fogFactorAndVertexLight.x;
                COPY_TO_LIGHT_COORDS(result, varyings.fogFactorAndVertexLight.yzw);
            #endif
        
            DEFAULT_UNITY_TRANSFER_VERTEX_OUTPUT_STEREO(varyings, result);
        }
        
        void SurfaceVertexToVaryings(v2f_surf surfVertex, inout Varyings result)
        {
            result.positionCS = surfVertex.pos;
            // viewDirectionWS is never filled out in the legacy pass' function. Always use the value computed by SRP
            // World Tangent isn't an available input on v2f_surf
        
            #if UNITY_ANY_INSTANCING_ENABLED
            #endif
            #if !defined(LIGHTMAP_ON)
            #if UNITY_SHOULD_SAMPLE_SH
            #endif
            #endif
            #if defined(LIGHTMAP_ON)
            #endif
            #ifdef VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
                result.fogFactorAndVertexLight.x = surfVertex.fogCoord;
                COPY_FROM_LIGHT_COORDS(result.fogFactorAndVertexLight.yzw, surfVertex);
            #endif
        
            DEFAULT_UNITY_TRANSFER_VERTEX_OUTPUT_STEREO(surfVertex, result);
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/DepthOnlyPass.hlsl"
        
        ENDHLSL
        }
        Pass
        {
            Name "Meta"
            Tags
            {
                "LightMode" = "Meta"
            }
        
        // Render State
        Cull Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 3.0
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        #pragma shader_feature _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A
        // GraphKeywords: <None>
        
        // Defines
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_TEXCOORD2
        #define VARYINGS_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_META
        #define BUILTIN_TARGET_API 1
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        #ifdef _BUILTIN_SURFACE_TYPE_TRANSPARENT
        #define _SURFACE_TYPE_TRANSPARENT _BUILTIN_SURFACE_TYPE_TRANSPARENT
        #endif
        #ifdef _BUILTIN_ALPHATEST_ON
        #define _ALPHATEST_ON _BUILTIN_ALPHATEST_ON
        #endif
        #ifdef _BUILTIN_AlphaClip
        #define _AlphaClip _BUILTIN_AlphaClip
        #endif
        #ifdef _BUILTIN_ALPHAPREMULTIPLY_ON
        #define _ALPHAPREMULTIPLY_ON _BUILTIN_ALPHAPREMULTIPLY_ON
        #endif
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Shim/Shims.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/LegacySurfaceVertex.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/ShaderGraphFunctions.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
             float4 uv2 : TEXCOORD2;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float4 uv0;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 WorldSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 WorldSpaceTangent;
             float3 ObjectSpaceBiTangent;
             float3 WorldSpaceBiTangent;
             float3 ObjectSpacePosition;
             float3 WorldSpacePosition;
             float4 uv0;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 interp0 : INTERP0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyzw =  input.texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.interp0.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_Texture_1_TexelSize;
        float4 _Albedo_TexelSize;
        float _HandDistance_L;
        float4 _Normal_TexelSize;
        float4 _Metallic_TexelSize;
        float4 _Roughness_TexelSize;
        float4 _Emission_TexelSize;
        float4 _Occlusion_TexelSize;
        float _HandDistance_R;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_Texture_1);
        SAMPLER(sampler_SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_Texture_1);
        TEXTURE2D(_Albedo);
        SAMPLER(sampler_Albedo);
        TEXTURE2D(_Normal);
        SAMPLER(sampler_Normal);
        TEXTURE2D(_Metallic);
        SAMPLER(sampler_Metallic);
        TEXTURE2D(_Roughness);
        SAMPLER(sampler_Roughness);
        TEXTURE2D(_Emission);
        SAMPLER(sampler_Emission);
        TEXTURE2D(_Occlusion);
        SAMPLER(sampler_Occlusion);
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // Graph Functions
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            #if defined(SHADER_API_GLES) && (SHADER_TARGET < 30)
              float4 _SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_RGBA_0 = float4(0.0f, 0.0f, 0.0f, 1.0f);
            #else
              float4 _SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_RGBA_0 = SAMPLE_TEXTURE2D_LOD(UnityBuildTexture2DStructNoScale(_SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_Texture_1).tex, UnityBuildTexture2DStructNoScale(_SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_Texture_1).samplerstate, UnityBuildTexture2DStructNoScale(_SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_Texture_1).GetTransformedUV(IN.uv0.xy), 0);
            #endif
            float _SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_R_5 = _SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_RGBA_0.r;
            float _SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_G_6 = _SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_RGBA_0.g;
            float _SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_B_7 = _SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_RGBA_0.b;
            float _SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_A_8 = _SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_RGBA_0.a;
            float _Multiply_3722f1dcbb504b98821a250ed076687d_Out_2;
            Unity_Multiply_float_float(_SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_R_5, 1.3, _Multiply_3722f1dcbb504b98821a250ed076687d_Out_2);
            float _Clamp_835360209d6940809420ab76954e5e36_Out_3;
            Unity_Clamp_float(_Multiply_3722f1dcbb504b98821a250ed076687d_Out_2, 0, 1, _Clamp_835360209d6940809420ab76954e5e36_Out_3);
            float _Property_1c42fce47b3f4b1db15420e92567006d_Out_0 = _HandDistance_L;
            float _Multiply_e4f81bfc79184bd398766f0bf3cf5f00_Out_2;
            Unity_Multiply_float_float(_Clamp_835360209d6940809420ab76954e5e36_Out_3, _Property_1c42fce47b3f4b1db15420e92567006d_Out_0, _Multiply_e4f81bfc79184bd398766f0bf3cf5f00_Out_2);
            float _Multiply_58186ae33c614c29bed49bee32988cd9_Out_2;
            Unity_Multiply_float_float(_SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_G_6, 1.3, _Multiply_58186ae33c614c29bed49bee32988cd9_Out_2);
            float _Clamp_84eee08b18294114ba35fb263e0fe982_Out_3;
            Unity_Clamp_float(_Multiply_58186ae33c614c29bed49bee32988cd9_Out_2, 0, 1, _Clamp_84eee08b18294114ba35fb263e0fe982_Out_3);
            float _Property_96b741f01e574648a09d7b471ae97bae_Out_0 = _HandDistance_R;
            float _Multiply_9066e2b7464c4bbf895c46cc12ad156c_Out_2;
            Unity_Multiply_float_float(_Clamp_84eee08b18294114ba35fb263e0fe982_Out_3, _Property_96b741f01e574648a09d7b471ae97bae_Out_0, _Multiply_9066e2b7464c4bbf895c46cc12ad156c_Out_2);
            float _Add_4373991dbe21413198ca5ded3b50d2f6_Out_2;
            Unity_Add_float(_Multiply_e4f81bfc79184bd398766f0bf3cf5f00_Out_2, _Multiply_9066e2b7464c4bbf895c46cc12ad156c_Out_2, _Add_4373991dbe21413198ca5ded3b50d2f6_Out_2);
            float3 _Vector3_aa5d0d0ece754e84b6089860217831bf_Out_0 = float3(0, 0, _Add_4373991dbe21413198ca5ded3b50d2f6_Out_2);
            float3 _Add_77a2907b2a57445c8f175a25fea45b0c_Out_2;
            Unity_Add_float3(_Vector3_aa5d0d0ece754e84b6089860217831bf_Out_0, IN.WorldSpacePosition, _Add_77a2907b2a57445c8f175a25fea45b0c_Out_2);
            float3 _Transform_a820f406e38f454d87eb4c62cf49bfbf_Out_1 = TransformWorldToObject(_Add_77a2907b2a57445c8f175a25fea45b0c_Out_2.xyz);
            description.Position = _Transform_a820f406e38f454d87eb4c62cf49bfbf_Out_1;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float3 Emission;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_e991778624504ffda05f55fc103af028_Out_0 = UnityBuildTexture2DStructNoScale(_Albedo);
            float4 _SampleTexture2D_10139d833f154393bcf2cf2ccfcd4113_RGBA_0 = SAMPLE_TEXTURE2D(_Property_e991778624504ffda05f55fc103af028_Out_0.tex, _Property_e991778624504ffda05f55fc103af028_Out_0.samplerstate, _Property_e991778624504ffda05f55fc103af028_Out_0.GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_10139d833f154393bcf2cf2ccfcd4113_R_4 = _SampleTexture2D_10139d833f154393bcf2cf2ccfcd4113_RGBA_0.r;
            float _SampleTexture2D_10139d833f154393bcf2cf2ccfcd4113_G_5 = _SampleTexture2D_10139d833f154393bcf2cf2ccfcd4113_RGBA_0.g;
            float _SampleTexture2D_10139d833f154393bcf2cf2ccfcd4113_B_6 = _SampleTexture2D_10139d833f154393bcf2cf2ccfcd4113_RGBA_0.b;
            float _SampleTexture2D_10139d833f154393bcf2cf2ccfcd4113_A_7 = _SampleTexture2D_10139d833f154393bcf2cf2ccfcd4113_RGBA_0.a;
            UnityTexture2D _Property_72d2e42c3d4f4caa8641fb6fd15fc903_Out_0 = UnityBuildTexture2DStructNoScale(_Emission);
            float4 _SampleTexture2D_c17aa1c69b964772bcdb3e44974660dc_RGBA_0 = SAMPLE_TEXTURE2D(_Property_72d2e42c3d4f4caa8641fb6fd15fc903_Out_0.tex, _Property_72d2e42c3d4f4caa8641fb6fd15fc903_Out_0.samplerstate, _Property_72d2e42c3d4f4caa8641fb6fd15fc903_Out_0.GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_c17aa1c69b964772bcdb3e44974660dc_R_4 = _SampleTexture2D_c17aa1c69b964772bcdb3e44974660dc_RGBA_0.r;
            float _SampleTexture2D_c17aa1c69b964772bcdb3e44974660dc_G_5 = _SampleTexture2D_c17aa1c69b964772bcdb3e44974660dc_RGBA_0.g;
            float _SampleTexture2D_c17aa1c69b964772bcdb3e44974660dc_B_6 = _SampleTexture2D_c17aa1c69b964772bcdb3e44974660dc_RGBA_0.b;
            float _SampleTexture2D_c17aa1c69b964772bcdb3e44974660dc_A_7 = _SampleTexture2D_c17aa1c69b964772bcdb3e44974660dc_RGBA_0.a;
            surface.BaseColor = (_SampleTexture2D_10139d833f154393bcf2cf2ccfcd4113_RGBA_0.xyz);
            surface.Emission = (_SampleTexture2D_c17aa1c69b964772bcdb3e44974660dc_RGBA_0.xyz);
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.WorldSpaceNormal =                           TransformObjectToWorldNormal(input.normalOS);
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.WorldSpaceTangent =                          TransformObjectToWorldDir(input.tangentOS.xyz);
            output.ObjectSpaceBiTangent =                       normalize(cross(input.normalOS, input.tangentOS.xyz) * (input.tangentOS.w > 0.0f ? 1.0f : -1.0f) * GetOddNegativeScale());
            output.WorldSpaceBiTangent =                        TransformObjectToWorldDir(output.ObjectSpaceBiTangent);
            output.ObjectSpacePosition =                        input.positionOS;
            output.WorldSpacePosition =                         TransformObjectToWorld(input.positionOS);
            output.uv0 =                                        input.uv0;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
            
        
        
        
        
        
            output.uv0 = input.texCoord0;
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        void BuildAppDataFull(Attributes attributes, VertexDescription vertexDescription, inout appdata_full result)
        {
            result.vertex     = float4(attributes.positionOS, 1);
            result.tangent    = attributes.tangentOS;
            result.normal     = attributes.normalOS;
            result.texcoord   = attributes.uv0;
            result.texcoord1  = attributes.uv1;
            result.texcoord2  = attributes.uv2;
            result.vertex     = float4(vertexDescription.Position, 1);
            result.normal     = vertexDescription.Normal;
            result.tangent    = float4(vertexDescription.Tangent, 0);
            #if UNITY_ANY_INSTANCING_ENABLED
            #endif
        }
        
        void VaryingsToSurfaceVertex(Varyings varyings, inout v2f_surf result)
        {
            result.pos = varyings.positionCS;
            // World Tangent isn't an available input on v2f_surf
        
        
            #if UNITY_ANY_INSTANCING_ENABLED
            #endif
            #if !defined(LIGHTMAP_ON)
            #if UNITY_SHOULD_SAMPLE_SH
            #endif
            #endif
            #if defined(LIGHTMAP_ON)
            #endif
            #ifdef VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
                result.fogCoord = varyings.fogFactorAndVertexLight.x;
                COPY_TO_LIGHT_COORDS(result, varyings.fogFactorAndVertexLight.yzw);
            #endif
        
            DEFAULT_UNITY_TRANSFER_VERTEX_OUTPUT_STEREO(varyings, result);
        }
        
        void SurfaceVertexToVaryings(v2f_surf surfVertex, inout Varyings result)
        {
            result.positionCS = surfVertex.pos;
            // viewDirectionWS is never filled out in the legacy pass' function. Always use the value computed by SRP
            // World Tangent isn't an available input on v2f_surf
        
            #if UNITY_ANY_INSTANCING_ENABLED
            #endif
            #if !defined(LIGHTMAP_ON)
            #if UNITY_SHOULD_SAMPLE_SH
            #endif
            #endif
            #if defined(LIGHTMAP_ON)
            #endif
            #ifdef VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
                result.fogFactorAndVertexLight.x = surfVertex.fogCoord;
                COPY_FROM_LIGHT_COORDS(result.fogFactorAndVertexLight.yzw, surfVertex);
            #endif
        
            DEFAULT_UNITY_TRANSFER_VERTEX_OUTPUT_STEREO(surfVertex, result);
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/LightingMetaPass.hlsl"
        
        ENDHLSL
        }
        Pass
        {
            Name "SceneSelectionPass"
            Tags
            {
                "LightMode" = "SceneSelectionPass"
            }
        
        // Render State
        Cull Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 3.0
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SceneSelectionPass
        #define BUILTIN_TARGET_API 1
        #define SCENESELECTIONPASS 1
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        #ifdef _BUILTIN_SURFACE_TYPE_TRANSPARENT
        #define _SURFACE_TYPE_TRANSPARENT _BUILTIN_SURFACE_TYPE_TRANSPARENT
        #endif
        #ifdef _BUILTIN_ALPHATEST_ON
        #define _ALPHATEST_ON _BUILTIN_ALPHATEST_ON
        #endif
        #ifdef _BUILTIN_AlphaClip
        #define _AlphaClip _BUILTIN_AlphaClip
        #endif
        #ifdef _BUILTIN_ALPHAPREMULTIPLY_ON
        #define _ALPHAPREMULTIPLY_ON _BUILTIN_ALPHAPREMULTIPLY_ON
        #endif
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Shim/Shims.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/LegacySurfaceVertex.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/ShaderGraphFunctions.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 WorldSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 WorldSpaceTangent;
             float3 ObjectSpaceBiTangent;
             float3 WorldSpaceBiTangent;
             float3 ObjectSpacePosition;
             float3 WorldSpacePosition;
             float4 uv0;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_Texture_1_TexelSize;
        float4 _Albedo_TexelSize;
        float _HandDistance_L;
        float4 _Normal_TexelSize;
        float4 _Metallic_TexelSize;
        float4 _Roughness_TexelSize;
        float4 _Emission_TexelSize;
        float4 _Occlusion_TexelSize;
        float _HandDistance_R;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_Texture_1);
        SAMPLER(sampler_SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_Texture_1);
        TEXTURE2D(_Albedo);
        SAMPLER(sampler_Albedo);
        TEXTURE2D(_Normal);
        SAMPLER(sampler_Normal);
        TEXTURE2D(_Metallic);
        SAMPLER(sampler_Metallic);
        TEXTURE2D(_Roughness);
        SAMPLER(sampler_Roughness);
        TEXTURE2D(_Emission);
        SAMPLER(sampler_Emission);
        TEXTURE2D(_Occlusion);
        SAMPLER(sampler_Occlusion);
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // Graph Functions
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            #if defined(SHADER_API_GLES) && (SHADER_TARGET < 30)
              float4 _SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_RGBA_0 = float4(0.0f, 0.0f, 0.0f, 1.0f);
            #else
              float4 _SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_RGBA_0 = SAMPLE_TEXTURE2D_LOD(UnityBuildTexture2DStructNoScale(_SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_Texture_1).tex, UnityBuildTexture2DStructNoScale(_SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_Texture_1).samplerstate, UnityBuildTexture2DStructNoScale(_SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_Texture_1).GetTransformedUV(IN.uv0.xy), 0);
            #endif
            float _SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_R_5 = _SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_RGBA_0.r;
            float _SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_G_6 = _SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_RGBA_0.g;
            float _SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_B_7 = _SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_RGBA_0.b;
            float _SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_A_8 = _SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_RGBA_0.a;
            float _Multiply_3722f1dcbb504b98821a250ed076687d_Out_2;
            Unity_Multiply_float_float(_SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_R_5, 1.3, _Multiply_3722f1dcbb504b98821a250ed076687d_Out_2);
            float _Clamp_835360209d6940809420ab76954e5e36_Out_3;
            Unity_Clamp_float(_Multiply_3722f1dcbb504b98821a250ed076687d_Out_2, 0, 1, _Clamp_835360209d6940809420ab76954e5e36_Out_3);
            float _Property_1c42fce47b3f4b1db15420e92567006d_Out_0 = _HandDistance_L;
            float _Multiply_e4f81bfc79184bd398766f0bf3cf5f00_Out_2;
            Unity_Multiply_float_float(_Clamp_835360209d6940809420ab76954e5e36_Out_3, _Property_1c42fce47b3f4b1db15420e92567006d_Out_0, _Multiply_e4f81bfc79184bd398766f0bf3cf5f00_Out_2);
            float _Multiply_58186ae33c614c29bed49bee32988cd9_Out_2;
            Unity_Multiply_float_float(_SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_G_6, 1.3, _Multiply_58186ae33c614c29bed49bee32988cd9_Out_2);
            float _Clamp_84eee08b18294114ba35fb263e0fe982_Out_3;
            Unity_Clamp_float(_Multiply_58186ae33c614c29bed49bee32988cd9_Out_2, 0, 1, _Clamp_84eee08b18294114ba35fb263e0fe982_Out_3);
            float _Property_96b741f01e574648a09d7b471ae97bae_Out_0 = _HandDistance_R;
            float _Multiply_9066e2b7464c4bbf895c46cc12ad156c_Out_2;
            Unity_Multiply_float_float(_Clamp_84eee08b18294114ba35fb263e0fe982_Out_3, _Property_96b741f01e574648a09d7b471ae97bae_Out_0, _Multiply_9066e2b7464c4bbf895c46cc12ad156c_Out_2);
            float _Add_4373991dbe21413198ca5ded3b50d2f6_Out_2;
            Unity_Add_float(_Multiply_e4f81bfc79184bd398766f0bf3cf5f00_Out_2, _Multiply_9066e2b7464c4bbf895c46cc12ad156c_Out_2, _Add_4373991dbe21413198ca5ded3b50d2f6_Out_2);
            float3 _Vector3_aa5d0d0ece754e84b6089860217831bf_Out_0 = float3(0, 0, _Add_4373991dbe21413198ca5ded3b50d2f6_Out_2);
            float3 _Add_77a2907b2a57445c8f175a25fea45b0c_Out_2;
            Unity_Add_float3(_Vector3_aa5d0d0ece754e84b6089860217831bf_Out_0, IN.WorldSpacePosition, _Add_77a2907b2a57445c8f175a25fea45b0c_Out_2);
            float3 _Transform_a820f406e38f454d87eb4c62cf49bfbf_Out_1 = TransformWorldToObject(_Add_77a2907b2a57445c8f175a25fea45b0c_Out_2.xyz);
            description.Position = _Transform_a820f406e38f454d87eb4c62cf49bfbf_Out_1;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.WorldSpaceNormal =                           TransformObjectToWorldNormal(input.normalOS);
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.WorldSpaceTangent =                          TransformObjectToWorldDir(input.tangentOS.xyz);
            output.ObjectSpaceBiTangent =                       normalize(cross(input.normalOS, input.tangentOS.xyz) * (input.tangentOS.w > 0.0f ? 1.0f : -1.0f) * GetOddNegativeScale());
            output.WorldSpaceBiTangent =                        TransformObjectToWorldDir(output.ObjectSpaceBiTangent);
            output.ObjectSpacePosition =                        input.positionOS;
            output.WorldSpacePosition =                         TransformObjectToWorld(input.positionOS);
            output.uv0 =                                        input.uv0;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
            
        
        
        
        
        
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        void BuildAppDataFull(Attributes attributes, VertexDescription vertexDescription, inout appdata_full result)
        {
            result.vertex     = float4(attributes.positionOS, 1);
            result.tangent    = attributes.tangentOS;
            result.normal     = attributes.normalOS;
            result.texcoord   = attributes.uv0;
            result.vertex     = float4(vertexDescription.Position, 1);
            result.normal     = vertexDescription.Normal;
            result.tangent    = float4(vertexDescription.Tangent, 0);
            #if UNITY_ANY_INSTANCING_ENABLED
            #endif
        }
        
        void VaryingsToSurfaceVertex(Varyings varyings, inout v2f_surf result)
        {
            result.pos = varyings.positionCS;
            // World Tangent isn't an available input on v2f_surf
        
        
            #if UNITY_ANY_INSTANCING_ENABLED
            #endif
            #if !defined(LIGHTMAP_ON)
            #if UNITY_SHOULD_SAMPLE_SH
            #endif
            #endif
            #if defined(LIGHTMAP_ON)
            #endif
            #ifdef VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
                result.fogCoord = varyings.fogFactorAndVertexLight.x;
                COPY_TO_LIGHT_COORDS(result, varyings.fogFactorAndVertexLight.yzw);
            #endif
        
            DEFAULT_UNITY_TRANSFER_VERTEX_OUTPUT_STEREO(varyings, result);
        }
        
        void SurfaceVertexToVaryings(v2f_surf surfVertex, inout Varyings result)
        {
            result.positionCS = surfVertex.pos;
            // viewDirectionWS is never filled out in the legacy pass' function. Always use the value computed by SRP
            // World Tangent isn't an available input on v2f_surf
        
            #if UNITY_ANY_INSTANCING_ENABLED
            #endif
            #if !defined(LIGHTMAP_ON)
            #if UNITY_SHOULD_SAMPLE_SH
            #endif
            #endif
            #if defined(LIGHTMAP_ON)
            #endif
            #ifdef VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
                result.fogFactorAndVertexLight.x = surfVertex.fogCoord;
                COPY_FROM_LIGHT_COORDS(result.fogFactorAndVertexLight.yzw, surfVertex);
            #endif
        
            DEFAULT_UNITY_TRANSFER_VERTEX_OUTPUT_STEREO(surfVertex, result);
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/DepthOnlyPass.hlsl"
        
        ENDHLSL
        }
        Pass
        {
            Name "ScenePickingPass"
            Tags
            {
                "LightMode" = "Picking"
            }
        
        // Render State
        Cull Back
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 3.0
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS ScenePickingPass
        #define BUILTIN_TARGET_API 1
        #define SCENEPICKINGPASS 1
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        #ifdef _BUILTIN_SURFACE_TYPE_TRANSPARENT
        #define _SURFACE_TYPE_TRANSPARENT _BUILTIN_SURFACE_TYPE_TRANSPARENT
        #endif
        #ifdef _BUILTIN_ALPHATEST_ON
        #define _ALPHATEST_ON _BUILTIN_ALPHATEST_ON
        #endif
        #ifdef _BUILTIN_AlphaClip
        #define _AlphaClip _BUILTIN_AlphaClip
        #endif
        #ifdef _BUILTIN_ALPHAPREMULTIPLY_ON
        #define _ALPHAPREMULTIPLY_ON _BUILTIN_ALPHAPREMULTIPLY_ON
        #endif
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Shim/Shims.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/LegacySurfaceVertex.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/ShaderGraphFunctions.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 WorldSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 WorldSpaceTangent;
             float3 ObjectSpaceBiTangent;
             float3 WorldSpaceBiTangent;
             float3 ObjectSpacePosition;
             float3 WorldSpacePosition;
             float4 uv0;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_Texture_1_TexelSize;
        float4 _Albedo_TexelSize;
        float _HandDistance_L;
        float4 _Normal_TexelSize;
        float4 _Metallic_TexelSize;
        float4 _Roughness_TexelSize;
        float4 _Emission_TexelSize;
        float4 _Occlusion_TexelSize;
        float _HandDistance_R;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_Texture_1);
        SAMPLER(sampler_SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_Texture_1);
        TEXTURE2D(_Albedo);
        SAMPLER(sampler_Albedo);
        TEXTURE2D(_Normal);
        SAMPLER(sampler_Normal);
        TEXTURE2D(_Metallic);
        SAMPLER(sampler_Metallic);
        TEXTURE2D(_Roughness);
        SAMPLER(sampler_Roughness);
        TEXTURE2D(_Emission);
        SAMPLER(sampler_Emission);
        TEXTURE2D(_Occlusion);
        SAMPLER(sampler_Occlusion);
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // Graph Functions
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            #if defined(SHADER_API_GLES) && (SHADER_TARGET < 30)
              float4 _SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_RGBA_0 = float4(0.0f, 0.0f, 0.0f, 1.0f);
            #else
              float4 _SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_RGBA_0 = SAMPLE_TEXTURE2D_LOD(UnityBuildTexture2DStructNoScale(_SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_Texture_1).tex, UnityBuildTexture2DStructNoScale(_SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_Texture_1).samplerstate, UnityBuildTexture2DStructNoScale(_SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_Texture_1).GetTransformedUV(IN.uv0.xy), 0);
            #endif
            float _SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_R_5 = _SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_RGBA_0.r;
            float _SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_G_6 = _SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_RGBA_0.g;
            float _SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_B_7 = _SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_RGBA_0.b;
            float _SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_A_8 = _SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_RGBA_0.a;
            float _Multiply_3722f1dcbb504b98821a250ed076687d_Out_2;
            Unity_Multiply_float_float(_SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_R_5, 1.3, _Multiply_3722f1dcbb504b98821a250ed076687d_Out_2);
            float _Clamp_835360209d6940809420ab76954e5e36_Out_3;
            Unity_Clamp_float(_Multiply_3722f1dcbb504b98821a250ed076687d_Out_2, 0, 1, _Clamp_835360209d6940809420ab76954e5e36_Out_3);
            float _Property_1c42fce47b3f4b1db15420e92567006d_Out_0 = _HandDistance_L;
            float _Multiply_e4f81bfc79184bd398766f0bf3cf5f00_Out_2;
            Unity_Multiply_float_float(_Clamp_835360209d6940809420ab76954e5e36_Out_3, _Property_1c42fce47b3f4b1db15420e92567006d_Out_0, _Multiply_e4f81bfc79184bd398766f0bf3cf5f00_Out_2);
            float _Multiply_58186ae33c614c29bed49bee32988cd9_Out_2;
            Unity_Multiply_float_float(_SampleTexture2DLOD_dee257d979aa452981d57d925ac66e0a_G_6, 1.3, _Multiply_58186ae33c614c29bed49bee32988cd9_Out_2);
            float _Clamp_84eee08b18294114ba35fb263e0fe982_Out_3;
            Unity_Clamp_float(_Multiply_58186ae33c614c29bed49bee32988cd9_Out_2, 0, 1, _Clamp_84eee08b18294114ba35fb263e0fe982_Out_3);
            float _Property_96b741f01e574648a09d7b471ae97bae_Out_0 = _HandDistance_R;
            float _Multiply_9066e2b7464c4bbf895c46cc12ad156c_Out_2;
            Unity_Multiply_float_float(_Clamp_84eee08b18294114ba35fb263e0fe982_Out_3, _Property_96b741f01e574648a09d7b471ae97bae_Out_0, _Multiply_9066e2b7464c4bbf895c46cc12ad156c_Out_2);
            float _Add_4373991dbe21413198ca5ded3b50d2f6_Out_2;
            Unity_Add_float(_Multiply_e4f81bfc79184bd398766f0bf3cf5f00_Out_2, _Multiply_9066e2b7464c4bbf895c46cc12ad156c_Out_2, _Add_4373991dbe21413198ca5ded3b50d2f6_Out_2);
            float3 _Vector3_aa5d0d0ece754e84b6089860217831bf_Out_0 = float3(0, 0, _Add_4373991dbe21413198ca5ded3b50d2f6_Out_2);
            float3 _Add_77a2907b2a57445c8f175a25fea45b0c_Out_2;
            Unity_Add_float3(_Vector3_aa5d0d0ece754e84b6089860217831bf_Out_0, IN.WorldSpacePosition, _Add_77a2907b2a57445c8f175a25fea45b0c_Out_2);
            float3 _Transform_a820f406e38f454d87eb4c62cf49bfbf_Out_1 = TransformWorldToObject(_Add_77a2907b2a57445c8f175a25fea45b0c_Out_2.xyz);
            description.Position = _Transform_a820f406e38f454d87eb4c62cf49bfbf_Out_1;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.WorldSpaceNormal =                           TransformObjectToWorldNormal(input.normalOS);
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.WorldSpaceTangent =                          TransformObjectToWorldDir(input.tangentOS.xyz);
            output.ObjectSpaceBiTangent =                       normalize(cross(input.normalOS, input.tangentOS.xyz) * (input.tangentOS.w > 0.0f ? 1.0f : -1.0f) * GetOddNegativeScale());
            output.WorldSpaceBiTangent =                        TransformObjectToWorldDir(output.ObjectSpaceBiTangent);
            output.ObjectSpacePosition =                        input.positionOS;
            output.WorldSpacePosition =                         TransformObjectToWorld(input.positionOS);
            output.uv0 =                                        input.uv0;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
            
        
        
        
        
        
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        void BuildAppDataFull(Attributes attributes, VertexDescription vertexDescription, inout appdata_full result)
        {
            result.vertex     = float4(attributes.positionOS, 1);
            result.tangent    = attributes.tangentOS;
            result.normal     = attributes.normalOS;
            result.texcoord   = attributes.uv0;
            result.vertex     = float4(vertexDescription.Position, 1);
            result.normal     = vertexDescription.Normal;
            result.tangent    = float4(vertexDescription.Tangent, 0);
            #if UNITY_ANY_INSTANCING_ENABLED
            #endif
        }
        
        void VaryingsToSurfaceVertex(Varyings varyings, inout v2f_surf result)
        {
            result.pos = varyings.positionCS;
            // World Tangent isn't an available input on v2f_surf
        
        
            #if UNITY_ANY_INSTANCING_ENABLED
            #endif
            #if !defined(LIGHTMAP_ON)
            #if UNITY_SHOULD_SAMPLE_SH
            #endif
            #endif
            #if defined(LIGHTMAP_ON)
            #endif
            #ifdef VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
                result.fogCoord = varyings.fogFactorAndVertexLight.x;
                COPY_TO_LIGHT_COORDS(result, varyings.fogFactorAndVertexLight.yzw);
            #endif
        
            DEFAULT_UNITY_TRANSFER_VERTEX_OUTPUT_STEREO(varyings, result);
        }
        
        void SurfaceVertexToVaryings(v2f_surf surfVertex, inout Varyings result)
        {
            result.positionCS = surfVertex.pos;
            // viewDirectionWS is never filled out in the legacy pass' function. Always use the value computed by SRP
            // World Tangent isn't an available input on v2f_surf
        
            #if UNITY_ANY_INSTANCING_ENABLED
            #endif
            #if !defined(LIGHTMAP_ON)
            #if UNITY_SHOULD_SAMPLE_SH
            #endif
            #endif
            #if defined(LIGHTMAP_ON)
            #endif
            #ifdef VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
                result.fogFactorAndVertexLight.x = surfVertex.fogCoord;
                COPY_FROM_LIGHT_COORDS(result.fogFactorAndVertexLight.yzw, surfVertex);
            #endif
        
            DEFAULT_UNITY_TRANSFER_VERTEX_OUTPUT_STEREO(surfVertex, result);
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/DepthOnlyPass.hlsl"
        
        ENDHLSL
        }
    }
    CustomEditorForRenderPipeline "UnityEditor.Rendering.BuiltIn.ShaderGraph.BuiltInLitGUI" ""
    CustomEditor "UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI"
    FallBack "Hidden/Shader Graph/FallbackError"
}