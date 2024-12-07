Shader "Custom/WaterShader"
{
    Properties
    {
        _MainTex ("Main Texture", 2D) = "white" {} // Основная текстура
        _SecondTex ("Secondary Texture", 2D) = "white" {} // Вторая текстура
        _Speed ("Scroll Speed", Float) = 5 // Скорость движения
        _Blend ("Blend Factor", Range(0, 1)) = 0.5 // Смешивание текстур
        _TintColor ("Tint Color", Color) = (100.2, 15.4, 11, 11) // Цветовая тонировка
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            sampler2D _MainTex;
            sampler2D _SecondTex;
            float _Speed;
            float _Blend;
            fixed4 _TintColor;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float2 offset = _Speed * _Time.y;
                fixed4 tex1 = tex2D(_MainTex, i.uv + offset);
                fixed4 tex2 = tex2D(_SecondTex, i.uv - offset);
                fixed4 blendedTex = lerp(tex1, tex2, _Blend);
                return blendedTex * _TintColor; // Применяем голубую тонировку
            }
            ENDCG
        }
    }
}
