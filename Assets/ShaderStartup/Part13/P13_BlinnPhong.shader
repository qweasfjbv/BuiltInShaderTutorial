Shader "Custom/P13/P13_BlinnPhong"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _BumpMap ("Normal Map", 2D) = "bump" {}
        _SpecCol ("Specular Color", Color) = (1,1,1,1)
        _SpecPow ("Specular Power", Range(1, 200)) = 100
        _SpecCol2 ("Specular Color2", Color) = (1,1,1,1)
        _SpecPow2 ("Specular Power2", Range(1, 50)) = 50
        _RimColor ("Rim Color", Color) = (1,1,1,1)
        _RimPow ("Rim Power", Range(1, 20)) = 3
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf CustomLambert noambient

        sampler2D _MainTex;
        sampler2D _BumpMap;
        float4 _SpecCol;
        float _SpecPow;
        float4 _SpecCol2;
        float _SpecPow2;

        float4 _RimColor;
        float _RimPow;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_BumpMap;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;
            o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
            o.Alpha = c.a;
        }

        float4 LightingCustomLambert(SurfaceOutput s, float3 lightDir, float3 viewDir, float atten) 
        {
            // Lambert term
            float3 DiffColor;
            float ndotl = saturate(dot(s.Normal, lightDir));
            DiffColor = ndotl * s.Albedo * _LightColor0.rgb * atten;
            
            // Spec term (Blinn-Phong 공식 사용)
            float3 SpecColor;
            float3 H = normalize(viewDir + lightDir);
            float spec = saturate(dot(H, s.Normal));
            spec = pow(spec, _SpecPow);
            SpecColor = spec * _SpecCol.rgb;

            // Rim term
            float3 rimColor;
            float rim = abs(dot(viewDir, s.Normal));
            float invrim = 1 - rim;
            rimColor = pow(invrim, _RimPow) * _RimColor;

            // Fake Spec term
            // Rim값에 pow를 곱하면 specular와 같은 효과를 얻을 수 있음
            // + 비용이 적음
            float3 SpecColor2;
            SpecColor2 = pow(rim, _SpecPow2) * _SpecCol2;

            // final term
            float4 final;
            final.rgb = DiffColor.rgb + SpecColor.rgb + rimColor.rgb + SpecColor2.rgb;
            final.a = s.Alpha;
            return final;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
