Shader "Custom/P8/P8_C3"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Smoothness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
        _BumpMap ("NormalMap", 2D) = "bump" {}
        _Occlusion ("Occlusion", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf Standard

        sampler2D _MainTex;
        sampler2D _BumpMap;
        sampler2D _Occlusion;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_BumpMap;
        };

        half _Smoothness;
        half _Metallic;
        fixed4 _Color;

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;

            // 실제 벡터는 [-1, 1], 텍스쳐는 [0, 1] 값을 저장. 따라서 노말 텍스쳐는 압축되어있음
            o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));   // 압축된 노멀벡터를 복원

            // Occlusion은 독립된 UV를 받으면 에러가 남
            // 구석진 부분의 음영을 강조해줌
            o.Occlusion = tex2D(_Occlusion, IN.uv_MainTex);

            o.Metallic = _Metallic;
            o.Smoothness = _Smoothness;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
