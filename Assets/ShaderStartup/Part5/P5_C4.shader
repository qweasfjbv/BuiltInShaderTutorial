Shader "Custom/P5/P5_C4"
{
    Properties
    {
        _MainTex ("MainTex1", 2D) = "white" {}
        _MainTex2 ("MainTex2", 2D) = "white" {}
        _Lerp ("Lerp", Range(0, 1)) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf Standard

        sampler2D _MainTex;
        sampler2D _MainTex2;
        fixed _Lerp;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_MainTex2;
        };
        
        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            fixed4 d = tex2D (_MainTex2, IN.uv_MainTex2);
            
            // MainTex와 MainTex2 가 _Lerp만큼 섞여서 나옴
            // o.Albedo = lerp(c, d, _Lerp);
            
            // MainTex의 Alpha 채널을 사용
            o.Albedo = lerp(c, d, 1 - c.a);
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
