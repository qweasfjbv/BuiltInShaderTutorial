Shader "Custom/P11/P11_Lambert"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _BumpMap ("NormalMap", 2D) = "bump" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf CustomLambert

        sampler2D _MainTex;
        sampler2D _BumpMap;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_BumpMap;
        };

        // 실행 순서 :
        // vt -> surf -> Lighting -> frag
        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;
            o.Normal = UnpackNormal(tex2D (_BumpMap, IN.uv_BumpMap));
            o.Alpha = c.a;
        }

        // Lighting{Name}
        // s : surf함수에서 설정한 값들 (Albedo, Emission, Alpha ...)
        // lightDir : 조명벡터. (편의를 위해 뒤집힌 상태)
        // atten(감쇠) : 라이트의 거리별 감쇠 현상을 나타냄
        float4 LightingCustomLambert(SurfaceOutput s, float3 lightDir, float atten) {
            
            // saturate : clamp01
            float ndot1 = saturate(dot(s.Normal, lightDir));
            float4 final;

            // _LightColor0 : 내장 변수. 조명의 색상, 강도
            // atten : receive shadow 및 조명 감쇠 현상
            final.rgb = ndot1 * s.Albedo * _LightColor0.rgb * atten;
            final.a = s.Alpha;
            return final;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
