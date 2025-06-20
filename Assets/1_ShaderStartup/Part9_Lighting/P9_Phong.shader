Shader "Custom/P9/P9_Phong"
{
    Properties
    {
        _Color ("Color", Color) = (1, 1, 1, 1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _SpecColor ("Specular Color", Color) = (1, 1, 1, 1)
        _Gloss ("Gloss", Float) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf BlinnPhong

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        fixed4 _Color;
        half _Gloss;

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            o.Specular = 0.5;
            o.Gloss = _Gloss;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
