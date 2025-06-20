Shader "Custom/P14/P14_Outline_2Pass"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Thickness ("Thickness", Range(0.001, 0.01)) = 0.005
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        
        cull front
    
        // 1st Pass
        // 첫 번째 패스는 cull front, normal 쪽으로 vertex를 이동시켜서 외곽선을 그림
        CGPROGRAM
        #pragma surface surf Nolight vertex:vert noshadow noambient

        sampler2D _MainTex;
        float _Thickness;

        void vert(inout appdata_full v)
        {
            v.vertex.xyz += v.normal.xyz * _Thickness;
        }

        struct Input
        {
            float4 color:COLOR;
        };

        void surf (Input IN, inout SurfaceOutput o) { }

        float4 LightingNolight(SurfaceOutput s, float3 lightDir, float atten){
            return float4(0,0,0,1);
        }
        ENDCG
        
        cull back
        // 2nd Pass
        CGPROGRAM
        #pragma surface surf Lambert

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
