Shader "Custom/ScrollingNormalBlend"
{
    Properties
    {
        _MainTex1("Texture 1", 2D) = "white" {}
        _MainTex2("Texture 2", 2D) = "white" {}
        _Speed1("Speed 1", Vector) = (0.1, 0.1, 0, 0)
        _Speed2("Speed 2", Vector) = (0.05, 0.05, 0, 0)
        _Color("Color", Color) = (1, 1, 1, 1)
        _Metallic("Metallic", Range(0, 1)) = 0.5
        _Smoothness("Smoothness", Range(0, 1)) = 0.5
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 200

        Pass
        {
            Tags { "LightMode" = "UniversalForward" }
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            struct Attributes
            {
                float4 positionOS : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct Varyings
            {
                float4 positionHCS : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            sampler2D _MainTex1;
            sampler2D _MainTex2;
            float4 _Speed1;
            float4 _Speed2;
            float4 _Color;
            float _Metallic;
            float _Smoothness;

            Varyings vert(Attributes input)
            {
                Varyings output;
                output.positionHCS = TransformObjectToHClip(input.positionOS);
                output.uv = input.uv;
                return output;
            }

            half4 frag(Varyings input) : SV_Target
            {
                // Scrolling UVs for both textures
                float2 uv1 = input.uv + _Speed1.xy * _Time.y;
                float2 uv2 = input.uv + _Speed2.xy * _Time.y;

                // Sample the textures
                half4 tex1 = SAMPLE_TEXTURE2D(_MainTex1, sampler_MainTex1, uv1);
                half4 tex2 = SAMPLE_TEXTURE2D(_MainTex2, sampler_MainTex2, uv2);

                // Blend the textures as normals
                half3 blendedNormal = UnpackNormal(tex1) + UnpackNormal(tex2);
                blendedNormal = normalize(blendedNormal);

                // Apply blended normals
                half3 color = _Color.rgb;
                return half4(color, 1.0) * (blendedNormal * 0.5 + 0.5);
            }
            ENDHLSL
        }
    }
}
