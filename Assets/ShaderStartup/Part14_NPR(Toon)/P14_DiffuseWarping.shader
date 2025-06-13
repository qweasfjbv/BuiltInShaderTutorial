Shader "Custom/P14/P14_DiffuseWarping"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _BumpMap ("Normal Map", 2D) = "bump" {}
        _RampTex ("RampTex", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf Warp

        sampler2D _MainTex;
        sampler2D _BumpMap;
        sampler2D _RampTex;

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

        float4 LightingWarp(SurfaceOutput s, float3 lightDir, float3 viewDir, float atten) {

            // ramp와 ndotl, specular(rim도 됨)으로 toon 느낌을 냄
            float3 H = normalize(lightDir + viewDir);
            float spec = saturate(dot(s.Normal, H));
            float ndotl = dot(s.Normal, lightDir) * 0.5 + 0.5;            
            //float4 ramp = tex2D(_RampTex, float2(ndotl, spec));

            float rim = abs(dot(viewDir, s.Normal));  
            float4 ramp = tex2D(_RampTex, float2(ndotl, rim));

            float4 final;
            final.rgb = s.Albedo.rgb * ramp.rgb + (ramp.rgb * 0.1);
            final.a = s.Alpha;
            return final;
        }
        
        ENDCG
    }
    FallBack "Diffuse"
}
