Shader "Custom/P11/P11_HalfLambert"
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

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;
            o.Normal = UnpackNormal(tex2D (_BumpMap, IN.uv_BumpMap));
            o.Alpha = c.a;
        }

        // Half-Lambert
        float4 LightingCustomLambert(SurfaceOutput s, float3 lightDir, float atten) {
            // 범위가 [0, 1] 안에 부드럽게 보간됨
            float ndot1 = dot(s.Normal, lightDir) * 0.5 + 0.5;
            float4 final;
            final.rgb = pow(ndot1, 3) * atten * _LightColor0.rgb * s.Albedo;
            final.a = s.Alpha;

            return final;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
