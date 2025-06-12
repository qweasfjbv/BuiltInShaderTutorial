Shader "Custom/P6/P6_C3"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _OffsetX ("OffsetX", float) = 0
        _OffsetY ("OffsetY", float) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf Standard

        sampler2D _MainTex;
        fixed _OffsetX;
        fixed _OffsetY;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // Offset만큼 시작점이 변하는 것을 확인할 수 있음
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex + fixed2(_OffsetX, _OffsetY));

            o.Emission = c.rgb;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
