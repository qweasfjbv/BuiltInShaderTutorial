Shader "Custom/P14/P14_Outline_Fresnel"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _BumpMap ("BumpMap", 2D) = "bump" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf Toon

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
            o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }

        float4 LightingToon(SurfaceOutput s, float3 lightDir, float3 viewDir, float atten)
        {
            float ndotl = dot(s.Normal, lightDir) * 0.5 + 0.5;

            ndotl *= 4;
            ndotl = ceil(ndotl) / 4;

            // rim : 끝부분이 검정색으로 나옴
            float rim = abs(dot(s.Normal, viewDir));
            if(rim > 0.35){
                rim = 1;
            }
            else{
                rim = -1;
            }

            float4 final;
            
            // rim을 곱해주면 끝부분이 Outline처럼 보임
            final.rgb = s.Albedo * ndotl * _LightColor0.rgb * rim;
            final.a = s.Alpha;
            return final;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
